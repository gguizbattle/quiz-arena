import {
  WebSocketGateway, WebSocketServer, SubscribeMessage,
  OnGatewayConnection, OnGatewayDisconnect, ConnectedSocket, MessageBody,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { MatchesService, PlayerResult } from '../matches/matches.service';
import { QuestionsService } from '../questions/questions.service';
import { MatchType } from '../database/entities/match.entity';

interface WaitingPlayer {
  socketId: string;
  userId: string;
  username: string;
  elo: number;
}

interface ActiveMatch {
  matchId: string;
  players: { socketId: string; userId: string; username: string; elo: number }[];
  questions: any[];
  results: Map<string, PlayerResult>;
}

@WebSocketGateway({ cors: { origin: '*' }, namespace: '/game' })
export class GameGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Server;

  private waitingPlayers: WaitingPlayer[] = [];
  private activeMatches = new Map<string, ActiveMatch>();
  private socketToMatch = new Map<string, string>();

  constructor(
    private matchesService: MatchesService,
    private questionsService: QuestionsService,
  ) {}

  handleConnection(client: Socket) {
    console.log(`[WS] Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    this.waitingPlayers = this.waitingPlayers.filter(p => p.socketId !== client.id);
    const matchId = this.socketToMatch.get(client.id);
    if (matchId) {
      this.server.to(matchId).emit('opponent:disconnected');
      this.socketToMatch.delete(client.id);
    }
    console.log(`[WS] Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('match:join')
  async handleJoinQueue(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { userId: string; username: string; elo: number },
  ) {
    if (this.waitingPlayers.find(p => p.userId === data.userId)) return;

    const opponent = this.waitingPlayers.find(
      p => p.userId !== data.userId && Math.abs(p.elo - data.elo) <= 200,
    );

    if (opponent) {
      this.waitingPlayers = this.waitingPlayers.filter(p => p.userId !== opponent.userId);
      await this.startMatch(
        { socketId: client.id, ...data },
        opponent,
      );
    } else {
      this.waitingPlayers.push({
        socketId: client.id,
        userId: data.userId,
        username: data.username,
        elo: data.elo,
      });
      client.emit('match:waiting');
    }
  }

  @SubscribeMessage('match:cancel')
  handleCancel(@ConnectedSocket() client: Socket) {
    this.waitingPlayers = this.waitingPlayers.filter(p => p.socketId !== client.id);
  }

  @SubscribeMessage('answer:submit')
  handleAnswer(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: {
      matchId: string;
      questionIndex: number;
      answer: string;
      isCorrect: boolean;
      timeMs: number;
    },
  ) {
    this.server.to(data.matchId).emit('answer:received', {
      socketId: client.id,
      questionIndex: data.questionIndex,
      answer: data.answer,
      isCorrect: data.isCorrect,
      timeMs: data.timeMs,
    });
  }

  @SubscribeMessage('match:complete')
  async handleComplete(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: {
      matchId: string;
      userId: string;
      score: number;
      correctAnswers: number;
    },
  ) {
    const match = this.activeMatches.get(data.matchId);
    if (!match) return;

    match.results.set(data.userId, {
      userId: data.userId,
      score: data.score,
      correctAnswers: data.correctAnswers,
    });

    if (match.results.size === 2) {
      const [a, b] = Array.from(match.results.values());
      try {
        const result = await this.matchesService.finishOneVsOne(data.matchId, a, b);
        this.server.to(data.matchId).emit('match:result', {
          ...result,
          scores: { [a.userId]: a.score, [b.userId]: b.score },
        });
      } catch (e) {
        console.error('[WS] finishOneVsOne failed:', e);
      } finally {
        this.activeMatches.delete(data.matchId);
        for (const p of match.players) {
          this.socketToMatch.delete(p.socketId);
        }
      }
    }
  }

  private async startMatch(playerA: WaitingPlayer, playerB: WaitingPlayer) {
    const match = await this.matchesService.createMatch(MatchType.ONE_VS_ONE);

    // Mobile-də 100 sual var (quiz_questions.dart). Backend yalnız index-ləri seçir.
    const totalQuestions = 100;
    const questionsPerMatch = 10;
    const indices = this.pickRandomIndices(questionsPerMatch, totalQuestions);

    const room = match.id;
    this.server.sockets.sockets.get(playerA.socketId)?.join(room);
    this.server.sockets.sockets.get(playerB.socketId)?.join(room);

    this.activeMatches.set(match.id, {
      matchId: match.id,
      players: [playerA, playerB],
      questions: indices,
      results: new Map(),
    });
    this.socketToMatch.set(playerA.socketId, match.id);
    this.socketToMatch.set(playerB.socketId, match.id);

    this.server.to(room).emit('match:start', {
      matchId: match.id,
      questionIndices: indices,
      opponents: {
        [playerA.userId]: { username: playerB.username, elo: playerB.elo },
        [playerB.userId]: { username: playerA.username, elo: playerA.elo },
      },
    });
  }

  private pickRandomIndices(count: number, total: number): number[] {
    const all = Array.from({ length: total }, (_, i) => i);
    for (let i = all.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [all[i], all[j]] = [all[j], all[i]];
    }
    return all.slice(0, count);
  }
}

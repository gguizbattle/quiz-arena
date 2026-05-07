import {
  WebSocketGateway, WebSocketServer, SubscribeMessage,
  OnGatewayConnection, OnGatewayDisconnect, ConnectedSocket, MessageBody,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { MatchesService } from '../matches/matches.service';
import { QuestionsService } from '../questions/questions.service';
import { MatchType } from '../database/entities/match.entity';

interface WaitingPlayer {
  socketId: string;
  userId: string;
  elo: number;
}

@WebSocketGateway({ cors: { origin: '*' }, namespace: '/game' })
export class GameGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer() server: Server;

  private waitingPlayers: WaitingPlayer[] = [];
  private activeMatches = new Map<string, { players: string[]; questions: any[]; currentQ: number }>();

  constructor(
    private matchesService: MatchesService,
    private questionsService: QuestionsService,
  ) {}

  handleConnection(client: Socket) {
    console.log(`Client connected: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    this.waitingPlayers = this.waitingPlayers.filter(p => p.socketId !== client.id);
    console.log(`Client disconnected: ${client.id}`);
  }

  @SubscribeMessage('match:join')
  async handleJoinQueue(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { userId: string; elo: number },
  ) {
    const existing = this.waitingPlayers.find(p => p.userId === data.userId);
    if (existing) return;

    this.waitingPlayers.push({ socketId: client.id, userId: data.userId, elo: data.elo });

    const opponent = this.waitingPlayers.find(
      p => p.userId !== data.userId && Math.abs(p.elo - data.elo) <= 200,
    );

    if (opponent) {
      this.waitingPlayers = this.waitingPlayers.filter(
        p => p.userId !== data.userId && p.userId !== opponent.userId,
      );
      await this.startMatch(client.id, opponent.socketId, data.userId, opponent.userId);
    } else {
      client.emit('match:waiting');
    }
  }

  @SubscribeMessage('answer:submit')
  handleAnswer(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { matchId: string; answer: string; timeMs: number },
  ) {
    this.server.to(data.matchId).emit('answer:received', {
      socketId: client.id,
      answer: data.answer,
      timeMs: data.timeMs,
    });
  }

  private async startMatch(socketA: string, socketB: string, userA: string, userB: string) {
    const match = await this.matchesService.createMatch(MatchType.ONE_VS_ONE);
    const questions = await this.questionsService.getRandomQuestions(10);

    this.activeMatches.set(match.id, { players: [userA, userB], questions, currentQ: 0 });

    const room = match.id;
    this.server.sockets.sockets.get(socketA)?.join(room);
    this.server.sockets.sockets.get(socketB)?.join(room);

    this.server.to(room).emit('match:start', {
      matchId: match.id,
      question: questions[0],
      questionIndex: 0,
      totalQuestions: questions.length,
    });
  }
}

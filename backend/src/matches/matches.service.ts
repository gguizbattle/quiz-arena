import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Match, MatchType, MatchStatus } from '../database/entities/match.entity';
import { MatchPlayer } from '../database/entities/match-player.entity';

@Injectable()
export class MatchesService {
  constructor(
    @InjectRepository(Match) private matchesRepo: Repository<Match>,
    @InjectRepository(MatchPlayer) private playersRepo: Repository<MatchPlayer>,
  ) {}

  async createMatch(type: MatchType): Promise<Match> {
    const match = this.matchesRepo.create({ type, status: MatchStatus.WAITING });
    return this.matchesRepo.save(match);
  }

  async getUserMatches(userId: string) {
    return this.playersRepo.find({
      where: { user: { id: userId } },
      relations: ['match'],
      order: { match: { started_at: 'DESC' } },
      take: 20,
    });
  }
}

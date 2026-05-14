import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

import { AdminController } from './admin.controller';
import { User } from '../database/entities/user.entity';
import { Match } from '../database/entities/match.entity';
import { MatchPlayer } from '../database/entities/match-player.entity';
import { Leaderboard } from '../database/entities/leaderboard.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, Match, MatchPlayer, Leaderboard])],
  controllers: [AdminController],
})
export class AdminModule {}

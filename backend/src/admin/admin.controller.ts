import {
  Controller, Delete, ForbiddenException, Get, Headers,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { User } from '../database/entities/user.entity';
import { Match } from '../database/entities/match.entity';
import { MatchPlayer } from '../database/entities/match-player.entity';
import { Leaderboard } from '../database/entities/leaderboard.entity';

/**
 * Admin endpoint-ləri yalnız X-Admin-Key header doğru olduqda işləyir.
 * ENV-də `ADMIN_RESET_KEY` təyin etmək olar; əks halda default key
 * yalnız bu sahib üçündür və commitdə görünür (qeyri-sirli).
 */
@Controller('admin')
export class AdminController {
  constructor(
    @InjectRepository(User) private usersRepo: Repository<User>,
    @InjectRepository(Match) private matchesRepo: Repository<Match>,
    @InjectRepository(MatchPlayer) private playersRepo: Repository<MatchPlayer>,
    @InjectRepository(Leaderboard) private leaderboardRepo: Repository<Leaderboard>,
  ) {}

  private assertAdmin(key?: string) {
    const expected = process.env.ADMIN_RESET_KEY ?? 'gguiz-battle-reset-2026';
    if (!key || key !== expected) {
      throw new ForbiddenException('admin_key_required');
    }
  }

  @Get('users')
  async listUsers(@Headers('x-admin-key') key?: string) {
    this.assertAdmin(key);
    const users = await this.usersRepo.find({
      select: {
        id: true,
        username: true,
        email: true,
        avatar: true,
        xp: true,
        level: true,
        coins: true,
        elo: true,
        wins: true,
        losses: true,
        is_premium: true,
        email_verified: true,
        google_id: true,
        apple_id: true,
        facebook_id: true,
        created_at: true,
      },
      order: { created_at: 'DESC' },
    });
    return {
      total: users.length,
      users: users.map((u) => ({
        ...u,
        provider: u.google_id ? 'google'
          : u.apple_id ? 'apple'
          : u.facebook_id ? 'facebook'
          : 'password',
      })),
    };
  }

  @Get('stats')
  async stats(@Headers('x-admin-key') key?: string) {
    this.assertAdmin(key);
    const totalUsers = await this.usersRepo.count();
    const verifiedUsers = await this.usersRepo.count({ where: { email_verified: true } });
    const totalMatches = await this.matchesRepo.count();
    const googleUsers = await this.usersRepo.createQueryBuilder('u').where('u.google_id IS NOT NULL').getCount();
    const facebookUsers = await this.usersRepo.createQueryBuilder('u').where('u.facebook_id IS NOT NULL').getCount();
    const appleUsers = await this.usersRepo.createQueryBuilder('u').where('u.apple_id IS NOT NULL').getCount();
    return {
      users: { total: totalUsers, verified: verifiedUsers, google: googleUsers, facebook: facebookUsers, apple: appleUsers },
      matches: { total: totalMatches },
    };
  }

  @Delete('reset-users')
  async resetAllUsers(@Headers('x-admin-key') key?: string) {
    this.assertAdmin(key);
    // Cascade-ə güvənmədən qaydaya görə sil
    const players = await this.playersRepo.createQueryBuilder().delete().execute();
    const matches = await this.matchesRepo.createQueryBuilder().delete().execute();
    const leaders = await this.leaderboardRepo.createQueryBuilder().delete().execute();
    const users = await this.usersRepo.createQueryBuilder().delete().execute();
    return {
      ok: true,
      deleted: {
        match_players: players.affected ?? 0,
        matches: matches.affected ?? 0,
        leaderboard: leaders.affected ?? 0,
        users: users.affected ?? 0,
      },
    };
  }
}

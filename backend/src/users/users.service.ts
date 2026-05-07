import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../database/entities/user.entity';

@Injectable()
export class UsersService {
  constructor(@InjectRepository(User) private repo: Repository<User>) {}

  async findById(id: string): Promise<User> {
    const user = await this.repo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('User not found');
    return user;
  }

  async getProfile(id: string) {
    return this.findById(id);
  }

  async updateAvatar(id: string, avatar: string) {
    await this.repo.update(id, { avatar });
    return this.findById(id);
  }

  async getLeaderboardPosition(id: string) {
    const user = await this.findById(id);
    return { elo: user.elo, wins: user.wins, losses: user.losses };
  }
}

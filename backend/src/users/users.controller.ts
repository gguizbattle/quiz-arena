import { BadRequestException, Body, ConflictException, Controller, Get, Patch, Post, UseGuards, Request } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('me')
  getMe(@Request() req) {
    return this.usersService.getProfile(req.user.id);
  }

  @Post('me/reward')
  applyReward(
    @Request() req,
    @Body() body: { xp?: number; coins?: number; wins?: number; losses?: number; draws?: number },
  ) {
    return this.usersService.applyLocalReward(req.user.id, body);
  }

  @Patch('me/username')
  async setUsername(@Request() req, @Body() body: { username?: string }) {
    const raw = (body?.username ?? '').trim();
    if (raw.length < 3) throw new BadRequestException('min_three_chars');
    if (!/^[a-zA-Z0-9_]+$/.test(raw)) throw new BadRequestException('username_format');
    try {
      return await this.usersService.changeUsername(req.user.id, raw);
    } catch (e: any) {
      if (e?.message === 'username_taken') throw new ConflictException('username_taken');
      throw e;
    }
  }
}

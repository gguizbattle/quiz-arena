import { Body, Controller, Get, Post, UseGuards, Request } from '@nestjs/common';
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
}

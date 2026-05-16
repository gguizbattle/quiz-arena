import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FriendsController } from './friends.controller';
import { FriendsService } from './friends.service';
import { User } from '../database/entities/user.entity';
import { Friendship } from '../database/entities/friendship.entity';
import { RealtimeModule } from '../websocket/realtime.module';

@Module({
  imports: [TypeOrmModule.forFeature([User, Friendship]), RealtimeModule],
  controllers: [FriendsController],
  providers: [FriendsService],
  exports: [FriendsService],
})
export class FriendsModule {}

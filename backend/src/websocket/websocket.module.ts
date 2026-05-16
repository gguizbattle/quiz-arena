import { Module } from '@nestjs/common';
import { GameGateway } from './game.gateway';
import { ChatGateway } from './chat.gateway';
import { MatchesModule } from '../matches/matches.module';
import { QuestionsModule } from '../questions/questions.module';
import { FriendsModule } from '../friends/friends.module';

@Module({
  imports: [MatchesModule, QuestionsModule, FriendsModule],
  providers: [GameGateway, ChatGateway],
})
export class WebsocketModule {}

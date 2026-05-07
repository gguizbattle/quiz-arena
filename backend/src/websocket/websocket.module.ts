import { Module } from '@nestjs/common';
import { GameGateway } from './game.gateway';
import { MatchesModule } from '../matches/matches.module';
import { QuestionsModule } from '../questions/questions.module';

@Module({
  imports: [MatchesModule, QuestionsModule],
  providers: [GameGateway],
})
export class WebsocketModule {}

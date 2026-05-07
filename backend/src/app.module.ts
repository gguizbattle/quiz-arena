import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { QuestionsModule } from './questions/questions.module';
import { MatchesModule } from './matches/matches.module';
import { LeaderboardModule } from './leaderboard/leaderboard.module';
import { WebsocketModule } from './websocket/websocket.module';
import { User } from './database/entities/user.entity';
import { Category } from './database/entities/category.entity';
import { Question } from './database/entities/question.entity';
import { Match } from './database/entities/match.entity';
import { MatchPlayer } from './database/entities/match-player.entity';
import { Leaderboard } from './database/entities/leaderboard.entity';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get('DATABASE_HOST'),
        port: +config.get('DATABASE_PORT'),
        database: config.get('DATABASE_NAME'),
        username: config.get('DATABASE_USER'),
        password: config.get('DATABASE_PASSWORD'),
        entities: [User, Category, Question, Match, MatchPlayer, Leaderboard],
        synchronize: config.get('NODE_ENV') === 'development',
        logging: false,
      }),
    }),
    AuthModule,
    UsersModule,
    QuestionsModule,
    MatchesModule,
    LeaderboardModule,
    WebsocketModule,
  ],
})
export class AppModule {}

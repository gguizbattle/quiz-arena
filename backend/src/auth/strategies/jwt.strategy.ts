import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { passportJwtSecret } from 'jwks-rsa';
import { User } from '../../database/entities/user.entity';

/// Supabase Auth JWT-lərini doğrulayır.
///
/// Supabase yeni layihələrdə ES256 imzalı token verir. Public açar
/// JWKS endpoint-dən gəlir (kid-ə görə cache olunur). jwks-rsa ES256/RS256/HS256
/// üçün uyğun açarı qaytarır, sonra passport-jwt jsonwebtoken ilə yoxlayır.
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    config: ConfigService,
    @InjectRepository(User) private usersRepo: Repository<User>,
  ) {
    const supabaseUrl = config.get<string>('SUPABASE_URL');
    if (!supabaseUrl) {
      throw new Error('SUPABASE_URL environment variable tələb olunur');
    }

    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKeyProvider: passportJwtSecret({
        jwksUri: `${supabaseUrl}/auth/v1/.well-known/jwks.json`,
        cache: true,
        cacheMaxAge: 24 * 60 * 60 * 1000, // 24 saat
        rateLimit: true,
        jwksRequestsPerMinute: 10,
      }),
      algorithms: ['ES256', 'RS256', 'HS256'],
      audience: 'authenticated',
    });
  }

  async validate(payload: { sub: string; email?: string; role?: string }) {
    // Token artıq doğrulanıb. `sub` = auth.users.id (UUID).
    // DB trigger public.users-da eyni id ilə profil yaradır.
    const user = await this.usersRepo.findOne({ where: { id: payload.sub } });
    if (!user) {
      // Trigger gecikmiş ola bilər — yenidən cəhd üçün 401
      throw new UnauthorizedException('profile_not_found');
    }
    return user;
  }
}

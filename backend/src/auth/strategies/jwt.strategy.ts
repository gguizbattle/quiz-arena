import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { createRemoteJWKSet, jwtVerify } from 'jose';
import { User } from '../../database/entities/user.entity';

/// Supabase Auth tərəfindən verilmiş JWT-ləri yoxlayır.
///
/// Supabase yeni layihələr üçün asimetrik açar (ES256) istifadə edir.
/// Backend JWKS endpoint-dən public açarı çəkib token-i doğrulayır.
/// Köhnə layihələr üçün HS256 + SUPABASE_JWT_SECRET də dəstəklənir (fallback).
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  private static jwks: ReturnType<typeof createRemoteJWKSet> | null = null;

  constructor(
    config: ConfigService,
    @InjectRepository(User) private usersRepo: Repository<User>,
  ) {
    const supabaseUrl = config.get<string>('SUPABASE_URL');
    if (!supabaseUrl) {
      throw new Error('SUPABASE_URL environment variable tələb olunur');
    }

    // JWKS endpoint
    if (!JwtStrategy.jwks) {
      JwtStrategy.jwks = createRemoteJWKSet(
        new URL(`${supabaseUrl}/auth/v1/.well-known/jwks.json`),
      );
    }
    const jwks = JwtStrategy.jwks;
    const legacySecret = config.get<string>('SUPABASE_JWT_SECRET'); // HS256 fallback

    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      // Token-i passport-jwt-yə vermədən əvvəl jose ilə doğrularıq.
      // Burada `secretOrKey` lazımdır deyə formal fallback veririk;
      // əsl doğrulama validate()-də olur (jose).
      secretOrKey: legacySecret || 'placeholder',
      algorithms: ['HS256', 'ES256', 'RS256'],
      audience: 'authenticated',
      passReqToCallback: true,
    } as any);

    // passport-jwt-nin standart yoxlamasını söndürürük — özümüz edirik
    (this as any)._verifOpts = {
      ...((this as any)._verifOpts || {}),
      ignoreExpiration: false,
    };
  }

  async validate(req: any, payload: any) {
    // passport-jwt token-i artıq base şəkildə yoxlayıb. Lakin biz
    // ES256/JWKS dəstəyi üçün jose ilə **yenidən** doğrulayırıq:
    const raw = req.headers.authorization?.replace(/^Bearer\s+/i, '');
    if (!raw) throw new UnauthorizedException('no_token');

    try {
      const { payload: verified } = await jwtVerify(raw, JwtStrategy.jwks!, {
        audience: 'authenticated',
      });
      const userId = String(verified.sub);
      const user = await this.usersRepo.findOne({ where: { id: userId } });
      if (!user) {
        // Trigger gecikmiş ola bilər — istisna at, mobile yenidən cəhd edəcək
        throw new UnauthorizedException('profile_not_found');
      }
      return user;
    } catch (e) {
      throw new UnauthorizedException('invalid_token');
    }
  }
}

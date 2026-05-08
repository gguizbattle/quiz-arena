import { Controller, Post, Body, UseGuards, Request, HttpCode } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  register(@Body() dto: RegisterDto) {
    return this.authService.register(dto);
  }

  @Post('verify-otp')
  @HttpCode(200)
  verifyOtp(@Body() body: { email: string; code: string }) {
    return this.authService.verifyOtp(body.email, body.code);
  }

  @Post('resend-otp')
  @HttpCode(200)
  resendOtp(@Body() body: { email: string }) {
    return this.authService.resendOtp(body.email);
  }

  @Post('login')
  @HttpCode(200)
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('refresh')
  @HttpCode(200)
  refresh(@Body() body: { user_id: string; refresh_token: string }) {
    return this.authService.refreshTokens(body.user_id, body.refresh_token);
  }

  @UseGuards(JwtAuthGuard)
  @Post('logout')
  @HttpCode(200)
  logout(@Request() req) {
    return this.authService.logout(req.user.id);
  }
}

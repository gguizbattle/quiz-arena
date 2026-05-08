import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private transporter: nodemailer.Transporter | null = null;

  constructor(private config: ConfigService) {
    const user = this.config.get<string>('SMTP_USER');
    const pass = this.config.get<string>('SMTP_PASS');
    if (user && pass) {
      this.transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 465,
        secure: true,
        auth: { user, pass },
      });
    }
  }

  async sendOtp(to: string, code: string): Promise<void> {
    if (!this.transporter) {
      this.logger.warn(`[EMAIL DISABLED] OTP for ${to}: ${code}`);
      return;
    }
    const from = this.config.get<string>('SMTP_USER');
    const html = `
      <div style="font-family: -apple-system, system-ui, sans-serif; max-width: 480px; margin: 0 auto; padding: 24px; background: #0F1020; color: #fff;">
        <div style="text-align: center; margin-bottom: 24px;">
          <div style="display: inline-block; width: 64px; height: 64px; background: linear-gradient(135deg, #4A2ADB, #7B5CFF); border-radius: 18px; line-height: 64px; font-size: 32px; font-weight: 900;">G</div>
        </div>
        <h2 style="text-align: center; margin: 0 0 8px;">Quiz Arena</h2>
        <p style="text-align: center; color: #888; margin: 0 0 32px;">E-poçt təsdiqi</p>
        <div style="background: #1A1B30; border-radius: 12px; padding: 24px; text-align: center; border: 1px solid #2A2A50;">
          <p style="margin: 0 0 12px; color: #aaa; font-size: 14px;">Təsdiq kodunuz:</p>
          <div style="font-size: 36px; font-weight: 900; letter-spacing: 8px; color: #7B5CFF;">${code}</div>
          <p style="margin: 16px 0 0; color: #666; font-size: 12px;">10 dəqiqə ərzində istifadə edin</p>
        </div>
        <p style="text-align: center; color: #555; font-size: 12px; margin-top: 24px;">
          Bu e-poçtu siz tələb etmədiniz? Onu nəzərə almayın.
        </p>
      </div>
    `;
    try {
      await this.transporter.sendMail({
        from: `"Quiz Arena" <${from}>`,
        to,
        subject: 'Quiz Arena — E-poçt təsdiqi',
        html,
        text: `Quiz Arena təsdiq kodu: ${code}\n10 dəqiqə ərzində istifadə edin.`,
      });
      this.logger.log(`OTP sent to ${to}`);
    } catch (e) {
      this.logger.error(`Email send failed: ${e}`);
      throw e;
    }
  }
}

import {
  Entity, PrimaryGeneratedColumn, Column, CreateDateColumn,
  OneToMany, Index,
} from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Index({ unique: true })
  @Column({ length: 30 })
  username: string;

  @Index({ unique: true })
  @Column({ nullable: true })
  email: string;

  @Column({ nullable: true })
  phone: string;

  @Column({ nullable: true, select: false })
  password_hash: string;

  @Column({ nullable: true })
  avatar: string;

  @Column({ default: 0 })
  xp: number;

  @Column({ default: 1 })
  level: number;

  @Column({ default: 0 })
  coins: number;

  @Column({ default: 1000 })
  elo: number;

  @Column({ default: 0 })
  wins: number;

  @Column({ default: 0 })
  losses: number;

  @Column({ default: false })
  is_premium: boolean;

  @Column({ default: false })
  email_verified: boolean;

  @Column({ nullable: true })
  google_id: string;

  @Column({ nullable: true })
  apple_id: string;

  @Column({ nullable: true, type: 'text' })
  refresh_token: string | null;

  @CreateDateColumn()
  created_at: Date;
}

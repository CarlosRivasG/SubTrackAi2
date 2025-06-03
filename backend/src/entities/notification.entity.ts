import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from './user.entity';
import { Subscription } from './subscription.entity';

@Entity()
export class Notification {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  type: string; // 'payment_due', 'payment_success', 'subscription_expiring', etc.

  @Column()
  title: string;

  @Column()
  message: string;

  @Column({ default: false })
  isRead: boolean;

  @Column({ nullable: true })
  actionUrl: string;

  @ManyToOne(() => User, user => user.notifications)
  user: User;

  @ManyToOne(() => Subscription, { nullable: true })
  subscription: Subscription;

  @CreateDateColumn()
  createdAt: Date;
} 
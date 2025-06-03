import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from './user.entity';
import { Subscription } from './subscription.entity';

@Entity()
export class Payment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column()
  status: string; // 'pending', 'completed', 'failed'

  @Column({ nullable: true })
  paymentMethod: string;

  @Column({ nullable: true })
  transactionId: string;

  @Column({ type: 'date' })
  paymentDate: Date;

  @ManyToOne(() => User, user => user.payments)
  user: User;

  @ManyToOne(() => Subscription, subscription => subscription.payments)
  subscription: Subscription;

  @CreateDateColumn()
  createdAt: Date;
} 
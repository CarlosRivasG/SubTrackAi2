import { Entity, Column, PrimaryGeneratedColumn, ManyToOne, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from './user.entity';
import { Category } from './category.entity';
import { Payment } from './payment.entity';
import { Product } from './product.entity';

@Entity()
export class Subscription {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Product, product => product.subscriptions)
  product: Product;

  @Column({ nullable: true })
  description: string;

  @Column('decimal', { precision: 10, scale: 2 })
  price: number;

  @Column()
  billingCycle: string; // monthly, yearly, etc.

  @Column()
  nextBillingDate: Date;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => User, user => user.subscriptions)
  user: User;

  @ManyToOne(() => Category, category => category.subscriptions)
  category: Category;

  @OneToMany(() => Payment, payment => payment.subscription)
  payments: Payment[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
} 
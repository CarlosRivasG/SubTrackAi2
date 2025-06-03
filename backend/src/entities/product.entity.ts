import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Subscription } from './subscription.entity';

@Entity()
export class Product {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  name: string;

  @Column({ nullable: true })
  iconUrl: string;

   @Column({ type: 'text', nullable: true })
   description: string;

  @OneToMany(() => Subscription, subscription => subscription.product)
  subscriptions: Subscription[];
} 
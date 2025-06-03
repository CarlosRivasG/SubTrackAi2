import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PaymentsService } from '../services/payments.service';
import { PaymentsController } from 'src/controllers/payments.controller';
import { Payment } from 'src/entities/payment.entity';
import { SubscriptionsModule } from './subscriptions.module';
import { NotificationsModule } from './notifications.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Payment]),
    SubscriptionsModule,
    NotificationsModule,
  ],
  controllers: [PaymentsController],
  providers: [PaymentsService],
  exports: [PaymentsService],
})
export class PaymentsModule {} 
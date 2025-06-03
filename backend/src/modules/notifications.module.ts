import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NotificationsService } from '../services/notifications.service';
import { NotificationsController } from 'src/controllers/notifications.controller';
import { Notification } from 'src/entities/notification.entity';
import { SubscriptionsModule } from './subscriptions.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Notification]),
    forwardRef(() => SubscriptionsModule),
  ],
  controllers: [NotificationsController],
  providers: [NotificationsService],
  exports: [NotificationsService],
})
export class NotificationsModule {} 

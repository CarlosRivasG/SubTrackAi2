import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SubscriptionsService } from 'src/services/subscriptions.service';
import { SubscriptionsController } from 'src/controllers/subscriptions.controller';
import { Subscription } from '../entities/subscription.entity';
import { CategoriesModule } from './categories.module';
import { NotificationsModule } from './notifications.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Subscription]),
    CategoriesModule,
    forwardRef(() => NotificationsModule),
  ],
  controllers: [SubscriptionsController],
  providers: [SubscriptionsService],
  exports: [SubscriptionsService],
})
export class SubscriptionsModule {} 
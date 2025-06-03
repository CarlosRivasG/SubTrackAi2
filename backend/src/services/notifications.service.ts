import { Injectable, NotFoundException, Inject, forwardRef } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThanOrEqual } from 'typeorm';
import { CreateNotificationDto } from '../dto/notifications_dto/create-notification.dto';
import { User } from '../entities/user.entity';
import { SubscriptionsService } from './subscriptions.service';
import { Subscription } from '../entities/subscription.entity';
import { Notification } from '../entities/notification.entity';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Notification)
    private notificationsRepository: Repository<Notification>,
    @Inject(forwardRef(() => SubscriptionsService))
    private subscriptionsService: SubscriptionsService,
  ) {}

  async create(createNotificationDto: CreateNotificationDto, user: User): Promise<Notification> {
    let subscription: Subscription | null = null;
    if (createNotificationDto.subscriptionId) {
      subscription = await this.subscriptionsService.findOne(createNotificationDto.subscriptionId, user);
    }

    const notification = this.notificationsRepository.create({
      ...createNotificationDto,
      user,
      subscription: subscription || undefined,
    });

    return this.notificationsRepository.save(notification);
  }

  async findAll(user: User): Promise<Notification[]> {
    return this.notificationsRepository.find({
      where: { user: { id: user.id } },
      relations: ['subscription'],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string, user: User): Promise<Notification> {
    const notification = await this.notificationsRepository.findOne({
      where: { id, user: { id: user.id } },
      relations: ['subscription'],
    });

    if (!notification) {
      throw new NotFoundException('Notificación no encontrada');
    }

    return notification;
  }

  async markAsRead(id: string, user: User): Promise<Notification> {
    const notification = await this.findOne(id, user);
    notification.isRead = true;
    return this.notificationsRepository.save(notification);
  }

  async markAllAsRead(user: User): Promise<void> {
    await this.notificationsRepository.update(
      { user: { id: user.id }, isRead: false },
      { isRead: true },
    );
  }

  async getUnreadCount(user: User): Promise<number> {
    return this.notificationsRepository.count({
      where: { user: { id: user.id }, isRead: false },
    });
  }

  async createPaymentDueNotification(user: User, subscription: any): Promise<Notification> {
    const daysUntilDue = Math.ceil(
      (subscription.nextBillingDate.getTime() - new Date().getTime()) / (1000 * 60 * 60 * 24),
    );

    return this.create(
      {
        type: 'payment_due',
        title: 'Pago próximo',
        message: `El pago de ${subscription.name} vence en ${daysUntilDue} días`,
        actionUrl: `/subscriptions/${subscription.id}`,
        subscriptionId: subscription.id,
      },
      user,
    );
  }

  async createPaymentSuccessNotification(user: User, payment: any): Promise<Notification> {
    return this.create(
      {
        type: 'payment_success',
        title: 'Pago exitoso',
        message: `El pago de ${payment.subscription.name} se ha realizado correctamente`,
        actionUrl: `/payments/${payment.id}`,
        subscriptionId: payment.subscription.id,
      },
      user,
    );
  }

  async createPaymentFailedNotification(user: User, payment: any): Promise<Notification> {
    return this.create(
      {
        type: 'payment_failed',
        title: 'Pago fallido',
        message: `El pago de ${payment.subscription.name} ha fallado`,
        actionUrl: `/payments/${payment.id}`,
        subscriptionId: payment.subscription.id,
      },
      user,
    );
  }

  async deleteOldNotifications(user: User, days: number = 30): Promise<void> {
    const date = new Date();
    date.setDate(date.getDate() - days);

    await this.notificationsRepository.delete({
      user: { id: user.id },
      createdAt: LessThanOrEqual(date),
      isRead: true,
    });
  }
} 
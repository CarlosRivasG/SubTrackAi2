import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Subscription } from '../entities/subscription.entity';
import { CreateSubscriptionDto } from 'src/dto/subcription_dto/create-subscription.dto';
import { User } from '../entities/user.entity';
import { Between } from 'typeorm';

@Injectable()
export class SubscriptionsService {
  constructor(
    @InjectRepository(Subscription)
    private subscriptionsRepository: Repository<Subscription>,
  ) {}

  async create(createSubscriptionDto: CreateSubscriptionDto, user: User): Promise<Subscription> {
    const subscription = this.subscriptionsRepository.create({
      ...createSubscriptionDto,
      user,
    });
    return this.subscriptionsRepository.save(subscription);
  }

  async findAll(user: User): Promise<Subscription[]> {
    return this.subscriptionsRepository.find({
      where: { user: { id: user.id } },
      order: { nextBillingDate: 'ASC' },
    });
  }

  async findOne(id: string, user: User): Promise<Subscription> {
    const subscription = await this.subscriptionsRepository.findOne({
      where: { id, user: { id: user.id } },
    });
    if (!subscription) {
      throw new NotFoundException('Suscripción no encontrada');
    }
    return subscription;
  }

  async getDashboardMetrics(user: User) {
    const subscriptions = await this.findAll(user);
    const activeSubscriptions = subscriptions.filter(sub => sub.isActive);
    
    const totalSubscriptions = activeSubscriptions.length;
    const monthlySpending = activeSubscriptions.reduce((acc, sub) => {
      if (sub.billingCycle === 'monthly') {
        return acc + Number(sub.price);
      } else if (sub.billingCycle === 'yearly') {
        return acc + (Number(sub.price) / 12);
      }
      return acc;
    }, 0);

    const nextPayment = activeSubscriptions
      .sort((a, b) => a.nextBillingDate.getTime() - b.nextBillingDate.getTime())[0];

    return {
      totalSubscriptions,
      monthlySpending: Number(monthlySpending.toFixed(2)),
      nextPayment: nextPayment ? {
        name: nextPayment.product,
        amount: nextPayment.price,
        date: nextPayment.nextBillingDate,
      } : null,
    };
  }

  async getUpcomingPayments(user: User): Promise<Subscription[]> {
    const now = new Date();
    const thirtyDaysFromNow = new Date(now.getTime() + 30 * 24 * 60 * 60 * 1000);

    return this.subscriptionsRepository.find({
      where: {
        user: { id: user.id },
        isActive: true,
        nextBillingDate: Between(now, thirtyDaysFromNow),
      },
      order: { nextBillingDate: 'ASC' },
    });
  }

  // Nueva función para encontrar suscripciones por ID de usuario
  async findByUserId(userId: string): Promise<Subscription[]> {
    return this.subscriptionsRepository.find({
      where: { user: { id: userId } },
      order: { nextBillingDate: 'ASC' }, // Opcional: ordenar como en findAll
    });
  }
} 
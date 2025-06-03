import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Payment } from 'src/entities/payment.entity';
import { CreatePaymentDto } from '../dto/payment_dto/create-payment.dto';
import { User } from '../entities/user.entity';
import { SubscriptionsService } from './subscriptions.service';

@Injectable()
export class PaymentsService {
  constructor(
    @InjectRepository(Payment)
    private paymentsRepository: Repository<Payment>,
    private subscriptionsService: SubscriptionsService,
  ) {}

  async create(createPaymentDto: CreatePaymentDto, user: User): Promise<Payment> {
    const subscription = await this.subscriptionsService.findOne(createPaymentDto.subscriptionId, user);
    
    const payment = this.paymentsRepository.create({
      ...createPaymentDto,
      user,
      subscription,
    });

    return this.paymentsRepository.save(payment);
  }

  async findAll(user: User): Promise<Payment[]> {
    return this.paymentsRepository.find({
      where: { user: { id: user.id } },
      relations: ['subscription'],
      order: { paymentDate: 'DESC' },
    });
  }

  async findOne(id: string, user: User): Promise<Payment> {
    const payment = await this.paymentsRepository.findOne({
      where: { id, user: { id: user.id } },
      relations: ['subscription'],
    });

    if (!payment) {
      throw new NotFoundException('Pago no encontrado');
    }

    return payment;
  }

  async getPaymentsByDateRange(user: User, startDate: Date, endDate: Date): Promise<Payment[]> {
    return this.paymentsRepository.find({
      where: {
        user: { id: user.id },
        paymentDate: Between(startDate, endDate),
      },
      relations: ['subscription'],
      order: { paymentDate: 'DESC' },
    });
  }

  async getPaymentsBySubscription(user: User, subscriptionId: string): Promise<Payment[]> {
    return this.paymentsRepository.find({
      where: {
        user: { id: user.id },
        subscription: { id: subscriptionId },
      },
      order: { paymentDate: 'DESC' },
    });
  }

  async getPaymentStats(user: User) {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
    const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);

    const monthlyPayments = await this.getPaymentsByDateRange(user, startOfMonth, endOfMonth);
    
    const totalSpent = monthlyPayments.reduce((acc, payment) => {
      if (payment.status === 'completed') {
        return acc + Number(payment.amount);
      }
      return acc;
    }, 0);

    const pendingPayments = monthlyPayments.filter(payment => payment.status === 'pending');
    const failedPayments = monthlyPayments.filter(payment => payment.status === 'failed');

    return {
      totalSpent: Number(totalSpent.toFixed(2)),
      pendingPayments: pendingPayments.length,
      failedPayments: failedPayments.length,
      totalPayments: monthlyPayments.length,
    };
  }
} 
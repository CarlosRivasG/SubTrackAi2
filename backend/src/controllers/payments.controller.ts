import { Controller, Get, Post, Body, Param, UseGuards, Request, Query } from '@nestjs/common';
import { PaymentsService } from 'src/services/payments.service';
import { CreatePaymentDto } from 'src/dto/payment_dto/create-payment.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('payments')
@UseGuards(JwtAuthGuard)
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post()
  create(@Body() createPaymentDto: CreatePaymentDto, @Request() req) {
    return this.paymentsService.create(createPaymentDto, req.user);
  }

  @Get()
  findAll(@Request() req) {
    return this.paymentsService.findAll(req.user);
  }

  @Get('stats')
  getPaymentStats(@Request() req) {
    return this.paymentsService.getPaymentStats(req.user);
  }

  @Get('subscription/:subscriptionId')
  getPaymentsBySubscription(
    @Param('subscriptionId') subscriptionId: string,
    @Request() req,
  ) {
    return this.paymentsService.getPaymentsBySubscription(req.user, subscriptionId);
  }

  @Get('range')
  getPaymentsByDateRange(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
    @Request() req,
  ) {
    return this.paymentsService.getPaymentsByDateRange(
      req.user,
      new Date(startDate),
      new Date(endDate),
    );
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Request() req) {
    return this.paymentsService.findOne(id, req.user);
  }
} 
import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { SubscriptionsService } from 'src/services/subscriptions.service';
import { CreateSubscriptionDto } from 'src/dto/subcription_dto/create-subscription.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('subscriptions')
@UseGuards(JwtAuthGuard)
export class SubscriptionsController {
  constructor(private readonly subscriptionsService: SubscriptionsService) {}

  @Post('create')
  create(@Body() createSubscriptionDto: CreateSubscriptionDto, @Request() req) {
    return this.subscriptionsService.create(createSubscriptionDto, req.user);
  }

  @Get()
  findAll(@Request() req) {
    return this.subscriptionsService.findAll(req.user);
  }

  @Get('dashboard')
  getDashboardMetrics(@Request() req) {
    return this.subscriptionsService.getDashboardMetrics(req.user);
  }

  @Get('upcoming')
  getUpcomingPayments(@Request() req) {
    return this.subscriptionsService.getUpcomingPayments(req.user);
  }
} 
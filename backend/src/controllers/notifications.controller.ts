import { Controller, Get, Post, Body, Param, UseGuards, Request, Patch, Delete } from '@nestjs/common';
import { NotificationsService } from 'src/services/notifications.service';
import { CreateNotificationDto } from 'src/dto/notifications_dto/create-notification.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('notifications')
@UseGuards(JwtAuthGuard)
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Post()
  create(@Body() createNotificationDto: CreateNotificationDto, @Request() req) {
    return this.notificationsService.create(createNotificationDto, req.user);
  }

  @Get()
  findAll(@Request() req) {
    return this.notificationsService.findAll(req.user);
  }

  @Get('unread/count')
  getUnreadCount(@Request() req) {
    return this.notificationsService.getUnreadCount(req.user);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Request() req) {
    return this.notificationsService.findOne(id, req.user);
  }

  @Patch(':id/read')
  markAsRead(@Param('id') id: string, @Request() req) {
    return this.notificationsService.markAsRead(id, req.user);
  }

  @Patch('read-all')
  markAllAsRead(@Request() req) {
    return this.notificationsService.markAllAsRead(req.user);
  }

  @Delete('old')
  deleteOldNotifications(@Request() req) {
    return this.notificationsService.deleteOldNotifications(req.user);
  }
} 
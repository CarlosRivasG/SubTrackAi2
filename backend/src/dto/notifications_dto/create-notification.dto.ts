import { IsString, IsUUID, IsOptional, IsBoolean } from 'class-validator';

export class CreateNotificationDto {
  @IsString()
  type: string;

  @IsString()
  title: string;

  @IsString()
  message: string;

  @IsBoolean()
  @IsOptional()
  isRead?: boolean;

  @IsString()
  @IsOptional()
  actionUrl?: string;

  @IsUUID()
  @IsOptional()
  subscriptionId?: string;
} 
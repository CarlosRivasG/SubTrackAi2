import { IsString, IsNumber, IsDate, IsOptional, IsBoolean, IsUUID } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateSubscriptionDto {
  @IsString()
  @IsUUID()
  productId: string;

  @IsString()
  @IsUUID()
  categoryId: string;

  @IsNumber()
  price: number;

  @IsString()
  billingCycle: string;

  @Type(() => Date)
  @IsDate()
  nextBillingDate: Date;

  @IsString()
  @IsOptional()
  description?: string;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
} 
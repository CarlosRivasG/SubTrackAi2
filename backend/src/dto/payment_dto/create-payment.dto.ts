import { IsNumber, IsString, IsDate, IsOptional, IsUUID } from 'class-validator';

export class CreatePaymentDto {
  @IsNumber()
  amount: number;

  @IsString()
  status: string;

  @IsString()
  @IsOptional()
  paymentMethod?: string;

  @IsString()
  @IsOptional()
  transactionId?: string;

  @IsDate()
  paymentDate: Date;

  @IsUUID()
  subscriptionId: string;
} 
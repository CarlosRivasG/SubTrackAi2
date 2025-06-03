import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Product } from '../entities/product.entity';
import { ProductsService } from 'src/services/products.service';
import { ProductsController } from 'src/controllers/products.controller';

@Module({
  imports: [
    TypeOrmModule.forFeature([Product]),
  ],
  providers: [ProductsService],
  controllers: [ProductsController],
  exports: [ProductsService]
})
export class ProductsModule {} 
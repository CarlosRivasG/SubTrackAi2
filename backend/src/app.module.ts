import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { UsersModule } from './modules/users.module';
import { SubscriptionsModule } from './modules/subscriptions.module';
import { PaymentsModule } from './modules/payments.module';
import { NotificationsModule } from './modules/notifications.module';
import { CategoriesModule } from './modules/categories.module';
import { AuthModule } from './auth/auth.module';
import { ProductsModule } from './modules/products.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get('DB_HOST', 'localhost'),
        port: +configService.get<number>('DB_PORT', 5432),
        username: configService.get('DB_USERNAME', 'postgres'),
        password: configService.get('DB_PASSWORD', '3112'),
        database: configService.get('DB_DATABASE', 'subtrack_ai'),
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        synchronize: configService.get('NODE_ENV') !== 'production',
        logging: configService.get('NODE_ENV') !== 'production',
      }),
      inject: [ConfigService],
    }),
    UsersModule,
    SubscriptionsModule,
    PaymentsModule,
    NotificationsModule,
    CategoriesModule,
    AuthModule,
    ProductsModule,
  ],
})
export class AppModule {}

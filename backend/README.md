# SubTrack AI - Backend

## Estructura del Proyecto

### Módulos Principales

1. **Users Module**
   - Gestión de usuarios
   - Autenticación y autorización
   - Perfiles de usuario

2. **Subscriptions Module**
   - Gestión de suscripciones
   - Métricas del dashboard
   - Próximos pagos

3. **Payments Module**
   - Registro de pagos
   - Historial de transacciones
   - Estado de pagos

4. **Notifications Module**
   - Notificaciones del sistema
   - Alertas de pagos
   - Notificaciones personalizadas

5. **Categories Module**
   - Categorización de suscripciones
   - Estadísticas por categoría
   - Categorías predeterminadas

### Entidades Principales

1. **User**
   - id: UUID
   - email: string
   - password: string
   - name: string
   - createdAt: Date
   - updatedAt: Date

2. **Subscription**
   - id: UUID
   - name: string
   - price: number
   - billingCycle: string
   - nextBillingDate: Date
   - isActive: boolean
   - category: Category
   - user: User

3. **Payment**
   - id: UUID
   - amount: number
   - status: string
   - date: Date
   - subscription: Subscription
   - user: User

4. **Notification**
   - id: UUID
   - type: string
   - title: string
   - message: string
   - isRead: boolean
   - user: User
   - subscription: Subscription

5. **Category**
   - id: UUID
   - name: string
   - description: string
   - icon: string
   - color: string

### Configuración

1. **Base de Datos**
   ```typescript
   // app.module.ts
   TypeOrmModule.forRootAsync({
     type: 'postgres',
     host: configService.get('DB_HOST', 'localhost'),
     port: +configService.get<number>('DB_PORT', 5432),
     username: configService.get('DB_USERNAME', 'postgres'),
     password: configService.get('DB_PASSWORD', 'postgres'),
     database: configService.get('DB_DATABASE', 'subtrack_ai'),
     entities: [__dirname + '/**/*.entity{.ts,.js}'],
     synchronize: configService.get('NODE_ENV') !== 'production',
   })
   ```

2. **Autenticación**
   - JWT para tokens de acceso
   - Passport para estrategias de autenticación
   - Guards para protección de rutas

### Endpoints Principales

1. **Auth**
   - POST /auth/login - Inicio de sesión

2. **Users**
   - GET /users/profile - Perfil de usuario
   - PATCH /users/profile - Actualizar perfil

3. **Subscriptions**
   - GET /subscriptions - Listar suscripciones
   - POST /subscriptions - Crear suscripción
   - GET /subscriptions/dashboard - Métricas del dashboard
   - GET /subscriptions/upcoming - Próximos pagos

4. **Payments**
   - GET /payments - Historial de pagos
   - POST /payments - Registrar pago
   - GET /payments/:id - Detalles de pago

5. **Notifications**
   - GET /notifications - Listar notificaciones
   - PATCH /notifications/:id/read - Marcar como leída
   - GET /notifications/unread/count - Contador de no leídas

6. **Categories**
   - GET /categories - Listar categorías
   - POST /categories - Crear categoría
   - GET /categories/stats - Estadísticas por categoría

### Instalación

1. Clonar el repositorio
2. Instalar dependencias:
   ```bash
   npm install
   ```
3. Configurar variables de entorno:
   ```env
   DB_HOST=localhost
   DB_PORT=5432
   DB_USERNAME=postgres
   DB_PASSWORD=postgres
   DB_DATABASE=subtrack_ai
   JWT_SECRET=your-secret-key
   NODE_ENV=development
   ```
4. Iniciar la aplicación:
   ```bash
   npm run start:dev
   ```

### Dependencias Principales

- @nestjs/common
- @nestjs/config
- @nestjs/typeorm
- @nestjs/jwt
- @nestjs/passport
- typeorm
- pg
- passport
- passport-jwt
- passport-local

<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="120" alt="Nest Logo" /></a>
</p>

[circleci-image]: https://img.shields.io/circleci/build/github/nestjs/nest/master?token=abc123def456
[circleci-url]: https://circleci.com/gh/nestjs/nest

  <p align="center">A progressive <a href="http://nodejs.org" target="_blank">Node.js</a> framework for building efficient and scalable server-side applications.</p>
    <p align="center">
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/v/@nestjs/core.svg" alt="NPM Version" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/l/@nestjs/core.svg" alt="Package License" /></a>
<a href="https://www.npmjs.com/~nestjscore" target="_blank"><img src="https://img.shields.io/npm/dm/@nestjs/common.svg" alt="NPM Downloads" /></a>
<a href="https://circleci.com/gh/nestjs/nest" target="_blank"><img src="https://img.shields.io/circleci/build/github/nestjs/nest/master" alt="CircleCI" /></a>
<a href="https://discord.gg/G7Qnnhy" target="_blank"><img src="https://img.shields.io/badge/discord-online-brightgreen.svg" alt="Discord"/></a>
<a href="https://opencollective.com/nest#backer" target="_blank"><img src="https://opencollective.com/nest/backers/badge.svg" alt="Backers on Open Collective" /></a>
<a href="https://opencollective.com/nest#sponsor" target="_blank"><img src="https://opencollective.com/nest/sponsors/badge.svg" alt="Sponsors on Open Collective" /></a>
  <a href="https://paypal.me/kamilmysliwiec" target="_blank"><img src="https://img.shields.io/badge/Donate-PayPal-ff3f59.svg" alt="Donate us"/></a>
    <a href="https://opencollective.com/nest#sponsor"  target="_blank"><img src="https://img.shields.io/badge/Support%20us-Open%20Collective-41B883.svg" alt="Support us"></a>
  <a href="https://twitter.com/nestframework" target="_blank"><img src="https://img.shields.io/twitter/follow/nestframework.svg?style=social&label=Follow" alt="Follow us on Twitter"></a>
</p>
  <!--[![Backers on Open Collective](https://opencollective.com/nest/backers/badge.svg)](https://opencollective.com/nest#backer)
  [![Sponsors on Open Collective](https://opencollective.com/nest/sponsors/badge.svg)](https://opencollective.com/nest#sponsor)-->

## Description

[Nest](https://github.com/nestjs/nest) framework TypeScript starter repository.

## Project setup

```bash
$ npm install
```

## Compile and run the project

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

## Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

## Deployment

When you're ready to deploy your NestJS application to production, there are some key steps you can take to ensure it runs as efficiently as possible. Check out the [deployment documentation](https://docs.nestjs.com/deployment) for more information.

If you are looking for a cloud-based platform to deploy your NestJS application, check out [Mau](https://mau.nestjs.com), our official platform for deploying NestJS applications on AWS. Mau makes deployment straightforward and fast, requiring just a few simple steps:

```bash
$ npm install -g @nestjs/mau
$ mau deploy
```

With Mau, you can deploy your application in just a few clicks, allowing you to focus on building features rather than managing infrastructure.

## Resources

Check out a few resources that may come in handy when working with NestJS:

- Visit the [NestJS Documentation](https://docs.nestjs.com) to learn more about the framework.
- For questions and support, please visit our [Discord channel](https://discord.gg/G7Qnnhy).
- To dive deeper and get more hands-on experience, check out our official video [courses](https://courses.nestjs.com/).
- Deploy your application to AWS with the help of [NestJS Mau](https://mau.nestjs.com) in just a few clicks.
- Visualize your application graph and interact with the NestJS application in real-time using [NestJS Devtools](https://devtools.nestjs.com).
- Need help with your project (part-time to full-time)? Check out our official [enterprise support](https://enterprise.nestjs.com).
- To stay in the loop and get updates, follow us on [X](https://x.com/nestframework) and [LinkedIn](https://linkedin.com/company/nestjs).
- Looking for a job, or have a job to offer? Check out our official [Jobs board](https://jobs.nestjs.com).

## Support

Nest is an MIT-licensed open source project. It can grow thanks to the sponsors and support by the amazing backers. If you'd like to join them, please [read more here](https://docs.nestjs.com/support).

## Stay in touch

- Author - [Kamil Myśliwiec](https://twitter.com/kammysliwiec)
- Website - [https://nestjs.com](https://nestjs.com/)
- Twitter - [@nestframework](https://twitter.com/nestframework)

## License

Nest is [MIT licensed](https://github.com/nestjs/nest/blob/master/LICENSE).

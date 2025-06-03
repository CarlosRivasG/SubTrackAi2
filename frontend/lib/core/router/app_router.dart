import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/subscriptions/presentation/screens/add_subscription_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/report/report.dart';
import '../../features/subscriptions/presentation/screens/subscription_plans_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/add-subscription',
        builder: (context, state) => const AddSubscriptionScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) => ReportScreen(),
      ),
      GoRoute(
        path: '/upgratePlan',
        builder: (context, state) => const SubscriptionPlansScreen(),
      ),
    ],
  );
});

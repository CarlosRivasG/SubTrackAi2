import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('SubTrackAI',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                color: colorScheme.onSurface),
            onPressed: () {
              // TODO: Implementar navegación a notificaciones
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: colorScheme.onSurface),
            onPressed: () {
              // TODO: Implementar navegación a perfil
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, Usuario 👋',
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              _buildSummarySection(context),
              const SizedBox(height: 30),
              _buildUpcomingPaymentsSection(context),
              const SizedBox(height: 30),
              _buildQuickActionsSection(context),
              // 👇 Este SizedBox evita que el FAB se superponga al contenido
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implementar navegación a agregar suscripción
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 3,
          mainAxisSpacing: 8,
          childAspectRatio: 0.85,
          children: [
            _buildSummaryItemCard(
              context,
              'Suscripciones Activas',
              '4',
              Icons.subscriptions,
              colorScheme.primaryContainer,
              colorScheme.onPrimaryContainer,
            ),
            _buildSummaryItemCard(
              context,
              'Próximo Cobro',
              '\$29.99',
              Icons.calendar_today,
              colorScheme.tertiaryContainer,
              colorScheme.onTertiaryContainer,
            ),
            _buildSummaryItemCard(
              context,
              'Gasto Mensual',
              '\$149.99',
              Icons.attach_money,
              colorScheme.errorContainer,
              colorScheme.onErrorContainer,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItemCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: bgColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: iconColor),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: textTheme.bodySmall
                  ?.copyWith(color: iconColor.withOpacity(0.8)),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPaymentsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Próximos Pagos',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // Placeholder
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (context, index) {
              // TODO: Reemplazar con datos reales de suscripciones
              return _buildSubscriptionListItem(
                context,
                'Netflix', // Placeholder
                'Vence en 3 días', // Placeholder
                '\$15.99', // Placeholder
                '13 Mayo', // Placeholder
                Icons.subscriptions, // Placeholder icon
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionListItem(
    BuildContext context,
    String title,
    String subtitle,
    String price,
    String date,
    IconData icon,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Rápidas',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButtonCard(
              context,
              'Agregar',
              Icons.add_circle_outline,
              () {
                context.push('/add-subscription');
              },
              colorScheme.primary,
              colorScheme.onPrimary,
            ),
            _buildActionButtonCard(
              context,
              'Calendario',
              Icons.calendar_month,
              () {
                context.push('/calendar');
              },
              colorScheme.secondary,
              colorScheme.onSecondary,
            ),
            _buildActionButtonCard(
              context,
              'Reportes',
              Icons.bar_chart,
              () {
                context.go('/report');
              },
              colorScheme.tertiary,
              colorScheme.onTertiary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtonCard(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
    Color bgColor,
    Color iconColor,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: bgColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30, color: iconColor),
              const SizedBox(height: 8),
              Text(
                label,
                style: textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: iconColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

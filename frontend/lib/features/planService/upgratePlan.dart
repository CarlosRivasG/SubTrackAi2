import 'package:flutter/material.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mejora tu plan'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Elige el plan que mejor se adapte a ti', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: const [
                  _PlanCard(
                    title: 'Free',
                    price: 'Gratis',
                    color: Colors.green,
                    features: [
                      'Hasta 10 suscripciones',
                      'Recordatorios básicos',
                      'Reporte mensual',
                      '1 dispositivo',
                      'Tema claro',
                    ],
                  ),
                  SizedBox(height: 16),
                  _PlanCard(
                    title: 'Pro',
                    price: '\$2.99 / mes',
                    color: Colors.orange,
                    features: [
                      'Suscripciones ilimitadas',
                      'Recordatorios avanzados',
                      'Reporte semanal',
                      'Exportar Excel / PDF',
                      'Hasta 3 dispositivos',
                      'Tema claro y oscuro',
                    ],
                  ),
                  SizedBox(height: 16),
                  _PlanCard(
                    title: 'Ultimate',
                    price: '\$6.99 / mes',
                    color: Colors.blue,
                    features: [
                      'Todo en Pro',
                      'IA predictiva para cobros',
                      'Reporte diario',
                      'Backup en la nube',
                      'Acceso anticipado a funciones',
                      'Soporte prioritario',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final Color color;
  final List<String> features;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.color,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, radius: 8),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 8),
            Text(price, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
            const SizedBox(height: 12),
            ...features.map((f) => Row(
                  children: [
                    const Icon(Icons.check, size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(f)),
                  ],
                )),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: color),
              child: const Text('Elegir plan'),
            )
          ],
        ),
      ),
    );
  }
}

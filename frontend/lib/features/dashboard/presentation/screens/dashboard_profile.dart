import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final subscriptions = [
      {
        'name': 'Netflix',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg',
        'price': '\$15.49',
        'date': 'May 13',
      },
      {
        'name': 'Spotify',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/1/19/Spotify_logo_without_text.svg',
        'price': '\$9.99',
        'date': 'Abr. 30',
      },
      {
        'name': 'Disney+',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/3/3e/Disney%2B_logo.svg',
        'price': '\$7.99',
        'date': 'Abr. 25',
      },
      {
        'name': 'YouTube Premium',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/b/b8/YouTube_Logo_2017.svg',
        'price': '\$13.99',
        'date': 'May 5',
      },
          {
        'name': 'Netflix',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg',
        'price': '\$15.49',
        'date': 'May 13',
      },
      {
        'name': 'Spotify',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/1/19/Spotify_logo_without_text.svg',
        'price': '\$9.99',
        'date': 'Abr. 30',
      },
      {
        'name': 'Disney+',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/3/3e/Disney%2B_logo.svg',
        'price': '\$7.99',
        'date': 'Abr. 25',
      },
      {
        'name': 'YouTube Premium',
        'logo': 'https://upload.wikimedia.org/wikipedia/commons/b/b8/YouTube_Logo_2017.svg',
        'price': '\$13.99',
        'date': 'May 5',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const Text(
              'Hola, Luis 👋',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Métricas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetricCard('Total de\nsuscripciones', '8'),
                _buildMetricCard('Próximo\ncobro', '\$12.99'),
                _buildMetricCard('Gasto\nmensual', '\$54.96'),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add),
              label: const Text("Agregar suscripción"),
              onPressed: () {
                context.push('/add-subscription');
              },
            ),

            const SizedBox(height: 20),
            const Text("Notificaciones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                title: Text('Pago pendiente: Disney+'),
                subtitle: Text('\$7.99 mañana'),
                trailing: Icon(Icons.chevron_right),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Mis Suscripciones", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            // Lista de suscripciones
            ...subscriptions.map((sub) => ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(sub['logo']!),
              ),
              title: Text(sub['name']!),
              subtitle: const Text('Visa *** 4242'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(sub['price']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(sub['date']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planes de Suscripción'),
      ),
      body: const Center(
        child: Text('Pantalla de Planes de Suscripción'),
      ),
    );
  }
} 
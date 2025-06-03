import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(
                  0xFF006464), // Color aproximado del inicio del degradado del logo
              Color(
                  0xFF00C8C8), // Color aproximado del final del degradado del logo
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Espacio para el logo
                // Asegúrate de agregar tu logo a 'assets/logo/subtrackai_logo.png'
                // y declararlo en tu pubspec.yaml
                Image.asset(
                  'assets/logo/LogoSF.png', // <-- Reemplaza con la ruta correcta de tu logo si es diferente
                  height: 300, // Ajusta el tamaño según necesites
                ),
                const SizedBox(height: 40),
                const Text(
                  'Bienvenido a SubTrackAI', // <-- Texto de bienvenida
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    'Tu asistente inteligente para gestionar tus suscripciones y no perder dinero.', // <-- Descripción
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          Colors.white70, // Blanco con un poco de transparencia
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implementar navegación a la siguiente pantalla (ej. Login/Registro)
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                        0xFF00C8C8), // Usar un color del degradado para el botón
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Empezar', // <-- Texto del botón
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                    height:
                        60), // Espacio entre el botón y la sección de planes
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Añadir padding horizontal
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Elige el plan que mejor se adapte a ti',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Colors.white), // Color de texto blanco
                      ),
                      const SizedBox(height: 24),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Copia de la clase _PlanCard de upgratePlan.dart
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
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge), // Usar tema del contexto
              ],
            ),
            const SizedBox(height: 8),
            Text(price,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: color)), // Usar tema del contexto
            const SizedBox(height: 12),
            ...features.map((f) => Row(children: [
                  const Icon(Icons.check,
                      size: 16, color: Colors.green), // Icono de check verde
                  const SizedBox(width: 8),
                  Expanded(child: Text(f)), // Texto de la característica
                ])),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                /* TODO: Implementar lógica para seleccionar plan */
              }, // TODO
              style: ElevatedButton.styleFrom(
                  backgroundColor: color), // Color del botón según el plan
              child: const Text('Elegir plan'), // Texto del botón
            )
          ],
        ),
      ),
    );
  }
}

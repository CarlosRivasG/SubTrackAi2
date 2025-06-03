import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'SubTrack AI', // Puedes cambiar esto
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
              0xFF006464), // Color base del esquema (inicio degradado)
          primary: const Color(0xFF006464), // Color primario
          secondary:
              const Color(0xFF00C8C8), // Color secundario (final degradado)
          // Puedes definir otros colores aquí como surface, error, etc.
          brightness: Brightness.light, // O dark si prefieres un tema oscuro
        ),
        useMaterial3:
            true, // Usar Material Design 3 (opcional pero recomendado)
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Inglés
        Locale('es', ''), // Español
        // Agrega aquí otros locales si es necesario
      ],
      routerConfig: appRouter,
    );
  }
}

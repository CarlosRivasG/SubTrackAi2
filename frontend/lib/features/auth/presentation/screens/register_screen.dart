import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import '../../data/services/auth_service.dart'; // Asegúrate de que esta ruta sea correcta - Eliminada porque no se usa
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implementar el método register en AuthService
      // await _authService.register(
      //   _firstNameController.text,
      //   _lastNameController.text,
      //   _emailController.text,
      //   _passwordController.text,
      // );

      // Simulación de registro exitoso
      // await Future.delayed(const Duration(seconds: 2));
      // print('Registro simulado exitoso');

      final response = await http.post(
        Uri.parse(
            'http://192.168.1.82:3000/users/create'), // Endpoint de registro
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'avatar': ''
        }),
      );

      if (mounted) {
        if (response.statusCode == 201) {
          // Asumiendo 201 Created para registro exitoso
          // Mostrar mensaje de éxito y navegar a la pantalla de login
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso. Por favor inicia sesión.'),
              backgroundColor: Colors.green,
            ),
          );
          context.go('/login'); // Asumiendo que la ruta de login es /login
        } else {
          // Manejar errores del backend (ej. usuario ya existe, validación)
          String errorMessage = 'Error en el registro';
          try {
            final errorBody = jsonDecode(response.body);
            if (errorBody != null && errorBody['message'] != null) {
              if (errorBody['message'] is List) {
                // Si el mensaje es una lista (ej. errores de validación)
                errorMessage = errorBody['message'].join(', ');
              } else {
                // Si es un mensaje simple
                errorMessage = errorBody['message'];
              }
            }
          } catch (e) {
            // Error al parsear la respuesta de error
            print('Error parsing error response: $e');
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error en el registro: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error de conexión: ${e.toString()}'), // Error de red u otro
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Fondo transparente
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0, // Sin sombra
        title: const Text('Crear Cuenta',
            style: TextStyle(color: Colors.white)), // Título en blanco
        iconTheme: const IconThemeData(
            color: Colors.white), // Iconos en blanco (ej. botón atrás)
      ),
      body: Container(
        // Contenedor para el fondo degradado
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF006464), // Color aproximado del inicio del degradado
              Color(0xFF00C8C8), // Color aproximado del final del degradado
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24), // Espacio superior
                    Text(
                      'Crea tu cuenta',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight
                                  .bold), // Título con estilo y color blanco
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40), // Espacio después del título
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true, // Fondo lleno para campos de texto
                        fillColor: Colors.white
                            .withOpacity(0.9), // Fondo blanco semitransparente
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Apellido',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo electrónico';
                        }
                        // Validación básica de formato de correo
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Por favor ingrese un correo electrónico válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor confirme su contraseña';
                        }
                        // La comparación con la contraseña se hace en la función _register()
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF00C8C8), // Usar un color del degradado para el botón
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Bordes ligeramente redondeados
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white), // Indicador blanco
                              ),
                            )
                          : const Text('Registrarse',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors
                                      .white)), // Texto del botón en blanco
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        context.go('/login'); // Navegar a la pantalla de login
                      },
                      child: Text('¿Ya tienes cuenta? Inicia Sesión',
                          style: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.8))), // Texto en blanco semitransparente
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

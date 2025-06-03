import 'package:flutter/material.dart';
import 'dart:convert'; // Import for JSON decoding
import 'package:http/http.dart' as http; // Import http package
import 'package:flutter_localizations/flutter_localizations.dart'; // Importa este paquete
import '../../../../features/auth/data/services/auth_service.dart';

// Simple model to represent Product data from backend
class Product {
  final String id;
  final String name;
  final String? iconUrl; // Agregar el campo para la URL del ícono
  // Add other fields if needed, like iconUrl

  Product({required this.id, required this.name, this.iconUrl});

  // Optional: fromJson constructor if fetching from API
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      iconUrl: json['iconUrl'], // Mapear la URL del ícono
      // Map other fields
    );
  }
}

// Simple model to represent Category data from backend
class Category {
  final String id;
  final String name;
  // Add other fields if needed, like icon (IconData?)

  Category({required this.id, required this.name});

  // Optional: fromJson constructor if fetching from API
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      // Map other fields
    );
  }
}

class AddSubscriptionScreen extends StatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _serviceController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _authService = AuthService();
  String frequency = 'Mensual';
  String paymentMethod = 'Visa – 1234';

  // Placeholder lists - these should be fetched from the backend
  List<Product> _availableProducts = []; // List to hold Product objects
  List<Category> _availableCategories = []; // List to hold Category objects

  Product? _selectedProduct; // To hold the selected Product object
  Category? _selectedCategory; // To hold the selected Category object

  @override
  void initState() {
    super.initState();
    _fetchProductsFromBackend(); // Fetch products when the screen initializes
    _fetchCategoriesFromBackend(); // Fetch categories when the screen initializes
  }

  @override
  void dispose() {
    _serviceController
        .dispose(); // This controller is no longer needed for dropdown
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // TODO: Implement actual API call to fetch products
  Future<void> _fetchProductsFromBackend() async {
    // Define la URL del endpoint que devuelve la lista de productos
    const String apiUrl = 'http://192.168.1.82:3000/products/getAll';

    try {
      print('Iniciando petición a la API...');
      final response = await http.get(Uri.parse(apiUrl));

      print('Respuesta recibida. Status code: ${response.statusCode}');
      print('Contenido de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        print('Datos decodificados: $jsonResponse');

        List<Product> fetchedProducts = jsonResponse.map((item) {
          print('Procesando item: $item');
          return Product.fromJson(item);
        }).toList();

        print('Productos procesados: ${fetchedProducts.length}');

        setState(() {
          _availableProducts = fetchedProducts;
          if (_availableProducts.isNotEmpty) {
            _selectedProduct = _availableProducts.first;
            print('Primer producto seleccionado: ${_selectedProduct?.name}');
          }
        });
      } else {
        print('Error en la respuesta: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
        // Mostrar un mensaje de error al usuario
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Error al cargar los productos: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error al obtener productos: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al conectar con el servidor: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // TODO: Implement actual API call to fetch categories
  Future<void> _fetchCategoriesFromBackend() async {
    const String apiUrl = 'http://192.168.1.82:3000/categories/getAllCategory';

    try {
      print('Iniciando petición a la API de categorías...');

      final token = await _authService.getToken();
      if (token == null) {
        print('Error: No hay sesión activa para obtener categorías.');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'No hay sesión activa. Por favor inicia sesión para cargar categorías.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Respuesta recibida. Status code: ${response.statusCode}');
      print('Contenido de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        print('Datos decodificados: $jsonResponse');

        List<Category> fetchedCategories = jsonResponse.map((item) {
          print('Procesando categoría: $item');
          return Category.fromJson(item);
        }).toList();

        print('Categorías procesadas: ${fetchedCategories.length}');

        setState(() {
          _availableCategories = fetchedCategories;
          if (_availableCategories.isNotEmpty) {
            _selectedCategory = _availableCategories.first;
            print('Primera categoría seleccionada: ${_selectedCategory?.name}');
          }
        });
      } else {
        print('Error en la respuesta: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Error al cargar las categorías: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error al obtener categorías: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al conectar con el servidor: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Agregar Suscridpción'),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text('Nombre del servicio'),
            const SizedBox(height: 6),
            DropdownButtonFormField<Product>(
              value: _selectedProduct,
              items: _availableProducts.map((Product product) {
                return DropdownMenuItem<Product>(
                  value: product,
                  child: Row(
                    children: [
                      product.iconUrl != null
                          ? Image.network(
                              product.iconUrl!,
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.apps,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            )
                          : Icon(Icons.apps,
                              color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(product.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Product? newValue) {
                setState(() {
                  _selectedProduct = newValue;
                });
              },
              decoration: InputDecoration(
                hintText: 'Selecciona un servicio',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 4),
            const Text('Selecciona de la lista de servicios disponibles',
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 18),
            const Text('Monto'),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'CLP 12.0',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: frequency,
                    items: const [
                      DropdownMenuItem(
                          value: 'Mensual', child: Text('Mensual')),
                      DropdownMenuItem(value: 'Anual', child: Text('Anual')),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => frequency = value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Fecha de cobro'),
            const SizedBox(height: 6),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  locale: const Locale('es'),
                );
                if (picked != null) {
                  setState(() {
                    _dateController.text =
                        '${picked.day} ${_monthName(picked.month)} ${picked.year}';
                  });
                }
              },
              decoration: InputDecoration(
                hintText: '30 abril 2024',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Método de pago'),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: paymentMethod,
              items: const [
                DropdownMenuItem(
                  value: 'Visa – 1234',
                  child: Row(
                    children: [
                      Icon(Icons.credit_card, color: Color(0xFF1976D2)),
                      SizedBox(width: 8),
                      Text('Visa – 1234'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'Mastercard – 5678',
                  child: Row(
                    children: [
                      Icon(Icons.credit_card, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Mastercard – 5678'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => paymentMethod = value);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 18),
            const Text('Categoría'),
            const SizedBox(height: 6),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              items: _availableCategories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Row(
                    children: [
                      // TODO: Add dynamic icons based on category fetched from backend (if backend provides icon info)
                      Icon(Icons.folder_open, // Placeholder icon
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(category.name), // Display category name
                    ],
                  ),
                );
              }).toList(),
              onChanged: (Category? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: const Row(
                    children: [
                      Icon(Icons.camera_alt_outlined, color: Color(0xFF1976D2)),
                      SizedBox(width: 6),
                      Text('Adjuntar recibo',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const SizedBox(width: 1),
                const Text('IA puede extraer datos',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF52B788),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () async {
                  // Mostrar indicador de carga
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  try {
                    // Validar campos requeridos
                    if (_selectedProduct == null ||
                        _selectedCategory == null ||
                        _amountController.text.isEmpty ||
                        _dateController.text.isEmpty) {
                      Navigator.pop(context); // Cerrar el indicador de carga
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor completa todos los campos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Parsear el monto
                    final amount = double.tryParse(_amountController.text);
                    if (amount == null) {
                      Navigator.pop(context); // Cerrar el indicador de carga
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El monto ingresado no es válido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Parsear la fecha
                    final parts = _dateController.text.split(' ');
                    if (parts.length != 3) {
                      Navigator.pop(context); // Cerrar el indicador de carga
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('El formato de fecha no es válido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final day = int.tryParse(parts[0]);
                    final year = int.tryParse(parts[2]);
                    final monthName = parts[1].toLowerCase();
                    final monthMap = {
                      'enero': 1,
                      'febrero': 2,
                      'marzo': 3,
                      'abril': 4,
                      'mayo': 5,
                      'junio': 6,
                      'julio': 7,
                      'agosto': 8,
                      'septiembre': 9,
                      'octubre': 10,
                      'noviembre': 11,
                      'diciembre': 12
                    };
                    final month = monthMap[monthName];

                    if (day == null || month == null || year == null) {
                      Navigator.pop(context); // Cerrar el indicador de carga
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('La fecha ingresada no es válida'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final nextBillingDate = DateTime(year, month, day);

                    // Preparar datos para enviar al backend
                    final subscriptionData = {
                      'productId': _selectedProduct!.id,
                      'categoryId': _selectedCategory!.id,
                      'description': 'Suscripción a ${_selectedProduct!.name}',
                      'price': amount,
                      'billingCycle':
                          frequency == 'Mensual' ? 'monthly' : 'yearly',
                      'nextBillingDate': nextBillingDate.toIso8601String(),
                      'isActive': true
                    };

                    // Enviar datos al backend
                    final token = await _authService.getToken();
                    if (token == null) {
                      Navigator.pop(context); // Cerrar el indicador de carga
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'No hay sesión activa. Por favor inicia sesión.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final response = await http.post(
                      Uri.parse(
                          'http://192.168.1.82:3000/subscriptions/create'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token'
                      },
                      body: jsonEncode(subscriptionData),
                    );

                    Navigator.pop(context); // Cerrar el indicador de carga

                    if (response.statusCode == 201) {
                      // Mostrar mensaje de éxito
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Suscripción creada exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Regresar a la pantalla anterior
                      Navigator.of(context).pop();
                    } else {
                      // Mostrar mensaje de error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Error al crear la suscripción: ${response.body}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    Navigator.pop(context); // Cerrar el indicador de carga
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Guardar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return months[month];
  }
}

void main() {
  runApp(const MyApp()); // O el nombre de tu widget principal
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // ... otras propiedades de tu MaterialApp (title, home, theme, etc.)
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations
            .delegate, // Opcional: si usas widgets de Cupertino
      ],
      supportedLocales: [
        const Locale('en', ''), // Inglés
        const Locale('es', ''), // Español
        // Agrega aquí cualquier otro Locale que necesites soportar
      ],
      // ... tu widget inicial (por ejemplo, home: AddSubscriptionScreen())
      // Asegúrate de que AddSubscriptionScreen sea un hijo de este MaterialApp
      home:
          AddSubscriptionScreen(), // Ejemplo: si AddSubscriptionScreen es la pantalla inicial
    );
  }
}

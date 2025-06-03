import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
class ReportScreen extends StatelessWidget {
  // Datos de ejemplo para la gráfica de barras
  final List<BarChartGroupData> barGroups = [
    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 120, color: Colors.blue)]),
    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 140, color: Colors.blue)]),
    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 110, color: Colors.blue)]),
    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 150, color: Colors.blue)]),
    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 130, color: Colors.blue)]),
    BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 149, color: Colors.blue)]),
  ];

  // Datos de ejemplo para la gráfica de pastel
  final List<PieChartSectionData> pieSections = [
    PieChartSectionData(value: 60, color: Colors.red, title: 'Netflix'),
    PieChartSectionData(value: 40, color: Colors.green, title: 'Spotify'),
    PieChartSectionData(value: 30, color: Colors.blue, title: 'Disney+'),
    PieChartSectionData(value: 19, color: Colors.purple, title: 'HBO'),
  ];

  // Constructor sin const porque fl_chart no lo permite
  ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
leading: IconButton(
  icon: const Icon(Icons.arrow_back),
  onPressed: () {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/dashboard'); // O la ruta principal que prefieras
    }
  },
),
        title: const Text('Reportes'),
        actions: [
          IconButton(icon: const Icon(Icons.file_download), onPressed: () {/* Exportar */}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Resumen', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ResumenItem(title: 'Gasto Mensual', value: '\$149.99'),
                      _ResumenItem(title: 'Gasto Anual', value: '\$1,799.88'),
                      _ResumenItem(title: 'Tiempo', value: '120h'),
                      _ResumenItem(title: 'Canceladas', value: '2'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Gasto Mensual (últimos meses)', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'];
                            return Text(months[value.toInt()]);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Distribución por Plataforma', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: pieSections,
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Insights', style: TextStyle(fontWeight: FontWeight.bold)),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Este mes gastaste un 10% menos que el anterior.'),
                      Text('• Tu suscripción más costosa es Netflix.'),
                      Text('• Has usado más tiempo Spotify que cualquier otra app.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_download),
                    label: const Text('Exportar'),
                    onPressed: () {},
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Ver Detalle'),
                    onPressed: () {},
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.notifications),
                    label: const Text('Alertas'),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResumenItem extends StatelessWidget {
  final String title;
  final String value;
  const _ResumenItem({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
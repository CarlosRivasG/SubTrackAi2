import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarScreen extends StatefulWidget {
      const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Ejemplo de cobros en días específicos
  final Map<DateTime, List<double>> _charges = {
    DateTime.utc(2024, 4, 3): [12.99],
    DateTime.utc(2024, 4, 17): [29.99, 9.99],
    DateTime.utc(2024, 4, 21): [15.99],
  };

  @override
  Widget build(BuildContext context) {
    final totalGasto = _charges.values
        .expand((list) => list)
        .fold<double>(0, (a, b) => a + b);
    final totalCobros = _charges.values.fold<int>(0, (a, b) => a + b.length);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Cobros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'es_ES',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return _charges[DateTime.utc(day.year, day.month, day.day)] ?? [];
            },
            calendarStyle: CalendarStyle(
              markerDecoration: const BoxDecoration(
                color: Color(0xFF52B788),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF0077B6).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF0077B6),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStat('Total gastado', '\$24${totalGasto.toStringAsFixed(2)}'),
                _buildStat('Cobros', '$totalCobros'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
} 
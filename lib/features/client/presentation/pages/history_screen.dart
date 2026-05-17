import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Historial',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _historyItem('12-Nov-2023', '3 Items - S/ 14.50', 'S/ 14.50'),
          const Divider(height: 30),
          _historyItem('10-Nov-2023', '2 Items - S/ 8.00', 'S/ 8.00'),
          const Divider(height: 30),
          _historyItem('05-Nov-2023', '3 Items - S/ 14.50', 'S/ 13.50'),
          const Divider(height: 30),
          _historyItem('02-Nov-2023', '2 Items - S/ 8.00', 'S/ 8.00'),
        ],
      ),
    );
  }

  Widget _historyItem(String date, String details, String total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              details,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        Text(
          total,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

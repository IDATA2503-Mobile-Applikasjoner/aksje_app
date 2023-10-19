import 'package:aksje_app/widgets/stock_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/navbar.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InventoryState();
  }
}

class _InventoryState extends State<Inventory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your development today'),
            SizedBox(height: 20.0),
            // Some placeholder for the graph
            StockChart(data: [
              FlSpot(0, 1),
              FlSpot(1, 1.5),
              FlSpot(2, 1.4),
              FlSpot(3, 3.4),
              FlSpot(4, 2),
              FlSpot(5, 2.2),
              FlSpot(6, 1.8),
              FlSpot(7, 3),
            ]),
            SizedBox(height: 20.0),
            Text('Your stocks'),
            ListTile(
              leading: CircleAvatar(child: Text('7')),
              title: Text('Subsea 7'),
              subtitle: Text('204,85 NOK'),
              trailing: Text('+7,34%'),
            ),
            ListTile(
              leading: CircleAvatar(child: Text('F')),
              title: Text('Frontline PLC'),
              subtitle: Text('175,35 NOK'),
              trailing: Text('+5,97%'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

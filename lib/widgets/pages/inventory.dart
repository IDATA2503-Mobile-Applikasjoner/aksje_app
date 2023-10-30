import 'package:aksje_app/widgets/stock_components/stock_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/pages/sign-up.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InventoryState();
  }
}

class _InventoryState extends State<Inventory> {

  void navPersonPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => (const SignUp())),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your development today'),
                OutlinedButton(
                  onPressed: navPersonPage,
                  child: Icon(Icons.person, color: Colors.black),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Some placeholder for the graph
            const StockChart(data: [
              FlSpot(0, 1),
              FlSpot(1, 1.5),
              FlSpot(2, 1.4),
              FlSpot(3, 3.4),
              FlSpot(4, 2),
              FlSpot(5, 2.2),
              FlSpot(6, 1.8),
              FlSpot(7, 3),
            ]),
            const SizedBox(height: 20.0),
            const Text('Your stocks'),
            const ListTile(
              leading: CircleAvatar(child: Text('7')),
              title: Text('Subsea 7'),
              subtitle: Text('204,85 NOK'),
              trailing: Text('+7,34%'),
            ),
            const ListTile(
              leading: CircleAvatar(child: Text('F')),
              title: Text('Frontline PLC'),
              subtitle: Text('175,35 NOK'),
              trailing: Text('+5,97%'),
            ),
          ],
        ),
      ),
      // Removed the bottom navigation bar from here
    );
  }
}
import 'package:aksje_app/models/stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/models/user_provider.dart';
import 'package:aksje_app/widgets/screens/log-in.dart';
import 'package:aksje_app/widgets/stock_components/stock_chart.dart';
import 'package:aksje_app/widgets/screens/stock_detail.dart';

// Stock model class

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  final List<Stock> stocks = [
    // Add more stocks with unique ids as needed
  ];

  void navLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _goToStockDetailPage(Stock stock) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
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
                  onPressed: navLoginPage,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                  child: const Icon(Icons.person, color: Colors.black),
                ),
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    if (userProvider.user != null) {
                      return Text(userProvider.user!.email);
                    } else {
                      return const SizedBox.shrink(); // Hide the email if the user is null
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Placeholder for the graph
            StockChart(),
            const SizedBox(height: 20.0),
            const Text('Your stocks'),
            Expanded(
              child: ListView.builder(
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(stock.symbol)),
                    title: Text(stock.name),
                    subtitle: Text('${stock.currentPrice} NOK'),
                    trailing: Text('+${stock.percentChangeIntraday.toStringAsFixed(2)}%'),
                    onTap: () => _goToStockDetailPage(stock),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
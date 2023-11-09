import 'package:flutter/material.dart';
import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_chart.dart';

/// A page that displays detailed information about a specific stock.
class StockDetailPage extends StatelessWidget {
  /// The stock for which to display the details.
  final Stock stock;

  /// Constructs a [StockDetailPage] which displays details of [stock].
  const StockDetailPage({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: <Widget>[
          // Popup menu to perform stock-related actions.
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'Add to List':
                  // Logic to add stock to the list goes here.
                  break;
                case 'Add to Live Activity':
                  // Logic to add stock to live activity goes here.
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Add to List',
                child: Text('Add to List'),
              ),
              const PopupMenuItem<String>(
                value: 'Add to Live Activity',
                child: Text('Add to Live Activity'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Displays the stock exchange open status.
              const Text(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                'Oslo Børs Open',
              ),
              const SizedBox(height: 20),
              // Displays the stock symbol and name.
              Text(
                '${stock.symbol} ${stock.name}',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Displays the current price and percentage change of the stock.
              Text(
                '${stock.currentPrice.toString()} NOK (${stock.percentChangeIntraday.toString()}%)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Chart representing the stock's performance.
              const SizedBox(
                height: 300,
                child: StockChart(),
              ),
              const SizedBox(height: 60),
              // Row of buttons for buying or selling the stock.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Buy button
                  ElevatedButton(
                    onPressed: () {
                      // Logic for buying the stock goes here.
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 79, 117, 205),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 12),
                    ),
                    child: const Text('Buy'),
                  ),
                  // Sell button
                  ElevatedButton(
                    onPressed: () {
                      // Logic for selling the stock goes here.
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 185, 56, 47),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 12),
                    ),
                    child: const Text('Sell'),
                  ),
                ],
              ),
              // Additional stock details can be added here.
            ],
          ),
        ),
      ),
    );
  }
}
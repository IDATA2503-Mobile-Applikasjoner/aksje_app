import 'package:flutter/material.dart';
import 'package:aksje_app/models/stock.dart'; // Import the Stock class
import 'package:aksje_app/widgets/stock_components/stock_chart.dart'; // Import your StockChart widget

class StockDetailPage extends StatelessWidget {
  final Stock stock;

  const StockDetailPage({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example data for the stock chart
    // You would fetch this from your backend or service for the particular stock

    return Scaffold(
      appBar: AppBar(
        title: Text(stock.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                'Oslo Børs Open',
              ),
              const SizedBox(height: 20), // Spacing between text and chart
              Text(
                '${stock.symbol} ${stock.name}',
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                '${stock.currentPrice.toString()} NOK (${stock.percentChangeIntraday.toString()}%)',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 300, // Fixed height for the chart container
                child: StockChart(), // Include your StockChart widget
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement buy action
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(
                          255, 79, 117, 205), // Background color
                      elevation: 2, // Button shadow
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20)), // Rounded corners
                      padding: const EdgeInsets.symmetric(
                          horizontal: 62,
                          vertical: 12), // Padding inside the button
                    ),
                    child: const Text('Buy'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement sell action
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(
                          255, 185, 56, 47), // Background color
                      elevation: 2, // Button shadow
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20)), // Rounded corners
                      padding: const EdgeInsets.symmetric(
                          horizontal: 62,
                          vertical: 12), // Padding inside the button
                    ),
                    child: const Text('Sell'),
                  ),
                ],
              ),
              // ... other details about the stock ...
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:aksje_app/models/stock.dart';
import 'package:flutter/material.dart';

/// A widget representing a single stock item in a card format.
///
/// This stateless widget displays basic information about a stock,
/// including its name, current price, and the percentage change intraday.
/// It uses styling and icons to indicate whether the stock's value has risen or fallen.
class StockItem extends StatelessWidget {
  final Stock stock;

  /// Constructs a StockItem widget.
  ///
  /// Requires a [Stock] object to display its data.
  const StockItem({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displays the name of the stock in bold.
            Text(stock.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            const SizedBox(height: 4),
            Row(
              children: [
                // Displays the current price of the stock.
                Text('${stock.currentPrice.toStringAsFixed(2)} NOK'),
                const Spacer(),
                Row(
                  children: [
                    // Icon indicating the trend of the stock's value.
                    Icon(
                      stock.percentChangeIntraday >= 0
                          ? Icons.trending_up // Icon for a positive trend.
                          : Icons.trending_down, // Icon for a negative trend.
                      color: stock.percentChangeIntraday >= 0
                          ? Colors.green // Green color for positive change.
                          : Colors.red, // Red color for negative change.
                    ),
                    const SizedBox(width: 8),
                    // Text displaying the percentage change intraday.
                    Text(
                      '${stock.percentChangeIntraday.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: stock.percentChangeIntraday >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

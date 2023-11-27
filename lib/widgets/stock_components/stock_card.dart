import 'package:flutter/material.dart';
import 'package:aksje_app/models/stock.dart';

/// A widget representing a card for an individual stock.
///
/// This stateless widget displays information about a stock in a card format.
/// It includes the stock's symbol, current price, and the percentage change intraday.
/// The widget is designed to be responsive and fits within a grid layout.
class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback onTap;

  /// Constructs a StockCard.
  ///
  /// Requires a [Stock] object to display its data and a [VoidCallback] [onTap] to handle tap events.
  const StockCard({
    Key? key,
    required this.stock,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 16.0; // Padding on both sides of the screen
    const spacing = 8.0; // Spacing between individual cards
    final cardWidth = (screenWidth - padding * 2 - spacing * 2) /
        2.5; // Calculated width for each card

    return SizedBox(
      width: cardWidth,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withOpacity(0.2), // The hover effect color
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey
                          .shade300, // A light grey for the avatar background
                      foregroundColor: Colors.black, // Text color in avatar
                      child: Text(stock.symbol.substring(0,
                          1)), // Displays the first letter of the stock symbol
                    ),
                    Text(
                      stock.symbol,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${stock.currentPrice.toStringAsFixed(2)} NOK', // Displays the current price of the stock
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${stock.percentChangeIntraday.toStringAsFixed(2)}%', // Displays the percentage change intraday
                      style: TextStyle(
                        color: stock.percentChangeIntraday >= 0
                            ? Colors.green // Positive change
                            : Colors.red, // Negative change
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      stock.percentChangeIntraday >= 0
                          ? Icons.trending_up // Icon for positive change
                          : Icons.trending_down, // Icon for negative change
                      color: stock.percentChangeIntraday >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

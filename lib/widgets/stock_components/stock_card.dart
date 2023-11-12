import 'package:flutter/material.dart';
import 'package:aksje_app/models/stock.dart';

class StockCard extends StatelessWidget {
  final Stock stock;
  final VoidCallback onTap;

  const StockCard({
    Key? key,
    required this.stock,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 16.0; // Padding on both sides
    const spacing = 8.0; // Spacing between cards
    final cardWidth = (screenWidth - padding * 2 - spacing * 2) / 3;

    return SizedBox(
      width: cardWidth,
      child: InkWell(
        onTap: onTap,
        // The hover effect color
        splashColor: Colors.grey.withOpacity(0.2),
        child: Card(
          color: Colors.white, // Card is now white
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar and symbol text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey
                          .shade300, // A light grey for the avatar background
                      foregroundColor: Colors.black, // Text color in avatar
                      child: Text(stock.symbol.substring(0, 1)),
                    ),
                    Text(
                      stock.symbol,
                      style: const TextStyle(
                        color: Colors.black, // Text color for dark mode
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Price
                Text(
                  '${stock.currentPrice.toStringAsFixed(2)} NOK',
                  style: const TextStyle(
                    color: Colors.black, // Text color for dark mode
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                // Percentage Change and Rise/Fall Symbol
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${stock.percentChangeIntraday.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: stock.percentChangeIntraday >= 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      stock.percentChangeIntraday >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
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

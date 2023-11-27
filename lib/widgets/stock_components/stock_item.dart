import 'package:aksje_app/models/stock.dart';
import 'package:flutter/material.dart';

class StockItem extends StatelessWidget {
  final Stock stock;

  const StockItem({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stock.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('${stock.currentPrice.toStringAsFixed(2)} NOK'),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      stock.percentChangeIntraday >= 0
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color: stock.percentChangeIntraday >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
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

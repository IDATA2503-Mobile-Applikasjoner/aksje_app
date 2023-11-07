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
            Text(
              stock.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text('${stock.currentPrice.toStringAsFixed(2)} NOK'),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.trending_up),  // You can replace this with an appropriate icon or widget
                    const SizedBox(width: 8),
                    Text('${stock.percentChangeIntraday}%'),
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

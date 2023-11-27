import 'package:aksje_app/models/stock_list_model.dart';
import 'package:flutter/material.dart';

/// A widget that represents an individual stock list item.
///
/// This stateless widget displays the name of a stock list and provides a tap
/// action that can trigger navigation or other functions. It also includes a
/// forward arrow icon indicating that tapping the item leads to another view.
class StockListItem extends StatelessWidget {
  final StockListModel stockList;
  final Function(StockListModel) onStockListTap;

  /// Constructs a StockListItem widget.
  ///
  /// [stockList] is a StockListModel object containing the data of the stock list.
  /// [onStockListTap] is a function that will be called when the item is tapped.
  const StockListItem(
      {Key? key, required this.stockList, required this.onStockListTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          color: Colors.black,
          height: 1,
          thickness: 0.2,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 16.0),
          child: InkWell(
            onTap: () {
              onStockListTap(stockList);
            },
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      stockList.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                // IconButton for additional tap action or navigation.
                IconButton(
                  onPressed: () {
                    onStockListTap(stockList);
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

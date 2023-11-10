import 'package:aksje_app/models/stock_list_model.dart';
import 'package:flutter/material.dart';

class StockListItem extends StatelessWidget {
  final StockListModel stockList;
  final Function(StockListModel) onStockListTap;

  const StockListItem({Key? key, required this.stockList, required this.onStockListTap}) : super(key: key);

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
              const SizedBox(width: 4), // Adjust the width as needed
              IconButton(
                onPressed: () {
                  onStockListTap(stockList);
                },
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
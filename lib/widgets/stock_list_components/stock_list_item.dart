import 'package:aksje_app/models/stock_list_model.dart';
import 'package:flutter/material.dart';

class StockListItem extends StatelessWidget {
  final StockListModel stockList;

  const StockListItem({Key? key, required this.stockList}) : super(key: key);

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
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
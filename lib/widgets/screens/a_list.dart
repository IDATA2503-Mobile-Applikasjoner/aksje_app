import 'package:aksje_app/models/stock_list_model.dart';
import 'package:aksje_app/widgets/stock_components/stock_list.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';
import 'package:aksje_app/models/stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/screens/stock_detail.dart';

class AListPage extends StatefulWidget {
  final StockListModel stockList;
  const AListPage({Key? key, required this.stockList}) : super(key: key);

  @override
  _AListPageState createState() => _AListPageState();
}

class _AListPageState extends State<AListPage> {
  List<Stock> stocks = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchStocksDataFromServer();
  }

  void fetchStocksDataFromServer() async {
    try {
      var lid = widget.stockList.lid;
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/stocks/lists/$lid/stocks");
      var response = await http.get(baseURL);

      if(response.statusCode == 200) {
        setState(() {
          List responseData = jsonDecode(response.body);
          stocks = responseData.map((data) => Stock.fromJson(data)).toList();
          isLoading = false;
        });
      }
    }catch(e) {
      print(e);
    }
  }

    void _goToStockDetailPage(Stock stock) async {
    try {
      var id = stock.id;
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/stocks/$id");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var stock1 = Stock.fromJson(responseData);
        _navToStockDetailPage(stock1);
      }
    } catch (e) {
      print(e);
    }
  }

  void _navToStockDetailPage(Stock stock) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stockList.name),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(selectedIndex: 1),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : StockList(
                stocks: stocks,
                onStockTap: (stock) => _goToStockDetailPage(stock),
              ),
          ),
        ],
      ),
    );
  }
}
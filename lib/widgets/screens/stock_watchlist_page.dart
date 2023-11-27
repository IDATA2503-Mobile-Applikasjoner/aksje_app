import 'package:aksje_app/models/stock_list_model.dart';
import 'package:aksje_app/widgets/stock_components/stock_list.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';
import 'package:aksje_app/models/stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/screens/stock_detail.dart';
import 'dart:async';
import '../../globals.dart' as globals;

/// This page displays a watchlist of stocks.
///
/// It shows the stocks that the user has added to a particular list. It also
/// provides functionality to refresh the data and navigate to the detail page of each stock.
class StockWatchlistPage extends StatefulWidget {
  final StockListModel stockList;

  const StockWatchlistPage({super.key, required this.stockList});

  @override
  _StockWatchlistPageState createState() => _StockWatchlistPageState();
}

class _StockWatchlistPageState extends State<StockWatchlistPage> {
  List<Stock> stocks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setStocksData();

    // Sets up a timer to refresh stock data every 30 seconds.
    Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _setStocksData();
      });
    });
  }

  /// Fetches stock data from the server for the current list.
  ///
  /// Sends a GET request to retrieve stocks data based on the list ID.
  /// Returns a list of Stock objects on successful retrieval.
  Future<List<Stock>> _fetchStocksDataFromServer() async {
    try {
      var lid = widget.stockList.lid;
      var baseURL =
          Uri.parse("${globals.baseUrl}/api/stocks/lists/$lid/stocks");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        List<Stock> stocksData =
            responseData.map((data) => Stock.fromJson(data)).toList();
        return stocksData;
      }
      return Future.error("Didn't find stock data");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Sets the state with the latest stock data.
  ///
  /// Calls [_fetchStocksDataFromServer] and updates the `stocks` list and `isLoading` state.
  void _setStocksData() async {
    List<Stock> newStocks = await _fetchStocksDataFromServer();
    setState(() {
      isLoading = false;
      stocks = newStocks;
    });
  }

  /// Fetches specific stock data from the server.
  ///
  /// Sends a GET request to retrieve data for a specific stock based on its ID.
  /// Returns a Stock object on successful retrieval.
  Future<Stock> _getStockDataFromnServer(Stock stock) async {
    try {
      var id = stock.id;
      var baseURL = Uri.parse("${globals.baseUrl}/api/stocks/$id");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var newStock = Stock.fromJson(responseData);
        return newStock;
      }
      return Future.error("Didn't find stock");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Navigates to the stock detail page with data from the server.
  ///
  /// First fetches the latest data for the selected stock using [_getStockDataFromnServer],
  /// then navigates to the StockDetailPage with the fetched stock data.
  void _goToStockDetailPage(Stock stock) async {
    Stock serverStock = await _getStockDataFromnServer(stock);
    _navToStockDetailPage(serverStock);
  }

  /// Navigates to the stock detail page.
  ///
  /// Pushes the StockDetailPage onto the navigation stack with the given stock.
  void _navToStockDetailPage(Stock stock) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }

  /// Refreshes the page with new stock data.
  ///
  /// Calls [_setStocksData] to update the list of stocks displayed on the page.
  Future<void> _onRefresh() async {
    setState(() {
      _setStocksData();
    });
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
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Column(
            children: <Widget>[
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : StockList(
                        stocks: stocks,
                        onStockTap: (stock) => _goToStockDetailPage(stock),
                        isDeleteEnabled: true,
                      ),
              ),
            ],
          ),
        ));
  }
}

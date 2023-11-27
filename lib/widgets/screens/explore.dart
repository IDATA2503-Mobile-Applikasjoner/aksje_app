import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_list.dart';
import 'package:aksje_app/widgets/screens/stock_detail.dart';
import '../../globals.dart' as globals;

/// ExplorePage is a StatefulWidget that displays a list of stocks,
/// allowing users to view, search, sort, and navigate to details of individual stocks.
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  // List of all stocks.
  List<Stock> stocks = [];

  // Filtered list of stocks based on user search.
  List<Stock> filteredStocks = [];

  // Loading state indicator.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetches stock data from server on initialization.
    _fetchStocksDataFromServer();

    // Periodically updates stock data every 30 seconds.
    Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchStocksDataFromServer();
    });
  }

  /// Fetches stock data from the server and updates the state.
  Future<void> _fetchStocksDataFromServer() async {
    setState(() {
      isLoading = true;
    });
    try {
      var baseURL = Uri.parse("${globals.baseUrl}/api/stocks");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        stocks = responseData.map((data) => Stock.fromJson(data)).toList();
        filteredStocks = List.from(stocks);
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
      return Future.error(e);
    }
    if (mounted) setState(() {});
  }

  /// Navigates to the StockDetailPage for the given stock.
  Future<void> _goToStockDetailPage(Stock stock) async {
    try {
      var id = stock.id;
      var baseURL = Uri.parse("${globals.baseUrl}/api/stocks/$id");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var stock1 = Stock.fromJson(responseData);
        _navToStockDetailPage(stock1);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Navigates to the StockDetailPage.
  void _navToStockDetailPage(Stock stock) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }

  /// Filters the list of stocks based on the search query.
  void _filterStocks(String query) {
    setState(() {
      filteredStocks = stocks
          .where((stock) =>
              stock.name.toLowerCase().contains(query.toLowerCase()) ||
              stock.symbol.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// Sorts the stocks by highest price.
  void _sortStocksByHighestPrice() {
    setState(() {
      filteredStocks.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
    });
  }

  /// Sorts the stocks by lowest price.
  void _sortStocksByLowestPrice() {
    setState(() {
      filteredStocks.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
    });
  }

  /// Sorts the stocks by the biggest earner (percent change intraday).
  void _sortStocksByBiggestEarner() {
    setState(() {
      filteredStocks.sort(
          (a, b) => b.percentChangeIntraday.compareTo(a.percentChangeIntraday));
    });
  }

  /// Sorts the stocks by the biggest loser (percent change intraday).
  void _sortStocksByBiggestLoser() {
    setState(() {
      filteredStocks.sort(
          (a, b) => a.percentChangeIntraday.compareTo(b.percentChangeIntraday));
    });
  }

  /// Shows sorting options in a modal bottom sheet.
  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: const Text('Highest Price'),
                onTap: () {
                  _sortStocksByHighestPrice();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: const Text('Lowest Price'),
                onTap: () {
                  _sortStocksByLowestPrice();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Biggest Earner'),
                onTap: () {
                  _sortStocksByBiggestEarner();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_down),
                title: const Text('Biggest Loser'),
                onTap: () {
                  _sortStocksByBiggestLoser();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Refreshes the stocks with new data.
  Future<void> _onRefresh() async {
    _fetchStocksDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortOptions(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  _filterStocks(value);
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : StockList(
                      stocks: filteredStocks,
                      onStockTap: _goToStockDetailPage,
                      isDeleteEnabled: false,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

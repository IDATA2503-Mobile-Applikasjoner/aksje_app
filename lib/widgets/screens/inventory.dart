import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:aksje_app/widgets/screens/stock_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/components/pop_up_menu_profile.dart';
import 'dart:async';
import 'package:aksje_app/models/portfolio_history.dart';
import 'package:aksje_app/widgets/stock_components/portfolio_chart.dart';
import '../../globals.dart' as globals;

/// Inventory is a StatefulWidget that displays the user's stock inventory.
/// It includes functionality to view stock details and portfolio history.
class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  // List of stocks in the user's inventory.
  List<Stock> stocks = [];

  // Portfolio history data.
  late List<PortfolioHistory> portfolioHistory = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch stock data and portfolio history from the server.
    _fetchStockDataFromServer();
    _setStockHistoriesWithDataFromServer();

    // Periodically updates data every 30 seconds.
    Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _fetchStockDataFromServer();
        _setStockHistoriesWithDataFromServer();
      });
    });
  }

  /// Navigates to the StockDetailPage for a given stock.
  void _goToStockDetailPage(Stock stock) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }

  /// Fetches stock data from the server and updates the stocks list.
  Future<void> _fetchStockDataFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("${globals.baseUrl}/api/portfolio/stocks/$uid");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        setState(() {
          stocks = responseData.map((data) => Stock.fromJson(data)).toList();
        });
      } else {
        return Future.error("Didn't get stocks");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Fetches portfolio history data from the server and updates the portfolioHistory list.
  Future<List<PortfolioHistory>> _setStockHistoriesWithDataFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var pid = userProvider.user!.uid;
      print(pid);
      var baseURL =
          Uri.parse("${globals.baseUrl}/api/portfoliohistory/portfolios/$pid");
      var response = await http.get(baseURL);
      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        List<PortfolioHistory> newPortfolioHistory = responseData
            .map((data) => PortfolioHistory.fromJson(data))
            .toList();
        setState(() {
          portfolioHistory = newPortfolioHistory;
        });
        return newPortfolioHistory;
      }
      return Future.error("Didn't get data");
    } catch (e) {
      return Future.error("Didn't get data");
    }
  }

  Future<Map<String, dynamic>> _futureYourDevelopmentDataFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var pid = userProvider.user!.uid;
      var baseURL = Uri.parse(
          "${globals.baseUrl}/api/portfoliohistory/portfolios/values/$pid");
      var response = await http.get(baseURL);
      print(response.statusCode);
      //print(pid);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      }
      return Future.error("Didn't find data");
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Refreshes the page by fetching the latest stock data.
  Future<void> _onRefresh() async {
    setState(() {
      _fetchStockDataFromServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          // Displays a pop-up menu with profile options.
          buildPopUpMenuProfile(context),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          // Enables vertical scrolling.
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Your development today'),
                  ],
                ),
                const SizedBox(height: 20.0),
                // Displays a chart representing the portfolio history.
                SizedBox(
                  height: 300,
                  child: buildPortfolioChart(portfolioHistory),
                ),
                const SizedBox(height: 20.0),
                const Text('Your stocks'),
                const SizedBox(height: 10.0),
                // Displays a horizontally scrollable list of stocks.
                SizedBox(
                  height: 200,
                  child: stocks.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: stocks.length,
                          itemBuilder: (context, index) {
                            return StockCard(
                              stock: stocks[index],
                              onTap: () => _goToStockDetailPage(stocks[index]),
                            );
                          },
                        )
                      : Center(
                          child: Text('No stocks owned'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

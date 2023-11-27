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
import 'package:aksje_app/widgets/stock_components/stock_chart_inventory.dart';
import '../../globals.dart' as globals;

//The Inventory page
class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Stock> stocks = [];
  late List<PortfolioHistory> portfolioHistory = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fecthStockDataFromServe();
    _setSTockHistriesWithDataFromServer();

    Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _fecthStockDataFromServe();
        _setSTockHistriesWithDataFromServer();
      });
    });
  }

  //Naviagte to stock detail page
  void _goToStockDetailPage(Stock stock) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }

  //Gets stock data from server and set stocks to that data.
  Future<void> _fecthStockDataFromServe() async {
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

  Future<List<PortfolioHistory>> _setSTockHistriesWithDataFromServer() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      var pid = userProvider.user!.uid;
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
      return Future.error("Didnt get data");
    }
  }

  //Refreshes the page
  Future<void> _onRefresh() async {
    setState(() {
      _fecthStockDataFromServe();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          // Allows vertical scrolling
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Your development today'),
                    buildPopUpMenuProfile(context),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 300,
                  child: buildStockChartInventory(portfolioHistory),
                ),
                const SizedBox(height: 20.0),
                const Text('Your stocks'),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      return StockCard(
                        stock: stocks[index],
                        onTap: () => _goToStockDetailPage(stocks[index]),
                      );
                    },
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

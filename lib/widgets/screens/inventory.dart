import 'package:aksje_app/models/stock.dart';
import 'package:aksje_app/widgets/stock_components/stock_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:aksje_app/widgets/stock_components/stock_chart.dart';
import 'package:aksje_app/widgets/screens/stock_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/components/pop_up_menu_profile.dart';
import 'dart:async';

//The Inventory page
class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Stock> stocks = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fecthStockDataFromServe();

    Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _fecthStockDataFromServe();
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
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/portfolio/stocks/$uid");
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
                //   const SizedBox(
                //    height: 300,
                //     child: StockChart(),
                //    ),
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

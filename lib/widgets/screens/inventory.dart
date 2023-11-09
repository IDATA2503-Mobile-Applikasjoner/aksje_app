import 'package:aksje_app/models/stock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:aksje_app/widgets/screens/log-in.dart';
import 'package:aksje_app/widgets/stock_components/stock_chart.dart';
import 'package:aksje_app/widgets/screens/stock_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Stock model class

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
  }

  void navLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _goToStockDetailPage(Stock stock) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailPage(stock: stock),
      ),
    );
  }

  void _fecthStockDataFromServe() async {
    try {
      UserProvider userProvider = Provider.of(context);
      var uid = userProvider.user!.uid;
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/portfolio/stocks/$uid");
      var response = await http.get(baseURL);

      if(response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        setState(() {
          stocks = responseData.map((data) => Stock.fromJson(data)).toList();
        });
      } else {
        print('${response.statusCode}');
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Your development today'),
                OutlinedButton(
                  onPressed: navLoginPage,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                  child: const Icon(Icons.person, color: Colors.black),
                ),
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    if (userProvider.user != null) {
                      return Text(userProvider.user!.email);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            StockChart(),
            const SizedBox(height: 20.0),
            const Text('Your stocks'),
            Expanded(
              child: ListView.builder(
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text(stock.symbol)),
                    title: Text(stock.name),
                    subtitle: Text('${stock.currentPrice} NOK'),
                    trailing: Text('+${stock.percentChangeIntraday.toStringAsFixed(2)}%'),
                    onTap: () => _goToStockDetailPage(stock),
                  );
                },
              ),
            ),
            
          ],
        ),
        
      ),
      
    );
  }
}
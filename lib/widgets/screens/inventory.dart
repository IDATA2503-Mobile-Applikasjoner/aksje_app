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
  double ?monetaryChange;
  double ?percentageChange;

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
    _setPortfolioHistoriesWithDataFromServer();
    _setDevelopmentText();

    // Periodically updates data every 30 seconds.
    Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _setDevelopmentText();
        _fetchStockDataFromServer();
        _setPortfolioHistoriesWithDataFromServer();
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

  /// Asynchronous method to fetch stock data from the server.
  /// This method queries the server for stock data associated with the user's ID,
  /// using the provided [UserProvider] instance.
  ///
  /// If the request is successful (HTTP status code 200), the response data is
  /// decoded from JSON to a list of [Stock] instances, and the widget's state is
  /// updated with the new stock data.
  ///
  /// Returns a [Future] with no specific return value. Throws an error if there
  /// are issues during the process, such as unsuccessful server response or
  /// encountered exceptions.
  Future<void> _fetchStockDataFromServer() async {
    try {
      // Access the UserProvider instance using Provider to get the user's UID
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;

      // Construct the base URL for the API endpoint
      var baseURL = Uri.parse("${globals.baseUrl}/api/portfolio/stocks/$uid");

      // Make an HTTP GET request to the server
      var response = await http.get(baseURL);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Decode the response body from JSON to a list
        List responseData = jsonDecode(response.body);

        // Convert the list of data into a list of Stock instances
        setState(() {
          stocks = responseData.map((data) => Stock.fromJson(data)).toList();
        });
      } else {
        // If the response status code is not 200, throw an error
        return Future.error("Didn't get stocks");
      }
    } catch (e) {
      // If an exception occurs during the process, throw an error
      return Future.error(e);
    }
  }

  /// Asynchronous method to fetch portfolio histories from the server.
  /// This method queries the server for portfolio histories associated with
  /// the user's ID, using the provided [UserProvider] instance.
  ///
  /// Returns a [Future] that resolves to a list of [PortfolioHistory] instances
  /// if the request is successful (HTTP status code 200). Otherwise, throws an error.
  ///
  /// The returned list represents the portfolio histories retrieved from the server,
  /// and the widget's state is updated with the new values.
  Future<List<PortfolioHistory>> _setPortfolioHistoriesWithDataFromServer() async {
    try {
      // Access the UserProvider instance using Provider to get the user's UID
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      var pid = userProvider.user!.uid;

      // Construct the base URL for the API endpoint
      var baseURL = Uri.parse("${globals.baseUrl}/api/portfoliohistory/portfolios/$pid");

      // Make an HTTP GET request to the server
      var response = await http.get(baseURL);

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        // Decode the response body from JSON to a list
        List responseData = jsonDecode(response.body);

        // Convert the list of data into a list of PortfolioHistory instances
        List<PortfolioHistory> newPortfolioHistory = responseData
            .map((data) => PortfolioHistory.fromJson(data))
            .toList();

        // Update the widget's state with the new portfolio histories
        setState(() {
          portfolioHistory = newPortfolioHistory;
        });

        // Return the list of portfolio histories
        return newPortfolioHistory;
      }

      // If the response status code is not 200, throw an error
      return Future.error("Didn't get data");
    } catch (e) {
      // If an exception occurs during the process, throw an error
      return Future.error("Didn't get data");
    }
  }

    /// Asynchronous method to fetch development data from the server.
    /// This method queries the server for portfolio history values associated
    /// with the user's ID, using the provided [UserProvider] instance.
    ///
    /// Returns a [Future] that resolves to a map of development data if the
    /// request is successful (HTTP status code 200). Otherwise, throws an error.
    ///
    /// The returned map typically contains keys like 'monetaryChange' and
    /// 'percentageChange', representing the relevant development values.
    Future<Map<String, dynamic>> _futureYourDevelopmentDataFromServer() async {
      try {
        // Obtain the user's ID from the UserProvider
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
        var pid = userProvider.user!.uid;

        // Build the URL for the server request
        var baseURL = Uri.parse("${globals.baseUrl}/api/portfoliohistory/portfolios/values/$pid");

        // Send a GET request to the server
        var response = await http.get(baseURL);

        // Check if the response status code is 200 (OK)
        if (response.statusCode == 200) {
          // Decode the response body from JSON to a map
          Map<String, dynamic> data = jsonDecode(response.body);
          
          // Return the fetched data
          return data;
        }

        // If the response status code is not 200, throw an error
        return Future.error("Didn't find data");
      } catch (e) {
        // If an exception occurs during the process, throw an error
        return Future.error(e);
      }
    }

  /// Asynchronous method to set development-related text data.
  /// This method fetches development data from the server and updates the state
  /// with the retrieved values.
  ///
  /// Throws an error if there are any issues during the process.
  Future<void> _setDevelopmentText() async {
    try {
      // Fetch development data from the server
      await Future.delayed(Duration(seconds: 1));
      Map<String, dynamic> data = await _futureYourDevelopmentDataFromServer();

      // Update the state with the retrieved values
      setState(() {
        monetaryChange = data['monetaryChange'];
        percentageChange = data['percentageChange'];
      });
    } catch (e) {
      // Handle errors if needed
      // Propagate the error by returning a Future with the error
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
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${monetaryChange ?? 'N/A'} NOK"),
                    const SizedBox(
                      width: 20,
                    ),
                    Text("${percentageChange ?? 'N/A'}%",
                      style: TextStyle(
                        color: percentageChange != null && percentageChange! >= 0
                          ? Colors.green
                          : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      percentageChange != null && percentageChange! >= 0
                          ? Icons.trending_up // Icon for positive change
                          : Icons.trending_down, // Icon for negative change
                      color: percentageChange != null && percentageChange! >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
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
                      : const Center(
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

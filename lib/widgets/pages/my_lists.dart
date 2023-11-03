import 'package:aksje_app/models/StockList.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/widgets/pages/add_list.dart';

class MyListsPage extends StatefulWidget {
  const MyListsPage({Key? key}) : super(key: key);

  @override
  _MyListsPageState createState() => _MyListsPageState();
}

class _MyListsPageState extends State<MyListsPage> {
  List<StockList> lists = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromServer();
  }

  void _fetchDataFromServer() async {
    try {
      var baseURL = Uri.parse("http://10.0.2.2:8080/api/list");
      var response = await http.get(baseURL);

      if (response.statusCode == 200) {
        List responseData = jsonDecode(response.body);
        setState(() {
          lists = responseData.map((data) => StockList.fromJson(data)).toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lists'),
      ),
      body: ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.list),
            title: Text(lists[index].name), // Assuming StockList has a 'name' property
            onTap: () {
              // Handle list tap
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddListPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
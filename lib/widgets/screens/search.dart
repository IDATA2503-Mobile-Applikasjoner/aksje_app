import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Handle search
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  title: const Text('Result 1'),
                  onTap: () {
                    // Handle result tap
                  },
                ),
                ListTile(
                  title: const Text('Result 2'),
                  onTap: () {
                    // Handle result tap
                  },
                ),
                // Add more list tiles as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}

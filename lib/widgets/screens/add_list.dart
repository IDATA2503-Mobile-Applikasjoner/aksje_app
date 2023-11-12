import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aksje_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/widgets/screens/main_page.dart';
import 'package:aksje_app/widgets/components/flus_bar_info.dart';
import 'package:aksje_app/widgets/components/flush_bar_error.dart';

//Page that can add a list.
class AddListPage extends  StatefulWidget {
  const AddListPage({Key? key}) : super(key: key);

  @override
  _AddListPage createState() => _AddListPage();
}

class _AddListPage extends State<AddListPage> {
  final TextEditingController nameController = TextEditingController();

  //Adds a list to the databasee
  Future<bool> _addListToServer(BuildContext context, String name) async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      var uid = userProvider.user!.uid;
      bool added = false;
      var baseURL = Uri.parse('http://10.0.2.2:8080/api/list');
      var body = jsonEncode({
        "name": name,
        "user": {
          "uid": uid
        }
      });
      var response = await http.post(
        baseURL,
        headers: <String, String> {
          'Content-Type':'application/json; charset=UTF-8',
        },
        body: body,
      );
      if(response.statusCode == 201) {
        added = true;
      }
      return added;
    }
    catch(e) {
      return Future.error(e);
    }
  }

  //Creates a list.
  void _createList(BuildContext context, String name) async {
    bool added = await _addListToServer(context, name);
    if(added == true) {
      String infoMassage = "List was created";
      buildFlushBarInfo(context, infoMassage);
    }
    else {
      String errorMassage = "Could not create list";
      buildFlushBarError(context, errorMassage);
    }
  }

  //Checks if the list name is valid
  bool _checkIfNameIsValid(String name) {
    bool isValid = true;
    if(name == "Favorites" || name == "favorites") {
      isValid = false;
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add List"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, 
            MaterialPageRoute(
              builder: (context) => const MainPage(selectedIndex: 1),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "New List Name",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                if(_checkIfNameIsValid(name) == false) {
                  String errorMessage = "List with name $name already exists";
                }
                else {
                  _createList(context, name);
                }
              }, 
              child: const Text('Create List'))
          ],
        ),
      )

    );
  }
}
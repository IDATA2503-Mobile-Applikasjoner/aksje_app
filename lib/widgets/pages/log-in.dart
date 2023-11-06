import 'package:aksje_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:aksje_app/widgets/pages/sign-up.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aksje_app/widgets/pages/inventory.dart';
import 'package:provider/provider.dart';
import 'package:aksje_app/models/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

  class _LoginPageState extends State<LoginPage> {

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final storage = new FlutterSecureStorage();
    bool isLoggedIn = false;


void login(String email, String password) async {
  var url = Uri.parse('http://10.0.2.2:8080/api/user/authenticate');
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  String token = jsonDecode(response.body)['jwt'];
  print('JWT Token: $token');
  
  // Store the token securely
  storeToken(token);

  // Set the user as logged in
  setState(() {
    isLoggedIn = true;
  });
}

void getLoginUser() async {
  String? token = await getToken();
  if (token != null) {
    var url = Uri.parse('http://10.0.2.2:8080/api/user/sessionuser');
    var response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Include the token in the header
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var user = User.fromJson(jsonResponse); // Assuming User class with fromJson method

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      print('User: ${user.toJson()}'); // Assuming toJson method is defined in User class
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  } else {
    print('Token not found');
  }
}

// Storing the token securely
void storeToken(String token) async {
  await storage.write(key: 'jwt_token', value: token);
}

// Fetching the stored token
Future<String?> getToken() async {
  String? token = await storage.read(key: 'jwt_token');
  return token;
}

// Removing the token when the user logs out
void removeToken() async {
  await storage.delete(key: 'jwt_token');
}

    void navSignUpPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => (SignUp())),
    );
  }


  @override
  Widget build(BuildContext context) {
 //   if(isLoggedIn) {
 //     return const Scaffold(
//        body: Text("Test"),
//      );
///    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                String password = passwordController.text;
                print('Login button pressed');
                login(email,password);
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                navSignUpPage();
              },
              child: const Text('Create account'),
            ),
                        ElevatedButton(
              onPressed: () {
                getLoginUser();
              },
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}

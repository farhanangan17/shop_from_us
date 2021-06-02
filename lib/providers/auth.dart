import 'dart:convert';
// import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async{
    var urll = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=[API Key]');
    final url = urll;
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }
      )
    );
    print(json.decode(response.body));
  }
}

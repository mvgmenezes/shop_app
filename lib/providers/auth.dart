import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signup(String email, String password) async {
    final url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDek6P-sR2YKPdj4viM6DrhcEeCurYLUCo";
    final response = await http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true
    }));
    print(response.body);
  }
}
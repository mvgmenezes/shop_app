import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticated(String email, String password, String urlSegment) async {
    final url = "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDek6P-sR2YKPdj4viM6DrhcEeCurYLUCo";
    try{
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      print(response.body);
    }catch(error){
      throw error;
    }

  }


  Future<void> signup(String email, String password) async {
    return _authenticated(email, password, "signUp");
  }

  Future<void> signin(String email, String password) async {
    return _authenticated(email, password, "signInWithPassword");
  }
}
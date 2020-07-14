import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false});

  void _returnValueFavorite(){
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final url = 'https://haab-575b9.firebaseio.com/favorites/$userId/$id.json?auth=$authToken';
    //final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try{
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400){
        _returnValueFavorite();
      }
    }catch(error){
      _returnValueFavorite();
    }
  }
}
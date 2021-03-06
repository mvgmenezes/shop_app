import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier{
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  //var _showFavoritesOnly = false;
  List<Product> get items{
   /* if(_showFavoritesOnly){
      return _items.where((element) => element.isFavorite).toList();
    }*/
    //if put return _items it will return the pointer to the _items,
    //it means that everyone can change the original object, using [..._items] I am returning the object's copy
    return [..._items];
  }
  List<Product> get favoriteItems{
      return _items.where((element) => element.isFavorite).toList();
  }


  Product findById(String id){
    return _items.firstWhere((element) => element.id == id);
  }

/*
  void showFavoritesOnly(){
    _showFavoritesOnly = true;
    notifyListeners();
  }
  void showAll(){
    _showFavoritesOnly = false;
    notifyListeners();
  }
*/

  //example using async / wait instead then()
  Future<void> fetchAndSetProducts() async {
    final url = 'https://haab-575b9.firebaseio.com/products.json?auth=$authToken';
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null){
        return;
      }
      //connecting the favorite response
      final urlFavorite = 'https://haab-575b9.firebaseio.com/favorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(urlFavorite);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          isFavorite: favoriteData == null ? false : favoriteData[key] ?? false, //the ?? is the another check if is null the favoriteData[key]
          imageUrl: value['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    }catch (error){
      print(error);
      throw(error);
    }
  }

  //example dont using async / wait but using the then()
  Future<void> addProduct(Product product){
    final url = 'https://haab-575b9.firebaseio.com/products.json?auth=$authToken';
    return http.post(url, body: json.encode({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'creatorId': userId
    })).then((response) {
      final newProduct = new Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0) {
      final url = 'https://haab-575b9.firebaseio.com/products/$id.json?auth=$authToken';
      //patch update only this new values, merge with actual object
      http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async{
    final url = 'https://haab-575b9.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    //var existingProduct = _items[existingProductIndex];
    final response = await http.delete(url);
    if(response.statusCode >= 400){
      //_items.insert(existingProductIndex, existingProduct);
      throw HttpException('Could not delete product.');
    }
    _items.removeAt(existingProductIndex);
    notifyListeners();
    //existingProduct = null;
  }
}
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
/*  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id,this.title,this.imageUrl);*/

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    final auth = Provider.of<Auth>(context,listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>( //another way to do a consumer, in this case the consumer will rebuild only this part
              builder: (ctx, product, child) => IconButton(
              icon: Icon(product.isFavorite?Icons.favorite:Icons.favorite_border),
              onPressed:  (){
                product.toggleFavoriteStatus(auth.token);
              },
              color: Theme.of(context).accentColor,
            ),
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                cart.addItem(product);
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Added item in the cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(label: 'UNDO',onPressed: () {
                    cart.removeSingleItem(product.id);
                  },),
                ));
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
    );
  }
}

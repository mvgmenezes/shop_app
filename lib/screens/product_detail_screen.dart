import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
 /* final String title;*/
  static const routeName = '/product-detail';

  /*ProductDetailScreen(this.title);*/
  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false)//listen false, I am saying that i dont wanna reload when my products list change
        .findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 300,
              child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover,),
              width: double.infinity,
            ),
            SizedBox(height: 10,),
            Text('\$${loadedProduct.price}', style: TextStyle(color: Colors.grey, fontSize: 20),),
            SizedBox(height: 10,),
            Text(loadedProduct.description, textAlign: TextAlign.center, softWrap: true,)
          ],
        ),
      ),
    );
  }
}

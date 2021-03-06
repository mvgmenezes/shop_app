

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavoritesOnly;

  ProductsGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {

    //adding this class as listener from provider
    final productsData = Provider.of<Products>(context);
    final loadedProducts = showFavoritesOnly?productsData.favoriteItems:productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index], //se nao altera o context pode usar value
        child: ProductItem(),
      ),
      itemCount: loadedProducts.length,
      padding: const EdgeInsets.all(10.0),
    );
  }
}


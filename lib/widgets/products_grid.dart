

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //adding this class as listener from provider
    final productsData = Provider.of<Products>(context);
    final loadedProducts = productsData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider(
        create: (c) => loadedProducts[index],
        child: ProductItem(),
      ),
      itemCount: loadedProducts.length,
      padding: const EdgeInsets.all(10.0),
    );
  }
}


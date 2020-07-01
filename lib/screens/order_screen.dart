import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/oder_item.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final oderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: oderData.orders.length,
        itemBuilder: (ctx, index) =>  OrderItem(oderData.orders[index]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/oder_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  Future<void> initState() {
    //Using FutureBuilder() instead this below approach
    /*_isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((value) => {
      setState(() {
        _isLoading = false;
      })
    });*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Using FutureBuilder() instead this below approach
    //final oderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
      builder: (ctx, dataSnapshot) {
          if(dataSnapshot.connectionState == ConnectionState.waiting){
           return Center(child: CircularProgressIndicator());
          }else{
            if(dataSnapshot.error != null){
              //DO somenting with error
              return Center(child:
                  Text('an erorr occured!')
              );
            }else{
             return Consumer<Orders>(builder: (ctx,orderData, child) => ListView.builder(
               itemCount: orderData.orders.length,
               itemBuilder: (ctx, index) =>  OrderItem(orderData.orders[index]),
             ));
            }
          }
      },)
    );
  }
}

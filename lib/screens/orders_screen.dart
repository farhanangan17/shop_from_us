import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture(){
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    //so that provider for fetching only run at first
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //otherwise in infinite loop
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      //new approach of fetching data //could have used didChangeDependencies like productOverviewScreen for fetching
      body: FutureBuilder(
        //so that Provider to fetch data doesn't run with build run
        future: _ordersFuture,
        //dataSnapShot here is actually output of future:
        builder: (ctx, dataSnapShot){
          //instead of using _isLoading
          if(dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          else{
            if(dataSnapShot.error != null){
              return Center(child: Text('An error occurred!'));
            }
            else{
              return Consumer<Orders>(
                builder: (ctx, orderData, child) =>
                  ListView.builder(
                    itemBuilder: (ctx, i) => OrderITem(orderData.orders[i]),
                    itemCount: orderData.orders.length,
                  )
              );
            }
          }
        },
      )
        // _isLoading
        // ?
        // :
    );
  }
}

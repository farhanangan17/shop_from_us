import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Shop from Us'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket_rounded),
            title: Text('Shop'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            }
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('Your Orders'),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              }
          ),
          Divider(),
        ],
      ),
    );
  }
}

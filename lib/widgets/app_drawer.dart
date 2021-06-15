import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_product_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';


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
                // Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx) => OrdersScreen()));
              }
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: (){
                Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
              }
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('Logout'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context).logout();
                // Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
              }
          ),
          Divider(),
        ],
      ),
    );
  }
}

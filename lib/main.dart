import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/cart_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/user_product_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/product_detail_screen.dart';
import 'providers/products_provider.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/auth.dart';
import 'screens/orders_screen.dart';
import 'screens/auth_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsApp.debugAllowBannerOverride = false;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Auth(),
        ),
        ChangeNotifierProvider(
          //this part is used when .value is present
          // value: ProductsProvider(),
          // this part is used when .value is absent (For the first notifier it is efficient)
          create: (ctx){
            return ProductsProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (ctx){
            return Cart();
          },
        ),
        ChangeNotifierProvider(
            create: (ctx) {
              return Orders();
            }
        )
      ],
      child: MaterialApp(
        title: 'Shop From Us',
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.deepOrange,
          fontFamily: 'OpenSans',
        ),
        home: AuthScreen(),
        // home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

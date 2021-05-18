import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'product.dart';


class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Blue Jeans',
        description: 'Stylish and cozy - You can wear it at every occasion.',
        price: 19.99,
        imageUrl: 'assets/images/blue jeans.jpeg'
    ),
    Product(
        id: 'p2',
        title: 'Blue Jeans',
        description: 'Stylish and cozy - You can wear it at every occasion.',
        price: 19.99,
        imageUrl: 'assets/images/blue jeans.jpeg'
    ),
    Product(
        id: 'p3',
        title: 'Blue Jeans',
        description: 'Stylish and cozy - You can wear it at every occasion.',
        price: 19.99,
        imageUrl: 'assets/images/blue jeans.jpeg'
    ),
    Product(
        id: 'p4',
        title: 'Blue Jeans',
        description: 'Stylish and cozy - You can wear it at every occasion.',
        price: 19.99,
        imageUrl: 'assets/images/blue jeans.jpeg'
    ),
    Product(
        id: 'p5',
        title: 'Blue Jeans',
        description: 'Stylish and cozy - You can wear it at every occasion.',
        price: 19.99,
        imageUrl: 'assets/images/blue jeans.jpeg'
    ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items{
    // if(_showFavoritesOnly)
    //   return items.where((favProd){
    //     return favProd.isFavorite;
    //   }).toList();

    //we are returning the copy of _items
    return [..._items];
  }

  List<Product> get favoriteItems{
    return _items.where((favItem) => favItem.isFavorite).toList();
  }

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  // }
  //
  // void showAll(){
  //   _showFavoritesOnly = false;
  // }

  void addProduct(){
    // _items.add(value);
    notifyListeners();
  }
}
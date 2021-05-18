import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';
import 'products_provider.dart';

class CartItem with ChangeNotifier{
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier{
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items{
    return {..._items};
  }

  int get itemCount{
    int total = 0;
    //forEach indicates all elements even within same instances
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
    // return _items.length;
  }

  double get totalAmount{
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title){
    //containsKey checks if there is a matched entry or note
    if(_items.containsKey(productId)){
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        )
      );
    }
    else{
      _items.putIfAbsent(
          productId,
          () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1,
          )
      );
    }
    notifyListeners();
  }

  void addItemByNum(String productId){
    _items.update(
        productId,
            (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        )
    );
    // _items.remove(productId);
    notifyListeners();
  }
  
  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void removeItemByNum( String productId){
    _items[productId].quantity < 2
    ?removeItem(productId)
    :_items.update(
      productId,
      (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity - 1,
      )
    );
    // _items.remove(productId);
    notifyListeners();
  }

  // void removeSingleItem()

  void clear(){
    _items = {};
    notifyListeners();
  }
}
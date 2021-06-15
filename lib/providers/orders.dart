import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import '../providers/cart.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders{
    return [..._orders];
  }

  Future<void> fetchAndSetOrders () async{
    final url = Uri.parse('https://shopfromus-3d546-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData == null){
      return;
    }
    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderData){
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
            id: item['id'],
            price: item['price'],
            quantity: item['quantity'],
            title: item['title']
          )).toList(),
        )
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async{
    final timestamp = DateTime.now();
    final url = Uri.parse('https://shopfromus-3d546-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final response = await http.post(
        url,
        body: json.encode({
          // 'id': DateTime.now().toString(),
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts.map((cp) => {
            'id': cp.id,
            'title': cp.title,
            'price': cp.price,
            'quantity': cp.quantity,
          }).toList(),
        })
    );
    _orders.insert(
      //insert to 0th index
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      )
    );
    notifyListeners();
  }
}
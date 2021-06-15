import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';


class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  // var _showFavoritesOnly = false;

  List<Product> get items{
    //we are returning the copy of _items
    return [..._items];
  }

  List<Product> get favoriteItems{

    return _items.where((favItem) => favItem.isFavorite).toList();
  }

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    //making the products only accessible where its needed to be
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse('https://shopfromus-3d546-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try{
      final response = await http.get(url);
      final extractedData = json.decode(response.body)as Map<String, dynamic>;
      if(extractedData == null){
        return;
      }
      url = Uri.parse('https://shopfromus-3d546-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favStatusResponse = await http.get(url);
      final favoriteData = json.decode(favStatusResponse.body);
      final List<Product> loadedProduct = [];
      //productId = key, productData = value
      extractedData.forEach((productId, productData) {
        loadedProduct.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            //here ?? indicates favoriteData[productId] if null then equal to value after ?? otherwise value of favoriteData[productId]
            isFavorite: favoriteData == null ?false :favoriteData[productId] ?? false,
            imageUrl: productData['imageUrl'],
          ),
        );
      });
      _items = loadedProduct;
      notifyListeners();
      // print(json.decode(response.body));
    }catch(error){
      throw error;
    }
  }

  Future<void> addProduct(Product product) async{
    final url = Uri.parse('https://shopfromus-3d546-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try{
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    }catch(error){
      print(error);
      throw error;
    }

    // catchError((error){
    //
    // });
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >= 0){
      final url = Uri.parse('https://shopfromus-3d546-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    }else{
      print('..');
    }
  }

  //no async await business here because to delete we need not to wait
  Future<void> deleteProduct(String id) async{
    final url = Uri.parse('https://shopfromus-3d546-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    //for delete request, statusCode >= 400 doesn't throw the error automatically
    if(response.statusCode >= 400){
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}





// Product(
//     id: 'p1',
//     title: 'Blue Jeans',
//     description: 'Stylish and cozy - You can wear it at every occasion.',
//     price: 19.99,
//     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5a/Jeans.jpg'
// ),
// Product(
//     id: 'p2',
//     title: 'Blue Jeans',
//     description: 'Stylish and cozy - You can wear it at every occasion.',
//     price: 19.99,
//     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5a/Jeans.jpg'
// ),
// Product(
//     id: 'p3',
//     title: 'Blue Jeans',
//     description: 'Stylish and cozy - You can wear it at every occasion.',
//     price: 19.99,
//     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5a/Jeans.jpg'
// ),
// Product(
//     id: 'p4',
//     title: 'Blue Jeans',
//     description: 'Stylish and cozy - You can wear it at every occasion.',
//     price: 19.99,
//     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5a/Jeans.jpg'
// ),
// Product(
//     id: 'p5',
//     title: 'Blue Jeans',
//     description: 'Stylish and cozy - You can wear it at every occasion.',
//     price: 19.99,
//     imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/5/5a/Jeans.jpg'
// ),
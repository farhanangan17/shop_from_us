import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import'../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  //
  // ProductDetailScreen(this.title);

  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    //listen: false => Though had to use Provider.of..... but this screen really
    //don't need to change every time something updates so that is why listen is false
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: Image.asset(
              loadedProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 10,),
          Text('${loadedProduct.price}'),
          SizedBox(height: 10,),
          Text('${loadedProduct.description}')
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user_product';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Your Products'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ?Center(child: CircularProgressIndicator(),) :RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          //consumer alternative to provider
          child: Consumer<ProductsProvider>(
            builder:(ctx, productData, _) => Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: productData.items.length,
                itemBuilder: (_, i){
                  return Column(
                    children: [
                      UserProductItem(
                          productData.items[i].id,
                          productData.items[i].title,
                          productData.items[i].imageUrl
                      ),
                      Divider(),
                    ]
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

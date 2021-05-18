import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_overview_item.dart';

class ProductsGrid extends StatelessWidget{
  final bool showFavoritesOnly;

  ProductsGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context){
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavoritesOnly ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i){
        return ChangeNotifierProvider.value(
          //this part is used when .value is present (efficient in this case)
          value: products[i],
          // this part is used when .value is absent
          // create: (c){
          //   return products[i];
          // },
          child: ProductOverviewItem(
              // products[i].id,
              // products[i].title,
              // products[i].imageUrl
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
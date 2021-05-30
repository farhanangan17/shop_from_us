import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_from_us/providers/products_provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductOverviewItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //listen false because though we need provider here but don't need to make whole widget listen - consumer is there
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // final cartItem = Provider.of<CartItem>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
            // .push(
            //     MaterialPageRoute(builder: (ctx) => ProductDetailScreen(title),)
            // );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          //Consumer similar to provider - it can be implemented to specific widget
          leading: Consumer<Product>(
            //in consumer context,
            builder: (ctx, product, child){
              return IconButton(
                onPressed: (){
                  product.toggleFavoriteStatus();
                },
                icon: Icon(
                    product.isFavorite
                        ?Icons.favorite
                        :Icons.favorite_border
                ),
                color: Theme.of(context).accentColor,
              );
            },
              // child: Text('Never Changes')
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to Cart', textAlign: TextAlign.center,),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: (){
                        cart.removeItemByNum(product.id);
                      },
                    ),
                  )
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

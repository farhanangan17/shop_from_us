// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl)
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: id,
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async{
                try{
                  await Provider.of<ProductsProvider>(context, listen: false).deleteProduct(id);
                }
                catch(error){
                  scaffold.showSnackBar(
                      SnackBar(
                        content: Text('Could not delete item!', textAlign: TextAlign.start,),
                        duration: Duration(seconds: 2),
                        // action: SnackBarAction(
                        //   label: 'UNDO',
                        //   onPressed: (){
                        //     // cart.removeItemByNum(product.id);
                        //   },
                        // ),
                      )
                  );
                    // BottomShet(Text('Could not delete item!')),
                    // // SnackBar(content: Text('Could not delete item!', textAlign: TextAlign.center,),)
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}

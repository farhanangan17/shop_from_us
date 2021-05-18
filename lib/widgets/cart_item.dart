import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//there are two classes in cart.dart => "show" enables us to take one of them
import '../providers/cart.dart';
// import '../providers/cart.dart' show Cart;

class CartITem extends StatelessWidget with ChangeNotifier{
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartITem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    // final cartItem = Provider.of<CartItem>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
            Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
            context: context,
            builder: (ctx){
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to remove the item from the cart?'),
                actions: <Widget>[
                  TextButton(
                      onPressed: (){
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('No', style: TextStyle(color: Theme.of(context).primaryColor),)
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Yes', style: TextStyle(color: Theme.of(context).primaryColor),)
                  ),
                ],
              );
            }
        );
      },
      onDismissed: (direction){
        cart.removeItem(productId);
            // cartItem.id
        // cart.remove;
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(3),
                child: FittedBox(
                    child: Text('\$$price')
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            // trailing: Text('$quantity x'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: (){
                    // cart.items.length <1
                    // ? cart.removeItem(productId)
                    cart.removeItemByNum(productId);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    cart.addItemByNum(productId);
                  },
                ),
                Text('$quantity x'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

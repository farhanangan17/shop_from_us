import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';

class OrderITem extends StatefulWidget {
  final OrderItem order;

  OrderITem(this.order);

  @override
  _OrderITemState createState() => _OrderITemState();
}

class _OrderITemState extends State<OrderITem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.products.length * 20.0 + 130, 200) : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              //.widget is needed as it is stateful and coming from different widget
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              //custom dateFormat with help of intl package
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(
                  _expanded
                      ?Icons.expand_less
                      :Icons.expand_more
                ),
                onPressed: (){
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            // if(_expanded)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                height: _expanded ? min(widget.order.products.length * 20.0 + 30, 180) : 0,
                child: ListView(
                  children: widget.order.products.map((prod) =>
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          prod.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${prod.quantity}x \$${prod.price}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    )
                  ).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}

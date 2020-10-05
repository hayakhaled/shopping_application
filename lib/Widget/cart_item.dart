import 'package:flutter/material.dart';
import '../provider/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String produuctId;
  final double price;
  final int quentity;
  final String title;

  CartItem({this.id, this.produuctId, this.price, this.quentity, this.title});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are Yor Sure Deleted it?'),
                content: Text('You Want to delete your order'),
                actions: [
                  FlatButton(
                    child: Text("No"),
                    onPressed: (){
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: (){
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
      ),
      child: Card(
          child: ListTile(
        leading: Padding(
          padding: EdgeInsets.all(1),
          child: FittedBox(
              fit: BoxFit.contain,
              child: CircleAvatar(
                child: Text(
                  '\$$price',
                  style: TextStyle(fontSize: 12),
                ),
              )),
        ),
        title: Text(title),
        subtitle: Text('Total : ${(price * quentity)}'),
        trailing: Text('$quentity x'),
      )),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).RemoveItem(produuctId);
      },
    );
  }
}

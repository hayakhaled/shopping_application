import 'package:provider/provider.dart';
import '../Widget/cart_item.dart';
import '../provider/cart.dart' show Cart;
import 'package:flutter/material.dart';
import '../provider/order.dart';

class CartScreen extends StatefulWidget {
  static const routName = '/CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(
        children: [
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total'),
                Chip(
                  label: Text('${cart.itemAmount}'),
                ),
              OrderButton(cart: cart)
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.item.length,
                itemBuilder: (ctx, i) => CartItem(
                      id: cart.item.values.toList()[i].id,
                      produuctId: cart.item.keys.toList()[i],
                      price: cart.item.values.toList()[i].price,
                      quentity: cart.item.values.toList()[i].quentity,
                      title: cart.item.values.toList()[i].title,
                    )),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoaded =false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
       child:_isLoaded ? CircularProgressIndicator() : Text('Order Now'),
       onPressed:(widget.cart.itemAmount <= 0 || _isLoaded) ? null : () async{

         setState(() {
           _isLoaded=true;
         });

       await  Provider.of<Order>(context,listen: false).addOrder(
           widget.cart.item.values.toList(),
           widget.cart.itemAmount,
         );

         setState(() {
           _isLoaded=false;
         });

         widget.cart.clear();
       },
       textColor: Theme.of(context).primaryColor,
     );

    setState(() {
      _isLoaded=false;
    });
  }
}

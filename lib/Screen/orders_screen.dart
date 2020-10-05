import 'package:flutter/material.dart';
import '../provider/order.dart';
import 'package:provider/provider.dart';
import '../Widget/order_item.dart' as order;
import '../Widget/app_drawer.dart';
import '../provider/order.dart';
class OrderScreen extends StatefulWidget {
  static const routName ='/order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
 var _isLoading=false;
  @override
  void initState() {
//
//    Future.delayed(Duration.zero).then((_) async{
      setState(() {
        _isLoading=true;
      });
     Provider.of<Order>(context,listen: false).fetchAndSetOrders().then((_){
       setState(() {
         _isLoading=false;
       });
     });

//    });
    // TODO: implement initState
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
    final orders= Provider.of<Order>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      body:_isLoading ? Center(child:CircularProgressIndicator(),) :ListView.builder(itemCount:orders.order.length,
      itemBuilder: (ctx,i) => order.OrderItem(order: orders.order[i],)
      ),
      drawer:AppDrawer() ,
    );
  }
}

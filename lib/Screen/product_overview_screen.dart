import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screen/cartscreen.dart';
import 'package:shop_app/Widget/app_drawer.dart';
import 'package:shop_app/Widget/badge.dart';
import 'package:shop_app/provider/products.dart';
import '../provider/cart.dart';
import '../Widget/product_grid.dart';
import '../Widget/app_drawer.dart';

enum showingItem { Favorite, All }

class ProductScreen extends StatefulWidget {
  static const routName ='/productScreen';
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var _SelectedItem = false;
  var _insit=true;
  var _isloaded=false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
   if(_insit){
     setState(() {
       _isloaded=true;
     });
     Provider.of<Products>(context,listen: false).fetchData().then((_){
       setState(() {
         _isloaded=false;
       });
     });
   }
_insit=false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {


    final cart = Provider.of<Cart>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(

          title: Text("Shopping" ),
          actions: [

    Consumer<Cart>(
    builder:(_,CartData,_2) =>Badge(
      child: _2,
      value: CartData.itemCount.toString(),
    )

    ,child:IconButton(
    icon: Icon(Icons.shopping_cart,color: Colors.white,),
      onPressed: (){
      Navigator.pushNamed(context, CartScreen.routName);
      },
    ),

    ),
    ],
    ),
    drawer: AppDrawer(),
    body:_isloaded?Center(child:CircularProgressIndicator(backgroundColor: Colors.blueAccent,)) :ProductGrid(_SelectedItem),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shop_app/Screen/cartscreen.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/order.dart';
import 'provider/products.dart';
import 'package:provider/provider.dart';
import './Screen/product_overview_screen.dart';
import './Screen/details_screen.dart';
import 'provider/cart.dart';
import 'Screen/orders_screen.dart';
import 'Screen/product_managing.dart';
import 'Screen/edit_product.dart';
import 'Screen/auth_screen.dart';
import 'provider/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
          ChangeNotifierProvider.value(
          value:auth(),
      ),

      ChangeNotifierProxyProvider<auth ,Products>(
        update: (ctx,auth,prevoiusProduct) => Products(auth.userId,auth.token,prevoiusProduct==null ?[] : prevoiusProduct.items),

      ),

     ChangeNotifierProvider.value(
     value:Cart() ),
     ChangeNotifierProxyProvider<auth,Order>(
         update: (ctx,auth,prevuoisOrder) => Order(auth.token , prevuoisOrder ==null ? [] : prevuoisOrder.order)
     ),
     ],
     child:Consumer<auth>(
       builder:(ctx,auth,_) =>MaterialApp(
         theme: ThemeData(
           primaryColor: Color(0xff2874A6),
           accentColor: Colors.blueAccent,
         ),
         debugShowCheckedModeBanner: false,
         home:auth.isAuth ?ProductScreen() : AuthScreen(),
         routes: {
       ProductScreen.routName:(ctx) =>ProductScreen(),
       DetailsScreen.routName: (ctx) =>DetailsScreen(),
       CartScreen.routName:(ctx) => CartScreen(),
       OrderScreen.routName:(ctx) =>OrderScreen(),
       ProductManiging.routName:(ctx) =>ProductManiging(),
       EditProduct.routName:(ctx) =>EditProduct()
       },
       ),
     )
    );

  }
}

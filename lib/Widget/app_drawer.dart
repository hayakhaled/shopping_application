import 'package:flutter/material.dart';
import 'package:shop_app/Screen/product_managing.dart';
import 'package:shop_app/Screen/product_overview_screen.dart';
import '../Screen/orders_screen.dart';
import '../Screen/product_managing.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../Screen/auth_screen.dart';
class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider()
          ,ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: (){
           Navigator.of(context).pushReplacementNamed(ProductScreen.routName);
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed(ProductManiging.routName);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
            
            },
          ),

        ],
      ),
    );
     }
}
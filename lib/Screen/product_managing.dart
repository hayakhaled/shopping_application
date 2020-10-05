import 'package:flutter/material.dart';
import '../Screen/edit_product.dart';
import '../Widget/app_drawer.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';
import '../Widget/productManaging.dart';

class ProductManiging extends StatelessWidget {
  final List<Products> cart;

  ProductManiging({
    this.cart
  });

  static const routName = '/managing';


//  Future<void> _loading(BuildContext context) async{
//  await  Provider.of<Products>(context,listen: false).fetchData();
//  }
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions:[
          IconButton(icon: Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).pushNamed(EditProduct.routName);
          },
          )
        ],
        title: const Text("Manging you product"),
      ),
      drawer: AppDrawer(),

      body:
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(itemCount: productData.items.length,
          itemBuilder: (ctx,i) => ProductManagingItem(id:productData.items[i].id,
          title: productData.items[i].title,
           price: productData.items[i].price,
            imageUrl:productData.items[i].imageUrl,
          ),
          ),
        ),

    );
  }
}

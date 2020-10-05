import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Screen/edit_product.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';

class ProductManagingItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;

  ProductManagingItem({this.id, this.title, this.imageUrl, this.price});

  @override
  Widget build(BuildContext context) {
    final scaffold =Scaffold.of(context);
    // TODO: implement build
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        height: 20,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit,color:Colors.blueAccent,),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete,color: Colors.red,),
              onPressed: () async{
                try{
                await  Provider.of<Products>(context, listen: false).deleteProduct(id);
                }catch(error){
                  scaffold.showSnackBar(SnackBar(content:Text('Deleting Field',textAlign: TextAlign.center,),));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

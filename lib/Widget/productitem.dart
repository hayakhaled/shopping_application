import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/products.dart';
import '../provider/cart.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/auth.dart';
class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageurl;
//
//  ProductItem({this.id, this.title, this.imageurl});

  @override
  Widget build(BuildContext context) {
    final _screenSize =MediaQuery.of(context).size;
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final AuthData =Provider.of<auth>(context,listen: false);
    // TODO: implement build
    return Container(height: _screenSize.height*1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                    '/product-name', arguments: product.id);
              },
              child:Hero
              (
                tag:product.id,
                    child: Container(
                      decoration:BoxDecoration(
                        border: Border.all(color: Colors.black38,width:10)
                        ,borderRadius:BorderRadius.circular(8)),
                      child: FadeInImage.assetNetwork(placeholder:'assets/images/tshirt.png',image: product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            ),
            footer: GridTileBar (
              backgroundColor: Color.fromARGB(230, 133, 193, 233 ),
              leading: Consumer<Product>(
                builder: (_, Product, _2) =>
                    IconButton(
                icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color:Color(0xff2874A6),
                ),
                onPressed: () {
                  product.isSelectedFavorite(AuthData.userId);
                },
              ),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize:17),
              ),
              trailing: Consumer<Cart>(
                builder: (ctx, Cart, ch) =>
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Color(0xff2874A6),
                      ),
                      onPressed: () {
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Add a new product"),
                            action:SnackBarAction(label: 'UNDO',onPressed: (){
                              cart.removeOneItem(product.id);
                            },),
                            )

                        );
                        Cart.addItem(product.id, product.title, product.price);
                      },
                    ),

              ),
            ),
          ),
        ),
      ),
    );
  }
}

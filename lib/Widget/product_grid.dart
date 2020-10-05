import 'package:flutter/material.dart';
import 'package:shop_app/provider/products.dart';
import '../provider/products.dart';
import '../Widget/productitem.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatefulWidget {
  final bool showfavorite;

  ProductGrid(
    this.showfavorite
);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
   final productdata = Provider.of<Products>(context);
   final product =widget.showfavorite?productdata.favoriteItems : productdata.items;
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemBuilder: (ctx, i) =>ChangeNotifierProvider.value(
        value:product[i],
        child:
      ProductItem(
//        id: product[i].id,
//        title: product[i].title,
//        imageurl: product[i].imageUrl,
      ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10
      ),

      itemCount: product.length,
    );
  }
}

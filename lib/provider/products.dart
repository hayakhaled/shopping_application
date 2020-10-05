import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/HttpE.dart';
import '../provider/product.dart';
class Products extends ChangeNotifier {
  List<Product> _items = [
//    Product(
//        id: 'P1',
//        title: 'Red Shirt',
//        description: 'A red shirt - Itt is pretty red!,',
//        price: 29.50,
//        imageUrl: 'https://www.marni.com/12/12386489MT_13_n_r.jpg'),
//    Product(
//        id: 'P2',
//        title: 'Black Cup',
//        description: 'A Black Cup- It is pretty Cup!,',
//        price: 29.50,
//        imageUrl:
//            'https://media.4rgos.it/i/Argos/8012801_R_Z001A_UC1268924?w=750&h=440&qlt=70'),
//    Product(
//        id: 'P3',
//        title: 'Dress Yellow',
//        description: 'A dress yellow- It is pretty dress!,',
//        price: 29.50,
//        imageUrl:
//            'https://us.maje.com/dw/image/v2/AAON_PRD/on/demandware.static/-/Sites-maje-catalog-master-H13/default/dwf9c15051/images/h13/Maje_MFPRO01166-0859_H_P.jpg?sw=780&q=80'),
//    Product(
//        id: 'P4',
//        title: 'Grey Bag',
//        description: 'A grey bag- It is pretty bag!,',
//        price: 29.50,
//        imageUrl:
//            'https://twicpics.celine.com/products/dw2a9ca752/images/large/189003ZVA.10DC_1_LIBRARY_85482.jpg?sw=1200&sh=1200&sm=fit&strip=false'),
  ];
//
  final String authToken;
  final String userId;
  Products(this.authToken ,this.userId,this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findById(String Id) {
    return _items.firstWhere((prod) => prod.id == Id);
  }
  List<Product> get favoriteItems {
return items;
  }

  Future<void>fetchData() async{
  var url = 'https://testing-flu.firebaseio.com/Product.json?auht=$authToken}';
    try{
      final response =await http.get(url);
      final extractData =json.decode(response.body) as Map<String ,dynamic>;
      if(extractData ==null){
        return;
      }

//      url ='https://testing-flu.firebaseio.com/selectesFavorite.json';
//      final favoriteesponse= await http.get(url);
//      final favoriteData = json.decode(response.body);
      final List<Product> loadedProduct = [];
      extractData.forEach((prodId, prodData) async  {
        loadedProduct.add(Product(
          id: prodId,
          title:prodData['Title'],
          price: prodData['Price'],
          description: prodData['Description'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['is Favorite']
        ));
      });
     _items =loadedProduct;
     notifyListeners();

    }catch(error){
   throw error;
    }
  }

Future<void>  addProduct(Product product) async {
    final url = 'https://testing-flu.firebaseio.com/Product.json';
   try {
    final response= await http.post(url,
       body: json.encode({
         'Title': product.title,
         'Description': product.description,
         'Price': product.price,
         'imageUrl': product.imageUrl,
          'userId' :userId,
         'is Favorite' : product.isFavorite
       }),
     );
    final newProduct = Product(
      id: json.decode(response.body)['name'],
      title: product.title,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
//      _items.insert(0, newProduct);
     notifyListeners();
   } catch (error){
     throw error;
   }

    }
  Future<void> UpdatProduct(String id , Product newProduct) async{
    final proIndex =_items.indexWhere((prod) =>prod.id ==id );
    final url = 'https://testing-flu.firebaseio.com/Product/$id.json?auth=$authToken';
    final response =await http.patch(url,body:json.encode({
      'Iitle' : newProduct.title,
      'Price' : newProduct.price,
      'Description' :newProduct.description,
      'imageUrl' : newProduct.imageUrl,
    }));
    _items[proIndex] =newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://testing-flu.firebaseio.com/Product/$id.json';
    final exectingproductIndex =_items.indexWhere((prod) =>prod.id==id );
    var exectingproduct =_items[exectingproductIndex];
    _items.removeAt(exectingproductIndex);
    notifyListeners();
   final response =await http.delete(url);
     if(response.statusCode >=400){
       _items.insert(exectingproductIndex, exectingproduct);
       notifyListeners();
       throw HttpExeption('Something Wrong in deleting items');
     }
     exectingproduct=null;
  }
}

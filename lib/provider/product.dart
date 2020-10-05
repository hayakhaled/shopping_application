import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final int quentity;
   bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.quentity,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue){
    isFavorite =newValue;
    notifyListeners();
  }

 Future<void> isSelectedFavorite( String userId) async{
   final oldFavorite =isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://testing-flu.firebaseio.com/Product/$id.json';
    try{
     await http.patch(url,body: json.encode({
        'is Favorite': isFavorite
      }
      ));
    }catch(error){
      isFavorite =oldFavorite;
      notifyListeners();
    }


  }
//
//  _saveFavorie() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//   bool Favorite=  prefs.setBool('isFavorite' , false) as bool;
//   return Favorite;
//
//  }
}




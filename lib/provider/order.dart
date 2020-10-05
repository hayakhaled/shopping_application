import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.dateTime,
      @required this.products,

      });
}

class Order with ChangeNotifier {
  List<OrderItem> _order = [];
  final String token;

  Order(this.token ,this._order);

  List<OrderItem> get order {
    return [..._order];
  }

  Future<void>fetchAndSetOrders() async {
    final url= 'https://testing-flu.firebaseio.com/Orders.json';
    try{
      final response =await http.get(url);
      final List<OrderItem>loadedOrder =[];
      final extractedData=json.decode(response.body) as Map<String,dynamic>;
      extractedData.forEach((orderId, orderDate)async {
        loadedOrder.add(OrderItem(
            id: orderId,
            amount: orderDate['amount'],
            dateTime: DateTime.parse(orderDate['dateTime']),
            products:( orderDate['products'] as List<dynamic>).map((item) => CartItem (
              id: item['id'], price:item['price'],
              quentity: item['quantity'],
              title: item['title'],

            )).toList()
        ));
      });
      _order =loadedOrder;
      notifyListeners();
    }catch(error){
      throw error;
    }

  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async{
    final url = 'https://testing-flu.firebaseio.com/Orders.json';
    final timestamp =DateTime.now();
    final resposne = await http.post(url , body:json.encode({
      'amount' : total,
      'dateTime' : timestamp.toIso8601String(),
      'products' : cartProduct.map((cp) =>{
       'id' : cp.id,
       'title' : cp.title,
       'quantity' : cp.quentity,
       'price' : cp.price,
      }).toList()
    }));
    
    _order.insert(
        0,
        OrderItem(
            id: json.decode(resposne.body)['name'],
            amount: total,
            dateTime: DateTime.now(),
            products: cartProduct,
        ));

    notifyListeners();
  }
  Future<void> deleteProduct(String id) async {
    final url = 'https://testing-flu.firebaseio.com/Orders/$id.json';
//    final exectingproductIndex =_items.indexWhere((prod) =>prod.id==id );
//    var exectingproduct =_items[exectingproductIndex];
//    _items.removeAt(exectingproductIndex);
//    notifyListeners();
    await http.delete(url);
  }
}

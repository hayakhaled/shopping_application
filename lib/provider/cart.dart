import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quentity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quentity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get item {
    return {..._item};
  }

  int get itemCount {
    return _item.length;
  }

  double get itemAmount {
    var total = 0.0;
    _item.forEach((key, CartItem) {
      total += CartItem.price * CartItem.quentity;
    });
    return total;
  }

  void clear() {
    _item = {};
    notifyListeners();
  }

  void removeOneItem(String productId) {
    if (!_item.containsKey(productId)) {
      return;
    }
    if (_item[productId].quentity > 1) {
      _item.update(
          productId,
          (existingCarditem) => CartItem(
              id: existingCarditem.id,
              title: existingCarditem.title,
              quentity: existingCarditem.quentity-1,
              price: existingCarditem.price));
    }else{
      _item.remove(productId);
    }
    notifyListeners();
  }

  void RemoveItem(String productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void addItem(
    String productId,
    String title,
    double Price,
  ) {
    if (_item.containsKey(productId)) {
      _item.update(
          productId,
          (addItems) => CartItem(
                id: addItems.id,
                title: addItems.title,
                price: addItems.price,
                quentity: addItems.quentity + 1,
              ));
    } else {
      _item.putIfAbsent(
          productId,
          () =>
              CartItem(id: productId, title: title, price: Price, quentity: 1));
    }

    notifyListeners();
  }
}

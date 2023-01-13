import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;


  CartItem({
  this.id,
  this.title,
  this.quantity,
  this.price,
  this.imageUrl,
  });

}
class Cart extends ChangeNotifier{
  Map<String ,CartItem> _items = {};
  Map <String ,CartItem> get items{
    return _items;
  }
   int get itemCount {
    return _items.length;
   }
   double get totalAmount {
    var total =0.0;
    _items.forEach((key, cartItem) {
      total = cartItem.price * cartItem.quantity;
    });
    return total;
   }
   void clear(){
    _items = {};
    notifyListeners();
   }


}
import 'package:flutter/foundation.dart';

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavorite = false
  });
  void _setFavValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }
}

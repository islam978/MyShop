import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myshop/models/http_exception.dart';
import 'package:myshop/providers/product.dart';
class Products extends ChangeNotifier{
  List<Product> _productsList = [];
  String  authToken ="";
  String userId = "";
  getData(String authTok,String uId,List<Product> products){
    authToken =authTok;
    userId = uId;
    _productsList=products;
    notifyListeners();
  }
  List<Product> get productsList{
    return _productsList;
  }

  List<Product> get favoritesProductsList{
    return _productsList.where((prodItem) => prodItem.isFavorite);
  }
  
  Product findById(String id){
    return _productsList.firstWhere((prodItem) => prodItem.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"':'';
    var url = "https://products-is-default-rtdb.firebaseio.com/product.json?auth=$authToken$filteredString";
    try {
      final http.Response res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if(extractedData == null) return;
      url ="https://products-is-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken" ;
      final favRes = await http.get(Uri.parse(url));
      final favData = json.decode(favRes.body);
      final List<Product> loadedProduct = [];
      
      extractedData.forEach((prodId, prodData) {
        final prodIndex =
        _productsList.indexWhere((element) => element.id == prodId);
        if (prodIndex >= 0) {
          _productsList[prodIndex] = Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          );
        } else {
          loadedProduct.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: favData==null?false:favData['prodId']??false,
            imageUrl: prodData['imageUrl'],
          ));
        }
      });
       _productsList = loadedProduct;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id,Product newProduct) async {
    final url = "https://flutter-app-568d3.firebaseio.com/product/$id.json";

    final prodIndex = _productsList.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      await http.patch(Uri.parse(url),
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imageUrl":newProduct.imageUrl,
          }));

      _productsList[prodIndex] = newProduct;
      //     Product(
      //   id: id,
      //   title: "new title 4",
      //   description: "new description 2",
      //   price: 199.8,
      //   imageUrl:
      //   "https://cdn.pixabay.com/photo/2015/06/19/21/24/the-road-815297__340.jpg",
      // );

      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> addProduct(Product product) async {
    const url = "https://products-is-default-rtdb.firebaseio.com/product.json"
        "";
    print("yes");
    try {
      http.Response res = await http.post(Uri.parse(url),
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "creatorId":userId,
          }));
      print("res");
      print(json.decode(res.body));

    //  _productsList.add(
          final  newProduct = Product(
        id: json.decode(res.body.toString())['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
          _productsList.add(newProduct);
      print("no");
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;

    }
  }

  Future<void> deleteProduct(String id) async {
    final url = "https://flutter-app-568d3.firebaseio.com/product/$id.json";

    final prodIndex = _productsList.indexWhere((element) => element.id == id);
    Product prodItem = _productsList[prodIndex];
    _productsList.removeAt(prodIndex);
    notifyListeners();

    var res = await http.delete(Uri.parse(url));
    if (res.statusCode >= 400) {
      _productsList.insert(prodIndex, prodItem);
      notifyListeners();
      throw HttpException("Could not deleted item");
    } else {
      ///nulll
      prodItem = null;
      print("Item deleted");
    }
  }
}
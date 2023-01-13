import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:myshop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}
class Orders extends ChangeNotifier{
  List <OrderItem> _orders =[];
  String authToken;
  String userId;
  List <OrderItem> get orders {
    return _orders;
  }
  getData(String authTok,String uId,List<OrderItem> products){
    authToken =authTok;
    userId = uId;
    _orders=orders;
    notifyListeners();
  }
  Future<void> fetchAndSetOrders() async {

   final url = "https://products-is-default-rtdb.firebaseio.com/orders.json?auth=$authToken";
    try {
      final http.Response res = await http.get(Uri.parse(url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      if(extractedData == null) return;
    //  url ="https://products-is-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken" ;

      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(

            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
          products:orderData['products'].map((item)=>CartItem(
            id: item['id'],
            price: item['price'],
            quantity:item['quantity'] ,
            title: item['title']
          )).toList(),


          )
        );
      });
      _orders=loadedOrders.reversed.toList() ;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
  Future <void> addOrders(List<CartItem> cartProducts,double total) async{
    final url = "https://products-is-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    try{
      final timeStamp =DateTime.now();
      final res =await http.post(Uri.parse(url),
        body:json.encode({
          'amount':total,
          'dateTime':timeStamp.toIso8601String(),
          'products':cartProducts.map((cp) => {
            'id':cp.id,
            'title':cp.title,
            'quantity':cp.quantity,
            'price':cp.price,
          }).toList()
        })
      );
      _orders.insert(0, OrderItem(
        id: json.decode(res.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProducts
      ));

    }
    catch(error){

    }
  }
}
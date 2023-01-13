import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
 import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';
import 'package:myshop/models/http_exception.dart';

class Auth extends ChangeNotifier{
  Timer _authTimer ;
  String _token ;
  String _userId;
  DateTime _expireDate;
  bool  get  isAuth{
    return _token !=null ;
  }
  String get token{
    if(_expireDate != null && _expireDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> authenticate (String email,String password, String urlSegment) async{
    String url = "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCYc4jhSO5gMApjw78PG-KYZrIe-5hfyJA";
    try{
      final res =  await http.post(Uri.parse(url),body: json.encode({
        "email":email,
        "password":password,
        "returnSecureToken":true
      }));
      var responseData =  json.decode(res.body);

      if(responseData["error"] != null){
        HttpException(responseData["error"]["message"]);
        throw "${responseData["error"]["message"]}";
      }
      _token = responseData["idToken"];
      _expireDate=DateTime.now().add( Duration(seconds:int.parse(responseData["expiresIn"].toString())));print(_expireDate);
      _userId=responseData["localId"];
      final prefs =  await SharedPreferences.getInstance();
      final userData = json.encode({
        'token':_token,
        'userId':_userId,
        'expiryDate':_expireDate.toIso8601String()
      });
      prefs.setString('userData',userData);
      autoLogin();
       autoLogout();
      notifyListeners();

    }
    catch(e){
      print(e);
      throw(e);
    }

  }
  Future autoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final  extractData =json.decode(prefs.getString('userData'));
    //as Map<String,Object>;
    final expiryDate = DateTime.parse(extractData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractData['token'];
    _userId =extractData['userId'];
    _expireDate =expiryDate;
    notifyListeners();
  }
  Future <void> signUp(String email,String password) async{
    await authenticate(email, password, "signUp");
  }
  Future <void> login(String email,String password) async{
    await authenticate(email, password, "signInWithPassword");
  }
  void logout(){
    _token = null;
    _userId = null;
    _expireDate= null;
    if(_authTimer != null){
      _authTimer.cancel;
      _authTimer = null;
    }
    notifyListeners();
  }
  void autoLogout() {
    if(_authTimer != null){
      _authTimer.cancel;
    }
    final timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer =Timer( Duration(seconds: timeToExpiry),logout);

  }


}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop/widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget{
  static const routeName ='/user_products';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: null,
      drawer: AppDrawer(),
    );
  }

}

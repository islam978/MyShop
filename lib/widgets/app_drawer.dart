import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/screens/orders_screen.dart';
import 'package:myshop/screens/product_overview_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text('Hello Friend'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('myshop'),
          onTap: ()=>Navigator.of(context).pushReplacementNamed('/'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders'),
          onTap: ()=>Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Manage Products'),
          onTap: ()=>Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: (){
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context).logout();

          },
        ),
      ]),
    );
  }
}

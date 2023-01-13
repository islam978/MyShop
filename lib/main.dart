import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/orders.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/auth_screen.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/screens/orders_screen.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:myshop/screens/product_overview_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value:Auth()),
      ChangeNotifierProvider.value(value:Cart()),
      ChangeNotifierProvider.value(value:Product()),
      ChangeNotifierProxyProvider<Auth,Products>(
        create: (_)=>Products(),
        update: (ctx,authValue,previousProducts)=>previousProducts..getData(
            authValue.token,
            authValue.userId,
             previousProducts == null ?null:previousProducts.productsList),
      ),
      ChangeNotifierProvider.value(value:Orders()),


    ],
      child: MyApp()
  ));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx,auth,_)=>MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: auth.isAuth?ProductOverviewScreen():AuthScreen(),
        routes: {
          ProductDetailScreen.routeName:(_)=>ProductDetailScreen(),
          CartScreen.routeName:(_)=>CartScreen(),
          OrdersScreen.routeName:(_)=>OrdersScreen(),
         UserProductsScreen.routeName:(_)=>UserProductsScreen(),
          EditProductScreen.routeName:(_)=>EditProductScreen(),

        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("myshop"),
      ),
      body: const Center(child:  Text('Text')),

    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';


enum FilterOption {
  Favorite,
  All

}
class ProductOverviewScreen extends StatefulWidget{
  static const routeName ='/';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoading = false;
  var _showOnlyFavoritys = false;


  @override
  void initState() {
    super.initState();
    _isLoading =true;
    Provider.of<Products>(context,listen: false).fetchAndSetProducts().then((value) => _isLoading=false);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Shop'),
        actions: [
          PopupMenuButton(onSelected: (FilterOption selectedValue)=>selectedValue

          ,
              icon: Icon(Icons.more_vert),
              itemBuilder: (_)=>[
                PopupMenuItem(child: Text('Only Favorites'),value: FilterOption.Favorite,),
                PopupMenuItem(child: Text('Show All'),value: FilterOption.All,)

          ]),
          Consumer<Cart>(
              child:IconButton(
                  icon:Icon(Icons.shopping_cart),
                onPressed: ()=>Navigator.of(context).pushNamed(CartScreen.routeName),
              ),
            builder: (_,cart,ch)=>Icon(Icons.add),
          )
        ],
      ),

      body: null,
      drawer: AppDrawer(),
    );
  }
}
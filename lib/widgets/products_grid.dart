import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget{
  final bool showFavs;

  const ProductsGrid({Key key, this.showFavs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavs ? productData.favoritesProductsList :productData.productsList;
    return GridView.builder(
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx,i)=>ChangeNotifierProvider.value(
           value: products[i],
          child: ProductItem(),
        ))
  }


}
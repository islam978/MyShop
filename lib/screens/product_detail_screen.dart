import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/app_drawer.dart';

class ProductDetailScreen extends StatelessWidget{
  static const routeName ='/product_detail';
  final String id;

  const ProductDetailScreen({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List prodList = Provider.of<Products>(context, listen: true).productsList;
//List<Product>
    var filteredItem = prodList.firstWhere((element) => element.id == id, orElse: () => null );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

        title: filteredItem == null ? null : Text(filteredItem.title),
        actions: [
          FlatButton(onPressed: (){},child:Text("Update Data") ,)
              //Provider.of<Products>(context, listen: false).updateProduct(id,), child: Text("Update Data"))
        ],
      ),
      drawer: AppDrawer(),
      body: filteredItem == null
          ? null
          : ListView(
        children: [
          const SizedBox(height: 10),
          buildContainer(filteredItem.imageUrl, filteredItem.id),
          SizedBox(height: 10),
          buildCard(filteredItem.title, filteredItem.description,
              filteredItem.price),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.pop(context, filteredItem.id);
        },
        child: Icon(Icons.delete, color: Colors.black),
      ),
    );
  }

  Container buildContainer(String image, String id) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Hero(
          tag: id,
          child: Image.network(image,scale: 0.02,),
        ),
      ),
    );
  }

  Card buildCard(String title, String desc, double price) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(7),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.black),
            Text(desc,
                style: TextStyle(fontSize: 16), textAlign: TextAlign.justify),
            Divider(color: Colors.black),
            Text(
              "\$$price",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
  }


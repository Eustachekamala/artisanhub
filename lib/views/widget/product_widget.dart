import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:artisanhub/services/api_service.dart';

class ProductWidget extends StatefulWidget{
  const ProductWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget>{
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    loadProducts();
  }

  void loadProducts()  async {
    try {
      final result = await ApiService.getAllProducts();
      setState(() {
        products = result;
      });
    }catch(e){
      if (kDebugMode) {
        print("Error loading products: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: products.isEmpty
        ? Center(
          child: CircularProgressIndicator(),
        )
        : ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(product["name"]),
              subtitle: Text(product["description"]),
              trailing: Text("\$${product["price"]}"),
              onTap: () {
                // TODO: Navigate to product detail page
              },
            );
          },
      ),
    );
  }
}
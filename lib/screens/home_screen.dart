import 'dart:convert';
import 'package:product_api/screens/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_api/screens/modify_page.dart';
import 'package:product_api/screens/adding_page.dart';

class ECommercePage extends StatefulWidget {
  @override
  _ECommercePageState createState() => _ECommercePageState();
}

class _ECommercePageState extends State<ECommercePage> {
  //late Future<List<dynamic>> _fetchData;
  List<Product> product_list = [];
  @override
  void initState() {
    super.initState();
    fetchData(); // Call the function to fetch data
  }

  void fetchData() async {
    // Make HTTP request to fetch data from the e-commerce website
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final resdata = json.decode(response.body);
      final resp = welcomeFromJson(response.body);
      setState(() {
        product_list = resp;
      });
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load data');
    }
  }

// Function to handle adding a new product
  void addProduct(Product newProduct) async {
    // Send HTTP request to add the new product
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/products'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newProduct.toJson()),
    );

    if (response.statusCode == 201) {
      // If the product was successfully added, fetch updated data
      fetchData();
    } else {
      // If adding the product failed, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add product'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Function to handle updating an existing product
  void updateProduct(Product updatedProduct) async {
    // Send HTTP request to update the product
    final response = await http.put(
      Uri.parse('https://fakestoreapi.com/products/${updatedProduct.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedProduct.toJson()),
    );

    if (response.statusCode == 200) {
      // If the product was successfully updated, fetch updated data
      fetchData();
    } else {
      // If updating the product failed, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to update product'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> deleteProduct(int productId) async {
    // Send HTTP request to delete the product
    final response = await http.delete(
      Uri.parse('https://fakestoreapi.com/products/$productId'),
    );

    if (response.statusCode == 200) {
      // If the product was successfully deleted, fetch updated data
      fetchData();
    } else {
      // If deleting the product failed, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to delete product'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('E-Commerce Products'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Navigate to the product detail page to add a new product
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddingPage(
                      onProductSubmitted: addProduct,
                      list_size: product_list.last.id,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: product_list.length,
          itemBuilder: (context, index) {
            // Create a ListTile for each product
            final product = product_list[index];
            return GestureDetector(
              onTap: () {},
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        product.image,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 8),
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${product.rating.rate}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Text(
                        '${product.price}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.category.name,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  color: Colors.red,
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Delete Product'),
                                          content: Text(
                                              'Are you sure you want to delete this product?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Delete'),
                                              onPressed: () {
                                                // Call the deleteProduct function to delete the product
                                                deleteProduct(product.id);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  color: Colors.green,
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ModifyPage(
                                          onProductSubmitted: updateProduct,
                                          list_size: product.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}

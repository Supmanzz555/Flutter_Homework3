import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hw4/model.dart';

class ApiService {
  final String baseUrl = "http://localhost:8001/products";

  // Get 
  Future<List<Product>> fetchData() async {
    try {
      var res = await http.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(res.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load products: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  // Create 
  Future<bool> createProduct(Product product) async {
    try {
      var res = await http.post(Uri.parse(baseUrl),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": product.name,
            "description": product.desc,
            "price": product.price,
          }));
      return res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Update 
  Future<bool> updateProduct(Product product) async {
    try {
      var res = await http.put(Uri.parse("$baseUrl/${product.id}"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "name": product.name,
            "description": product.desc,
            "price": product.price,
          }));
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Delete 
  Future<bool> deleteProduct(Product product) async {
    try {
      var res = await http.delete(Uri.parse("$baseUrl/${product.id}"),
          headers: {'Content-Type': 'application/json'});
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

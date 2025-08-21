import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api/v1/products";

  static Map<String, String> getHeaders() {
    return {
      "Content-Type": "application/json",
    };
  }

  //GET all products
  static Future<List<dynamic>> getAllProducts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/all"),
      headers: getHeaders()
    );

    if(response.statusCode == 200){
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load products");
    }
  }
}
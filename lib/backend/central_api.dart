import 'dart:convert';
// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:trustdine_kds/storage/cache.dart';

String baseUrl = "https://trustdine.onrender.com/api";

Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {"Content-Type": "application/json"},
    body: json.encode({"email": email, "password": password}),
  );
  return json.decode(response.body);
}

Future<Map<String, dynamic>> getUser(String authToken) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/getuser'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken,
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get user: $response');
  }
}

Future<Map<String, dynamic>> sendOrder(String authToken, String orderId,
    List<Map<String, String>> orderItems) async {
  final response = await http.post(
    Uri.parse('$baseUrl/order/add-order'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken,
      "Content-Type":
          "application/json", // Specify the content type for the request
    },
    body: json.encode({
      "orderId": orderId,
      "orderItems": orderItems,
    }),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to send order: $response');
  }
}

Future<List<dynamic>> fetchOrders() async {
  String? token = await SecureStorageManager.getToken();
  if (token == null) {
    throw Exception('Token not available');
  }

  String authToken = token;
  final response = await http.get(
    Uri.parse('$baseUrl/order/all-orders'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken,
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    List<dynamic> orders = jsonResponse['allOrders'];
    return orders;
  } else {
    throw Exception('Failed to fetch orders: ${response.statusCode}');
  }
}

Future<void> deleteOrder(String orderId) async {
  String? token = await SecureStorageManager.getToken() as String;
  String authToken = token;
  final response = await http.delete(
    Uri.parse('$baseUrl/order/delete-order/$orderId'),
    headers: {
      "Accept": "*/*",
      "User-Agent": "Thunder Client",
      "auth-token": authToken,
    },
  );

  if (response.statusCode == 200) {
    print('Order deleted successfully');
  } else {
    throw Exception('Failed to delete order: $response');
  }
}

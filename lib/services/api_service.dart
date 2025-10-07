import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';


// ⚠️ Mets l'URL de ton serveur ici
// Android emulator: http://10.0.2.2:3000
// iOS simulator: http://localhost:3000
// Device physique: http://<IP-LAN>:3000
const String kBaseUrl = 'http://10.4.15.250:3000';
class ApiService {
    static Future<void> saveToken(String token) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
    }
    static Future<String?> getToken() async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString('token');
    }
    static Future<void> clearToken() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
    }
    static Future<Map<String, dynamic>> login({required String username, required String phone}) async {
        final url = Uri.parse('$kBaseUrl/login');
        final res = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
                'username': username,
                'phone': phone,
                'role': 'agent', // important
            }),
    );
        if (res.statusCode >= 200 && res.statusCode < 300) {
            final data = jsonDecode(res.body) as Map<String, dynamic>;
            final token = data['token']?.toString();
            if (token != null) {
                await saveToken(token);
            }
            return data;
        } else {
            throw Exception('Login failed: ${res.statusCode} ${res.body}');
        }
    }
    static Future<List<Order>> fetchOrders() async {
        final token = await getToken();
        final url = Uri.parse('$kBaseUrl/delivery/orders');
        final res = await http.get(url, headers: {
            'Authorization': 'Bearer ${token ?? ''}',
            'Content-Type': 'application/json',
        });
        if (res.statusCode == 200) {
            final list = jsonDecode(res.body) as List<dynamic>;
            return list.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
        } else if (res.statusCode == 401 || res.statusCode == 403) {
            await clearToken();
            throw Exception('Unauthorized. Please login again.');
        } else {
            throw Exception('Failed to fetch orders: ${res.statusCode}');
        }
    }
    static Future<Order> assignOrder(String orderId) async {
        final token = await getToken();
        final url = Uri.parse('$kBaseUrl/delivery/orders/$orderId/assign');
        final res = await http.post(url, headers: {
            'Authorization': 'Bearer ${token ?? ''}',
            'Content-Type': 'application/json',
        });
        if (res.statusCode >= 200 && res.statusCode < 300) {
            final data = jsonDecode(res.body) as Map<String, dynamic>;
            return Order.fromJson(data['order'] as Map<String, dynamic>);
        } else {
            throw Exception('Assign failed: ${res.statusCode}');
        }
    }
    static Future<Order> updateStatus(String orderId, String status) async {
        final token = await getToken();
        final url = Uri.parse('$kBaseUrl/delivery/orders/$orderId/status');
        final res = await http.post(
            url,
            headers: {
                'Authorization': 'Bearer ${token ?? ''}',
                'Content-Type': 'application/json',
            },
            body: jsonEncode({'status': status}),
        );
        if (res.statusCode >= 200 && res.statusCode < 300) {
            final data = jsonDecode(res.body) as Map<String, dynamic>;
            return Order.fromJson(data['order'] as Map<String, dynamic>);
        } else {
        throw Exception('Status update failed: ${res.statusCode}');
        }
    }
    static Future<void> logout() async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");
        await prefs.remove("username");
        await prefs.remove("phone");
  }
}

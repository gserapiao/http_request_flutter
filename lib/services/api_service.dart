import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static Future<UserModel?> fetchUser(int id) async {
    final url = Uri.parse('https://reqres.in/api/users/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['data'] != null) {
        return UserModel.fromJson(data['data']);
      }
    }
    return null;
  }
}

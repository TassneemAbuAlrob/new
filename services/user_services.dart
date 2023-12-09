import 'dart:convert';
import 'package:http/http.dart' as http;

class UserServices {
  static String? userEmail;
  static String? userProfileType;

  static Future login({required String email, required String password}) async {
    try {
      final uri = Uri.parse('http://192.168.1.112:3000/login');
      final response = await http.post(uri,
          headers: {'Content-Type': 'application/json; charset=utf-8'},
          body: jsonEncode({'email': email, 'password': password}));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        userEmail = email;
        userProfileType = data['profileType'];
        print(userProfileType);
        return;
      } else if (response.statusCode == 404) {
        throw "User Not Found";
      } else if (response.statusCode == 400) {
        throw "Invalid Password";
      }
    } catch (error) {
      throw error.toString();
    }
  }

  static String getEmail() {
    return userEmail ?? '';
  }

  static String? getProfileType() {
    return userProfileType;
  }
}

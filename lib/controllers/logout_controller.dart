import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:newbestshop/screens/auth_screen.dart';

class LogoutController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await _prefs;

      String? token = prefs.getString('token');

      if (token != null) {
        var headers = {'Authorization': 'Bearer $token'};

        var url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.logoutEmail);

        var response = await http.post(url, headers: headers);

        if (response.statusCode == 200) {
          // await prefs.remove('token');
          await prefs.clear();
          Get.offAll(AuthScreen());
        } else {
          throw Exception('Logout failed: ${response.body}');
        }
      } else {
        throw Exception('Token not found. User may already be logged out.');
      }
    } catch (error) {
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }
}

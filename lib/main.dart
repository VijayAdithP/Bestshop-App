import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/screens/main_page.dart';
import 'package:newbestshop/screens/auth_screen.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    // const GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: Home_Page(),

    GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: token != null ? const Home_Page() : const AuthScreen(),
    ),
  );
}

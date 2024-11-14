import 'dart:convert';

import 'package:hexcolor/hexcolor.dart';
import 'package:newbestshop/controllers/login_controller.dart';
import 'package:newbestshop/controllers/registeration_controller.dart';
import 'package:newbestshop/models/locationModel.dart';
import 'package:newbestshop/screens/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  LoginController loginController = Get.put(LoginController());
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Positioned(
            right: 320,
            top: 10,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: HexColor("#8B5DFF").withOpacity(0.4),
            ),
          ),
          Positioned(
            right: 250,
            top: -50,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: HexColor("#8B5DFF").withOpacity(0.4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome!",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: HexColor("#563A9C"),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: loginWidget(),
                ),
              ],
            ),
          ),
          Positioned(
              // right: MediaQuery.devicePixelRatioOf(context) * 50,
              right: 0,
              left: 0,
              bottom: 10,
              child: SizedBox(
                child: Center(
                  child: RichText(
                    maxLines: 1,
                    text: TextSpan(
                      text: 'Developed by ',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(146, 87, 111, 168),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Vijay Adith P',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#8B5DFF"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget loginWidget() {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),

          TextFormField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.justify,
            textInputAction: TextInputAction.next,
            controller: loginController.emailController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
              helperText: ' ',
              isDense: true,
              contentPadding: const EdgeInsets.only(
                left: 15,
                bottom: 39,
              ),
              alignLabelWithHint: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: HexColor("#8B5DFF"),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              // errorStyle: const TextStyle(height: 0),
              filled: true,
              fillColor: Colors.white,
              errorMaxLines: 1,
              hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(146, 87, 111, 168),
              ),
              hintText: 'username',
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // InputTextFieldWidget(
          //   loginController.passwordController,
          //   'password',
          // ),
          TextFormField(
            obscureText: obscure,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.justify,
            textInputAction: TextInputAction.next,
            controller: loginController.passwordController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              return null;
            },
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                child: obscure
                    ? const Icon(Icons.remove_red_eye_rounded)
                    : const Icon(Icons.password_rounded),
              ),
              helperText: ' ',
              isDense: true,
              contentPadding: const EdgeInsets.only(
                left: 15,
                bottom: 39,
              ),
              alignLabelWithHint: true,
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: HexColor("#8B5DFF"),
                  width: 2.0,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              errorStyle: const TextStyle(height: 0),
              filled: true,
              fillColor: Colors.white,
              hintStyle: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(146, 87, 111, 168),
              ),
              hintText: 'password',
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          SubmitButton(
            onPressed: () async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              String username = loginController.emailController.text;
              if (_formKey.currentState!.validate()) {
                prefs.setString('username', username);
                loginController.loginWithEmail();
              } else {
                // Show SnackBar if form is not valid
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields.'),
                  ),
                );
              }
            },
            title: 'Login',
          ),
          const SizedBox(
            height: 5,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "Don't have an account?",
          //       style: GoogleFonts.outfit(
          //         fontWeight: FontWeight.w500,
          //         // fontSize: 16,
          //         // fontWeight: FontWeight.w400,
          //       ),
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         Get.off(() => const Register());
          //       },
          //       child: Text(
          //         "Register",
          //         style: GoogleFonts.outfit(
          //           // fontSize: 16,
          //           fontWeight: FontWeight.w600,

          //           color: const Color(0xFF4860b5),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class Role {
  int? id;
  String? roleName;

  Role({this.id, this.roleName});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['role_name'] = this.roleName;
    return data;
  }
}

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    super.initState();
    _fetchTokenAndItemNames();
    getShopLocation();
  }

  late String _token;
  List<Role> rolesData = [];

  Future<void> getShopLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getLocation),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          locations = data.map((shop) => Location.fromJson(shop)).toList();
        });
      } else {
        throw Exception('Failed to load shop locations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> _fetchTokenAndItemNames() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
    print(_token);
    _fetchItemNames();
  }

  Future<void> _fetchItemNames() async {
    try {
      final Uri apiUri = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.roleFetch);
      final response = await http.get(
        apiUri,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          rolesData = data.map((item) => Role.fromJson(item)).toList();
        });
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  void dispose() {
    registerationController.nameController.clear();
    registerationController.passwordController.clear();
    registerationController.phonenumberController.clear();
    super.dispose();
  }

  List<Location> locations = [];
  RegisterationController registerationController =
      Get.put(RegisterationController());

  GlobalKey<FormState> RegisterformKey = GlobalKey<FormState>();
  int selectedRole = 1;
  int selectedLocation = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Add users",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: HexColor("#6A42C2"),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Form(
            key: RegisterformKey,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "Back Again So Soon",
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.w600,
                    //     color: const Color(0xFF4860b5),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.sizeOf(context).height / 15,
                    // ),
                    const Row(
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.justify,
                      textInputAction: TextInputAction.next,
                      controller: registerationController.nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        helperText: ' ',
                        isDense: true,
                        contentPadding: const EdgeInsets.only(
                          left: 15,
                          bottom: 39,
                        ),
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            // color: Color.fromARGB(143, 0, 140, 255),
                            color: HexColor("#8B5DFF"),
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        errorStyle: const TextStyle(height: 0),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(146, 87, 111, 168),
                        ),
                        hintText: 'username',
                      ),
                    ),

                    const Row(
                      children: [
                        Text(
                          "Phone number",
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.justify,
                      textInputAction: TextInputAction.next,
                      controller: registerationController.phonenumberController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        helperText: ' ',
                        isDense: true,
                        contentPadding: const EdgeInsets.only(
                          left: 15,
                          bottom: 39,
                        ),
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor("#8B5DFF"),
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        errorStyle: const TextStyle(height: 0),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(146, 87, 111, 168),
                        ),
                        hintText: 'phone number',
                      ),
                    ),

                    const Row(
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.justify,
                      textInputAction: TextInputAction.next,
                      controller: registerationController.passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        helperText: ' ',
                        isDense: true,
                        contentPadding: const EdgeInsets.only(
                          left: 15,
                          bottom: 39,
                        ),
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: HexColor("#8B5DFF"),
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        errorStyle: const TextStyle(height: 0),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(146, 87, 111, 168),
                        ),
                        hintText: 'password',
                      ),
                    ),

                    const Row(
                      children: [
                        Text(
                          "Role",
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 60,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          // color: Colors.grey[400]!,
                          color: Colors.transparent,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                          ),
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButton<int>(
                        underline: const SizedBox(),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                        isExpanded: true,
                        value: selectedRole,
                        elevation: 1,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedRole = newValue!;
                            registerationController.role =
                                rolesData[selectedRole - 1].id.toString();
                          });
                        },
                        items: rolesData.map((map) {
                          return DropdownMenuItem(
                            value: map.id,
                            child: Text(
                              map.roleName!,
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 60,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          // color: Colors.grey[400]!,
                          color: Colors.transparent,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                          ),
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButton<int>(
                        underline: const SizedBox(),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                        isExpanded: true,
                        value: selectedLocation,
                        elevation: 1,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                            registerationController.location =
                                locations[selectedLocation - 1].id.toString();
                          });
                        },

                        items: locations.map((map) {
                          return DropdownMenuItem(
                            value: map.id,
                            child: Text(
                              map.name!,
                              style: TextStyle(
                                color: Colors.grey[800],
                              ),
                            ),
                          );
                        }).toList(),
                        // <DropdownMenuItem<int>>[

                        // DropdownMenuItem<int>(
                        //   value: 1,
                        //   child: Text(
                        //     'Admin',
                        // style: TextStyle(
                        //   color: Colors.grey[800],
                        // ),
                        //   ),
                        // ),
                        // DropdownMenuItem<int>(
                        //   value: 2,
                        //   child: Text(
                        //     'User',
                        //     style: TextStyle(
                        //       color: Colors.grey[800],
                        //     ),
                        //   ),
                        // ),
                        // DropdownMenuItem<int>(
                        //   value: 3,
                        //   child: Text(
                        //     'Campus',
                        //     style: TextStyle(
                        //       color: Colors.grey[800],
                        //     ),
                        //   ),
                        // ),
                        // ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "Already have an account?",
                    //       style: GoogleFonts.outfit(
                    //         fontWeight: FontWeight.w500,
                    //         // fontSize: 16,
                    //         // fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         // Navigator.push(
                    //         //   context,
                    //         //   MaterialPageRoute(builder: (context) => const AuthScreen()),
                    //         // );
                    //         Get.off(() => const AuthScreen());
                    //       },
                    //       child: Text(
                    //         "Sign In",
                    //         style: GoogleFonts.outfit(
                    //           fontWeight: FontWeight.w600,
                    //           // fontSize: 16,
                    //           // fontWeight: FontWeight.w400,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SubmitButton(
                    title: 'Register',
                    onPressed: () async {
                      if (RegisterformKey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      left: 3,
                                      right: 3,
                                      bottom: 3,
                                    ),
                                    child: Container(
                                      width: 150,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                          vertical: 20,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Are you sure?",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      child: Text(
                                                        "No",
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                  VerticalDivider(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    thickness: 1,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      registerationController
                                                          .registerWithEmail();
                                                    },
                                                    child: const Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                      ),
                                                      child: Text(
                                                        "yes",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    72,
                                                                    96,
                                                                    181,
                                                                    1),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(milliseconds: 500),
                            content: Text('Please fill in all fields.'),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  // Widget registerWidget(List<Role> data) {
  //   GlobalKey<FormState> RegisterformKey = GlobalKey<FormState>();
  //   int selectedRole = 1;
  //   int selectedLocation = 1;
  //   return Form(
  //     key: RegisterformKey,
  //     child: Stack(
  //       children: [
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Text(
  //             //   "Back Again So Soon",
  //             //   style: GoogleFonts.poppins(
  //             //     fontSize: 20,
  //             //     fontWeight: FontWeight.w600,
  //             //     color: const Color(0xFF4860b5),
  //             //   ),
  //             // ),
  //             // SizedBox(
  //             //   height: MediaQuery.sizeOf(context).height / 15,
  //             // ),
  //             const Row(
  //               children: [
  //                 Text(
  //                   "Username",
  //                   style: TextStyle(
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //                 Text(
  //                   "*",
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             TextFormField(
  //               textAlignVertical: TextAlignVertical.center,
  //               textAlign: TextAlign.justify,
  //               textInputAction: TextInputAction.next,
  //               controller: registerationController.nameController,
  //               autovalidateMode: AutovalidateMode.onUserInteraction,
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return '';
  //                 }
  //                 return null;
  //               },
  //               decoration: InputDecoration(
  //                 helperText: ' ',
  //                 isDense: true,
  //                 contentPadding: const EdgeInsets.only(
  //                   left: 15,
  //                   bottom: 39,
  //                 ),
  //                 alignLabelWithHint: true,
  //                 border: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.transparent,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 focusedBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Color.fromARGB(143, 0, 140, 255),
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 enabledBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.transparent,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 errorBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.red,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 errorStyle: const TextStyle(height: 0),
  //                 filled: true,
  //                 fillColor: Colors.white,
  //                 hintStyle: GoogleFonts.poppins(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: const Color.fromARGB(146, 87, 111, 168),
  //                 ),
  //                 hintText: 'username',
  //               ),
  //             ),

  //             const Row(
  //               children: [
  //                 Text(
  //                   "Phone number",
  //                   style: TextStyle(
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //                 Text(
  //                   "*",
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             TextFormField(
  //               textAlignVertical: TextAlignVertical.center,
  //               textAlign: TextAlign.justify,
  //               textInputAction: TextInputAction.next,
  //               controller: registerationController.phonenumberController,
  //               autovalidateMode: AutovalidateMode.onUserInteraction,
  //               keyboardType: TextInputType.number,
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return '';
  //                 }
  //                 return null;
  //               },
  //               decoration: InputDecoration(
  //                 helperText: ' ',
  //                 isDense: true,
  //                 contentPadding: const EdgeInsets.only(
  //                   left: 15,
  //                   bottom: 39,
  //                 ),
  //                 alignLabelWithHint: true,
  //                 border: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.transparent,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 focusedBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Color.fromARGB(143, 0, 140, 255),
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 enabledBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.transparent,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 errorBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.red,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 errorStyle: const TextStyle(height: 0),
  //                 filled: true,
  //                 fillColor: Colors.white,
  //                 hintStyle: GoogleFonts.poppins(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w600,
  //                   color: const Color.fromARGB(146, 87, 111, 168),
  //                 ),
  //                 hintText: 'phone number',
  //               ),
  //             ),

  //             const Row(
  //               children: [
  //                 Text(
  //                   "Password",
  //                   style: TextStyle(
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //                 Text(
  //                   "*",
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             TextFormField(
  //               textAlignVertical: TextAlignVertical.center,
  //               textAlign: TextAlign.justify,
  //               textInputAction: TextInputAction.next,
  //               controller: registerationController.passwordController,
  //               autovalidateMode: AutovalidateMode.onUserInteraction,
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return '';
  //                 }
  //                 return null;
  //               },
  //               decoration: InputDecoration(
  //                 helperText: ' ',
  //                 isDense: true,
  //                 contentPadding: const EdgeInsets.only(
  //                   left: 15,
  //                   bottom: 39,
  //                 ),
  //                 alignLabelWithHint: true,
  //                 border: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.transparent,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 focusedBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Color.fromARGB(143, 0, 140, 255),
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 enabledBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.transparent,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 errorBorder: const OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.red,
  //                     width: 2.0,
  //                   ),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(10),
  //                   ),
  //                 ),
  //                 errorStyle: const TextStyle(height: 0),
  //                 filled: true,
  //                 fillColor: Colors.white,
  //                 hintStyle: GoogleFonts.poppins(
  //                   fontSize: 16,
  //                   // fontWeight: FontWeight.w500,
  //                   fontWeight: FontWeight.w600,
  //                   color: const Color.fromARGB(146, 87, 111, 168),
  //                 ),

  //                 // TextStyle(
  //                 //   color: Color.fromARGB(146, 87, 111, 168),
  //                 //   fontWeight: FontWeight.w400,
  //                 //   fontSize: 16,
  //                 // ),
  //                 hintText: 'password',
  //               ),
  //             ),

  //             // const SizedBox(
  //             //   height: 10,
  //             // ),
  //             const Row(
  //               children: [
  //                 Text(
  //                   "Role",
  //                   style: TextStyle(
  //                     // color: Colors.red,
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //                 Text(
  //                   "*",
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Container(
  //               height: 60,
  //               width: double.maxFinite,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 border: Border.all(color: Colors.grey[400]!),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                     color: Colors.white,
  //                   ),
  //                 ],
  //                 borderRadius: const BorderRadius.all(
  //                   Radius.circular(10),
  //                 ),
  //               ),
  //               padding: const EdgeInsets.all(16.0),
  //               child: DropdownButton<int>(
  //                 underline: const SizedBox(),
  //                 borderRadius: const BorderRadius.all(
  //                   Radius.circular(15),
  //                 ),
  //                 dropdownColor: Colors.white,
  //                 style: const TextStyle(
  //                   fontSize: 17,
  //                 ),
  //                 isExpanded: true,
  //                 value: selectedRole,
  //                 elevation: 1,
  //                 onChanged: (int? newValue) {
  //                   setState(() {
  //                     selectedRole = newValue!;
  //                   });
  //                 },
  //                 items: data.map((map) {
  //                   return DropdownMenuItem(
  //                     value: map.id,
  //                     child: Text(
  //                       map.roleName!,
  //                       style: TextStyle(
  //                         color: Colors.grey[800],
  //                       ),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ),
  //             const Row(
  //               children: [
  //                 Text(
  //                   "Location",
  //                   style: TextStyle(
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //                 Text(
  //                   "*",
  //                   style: TextStyle(
  //                     color: Colors.red,
  //                     fontSize: 19,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             ),
  //             Container(
  //               height: 60,
  //               width: double.maxFinite,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 border: Border.all(color: Colors.grey[400]!),
  //                 boxShadow: const [
  //                   BoxShadow(
  //                     color: Colors.white,
  //                   ),
  //                 ],
  //                 borderRadius: const BorderRadius.all(
  //                   Radius.circular(10),
  //                 ),
  //               ),
  //               padding: const EdgeInsets.all(16.0),
  //               child: DropdownButton<int>(
  //                 underline: const SizedBox(),
  //                 borderRadius: const BorderRadius.all(
  //                   Radius.circular(15),
  //                 ),
  //                 dropdownColor: Colors.white,
  //                 style: const TextStyle(
  //                   fontSize: 17,
  //                 ),
  //                 isExpanded: true,
  //                 value: selectedLocation,
  //                 elevation: 1,
  //                 onChanged: (int? newValue) {
  //                   setState(() {
  //                     selectedLocation = newValue!;
  //                   });
  //                 },

  //                 items: locations.map((map) {
  //                   return DropdownMenuItem(
  //                     value: map.id,
  //                     child: Text(
  //                       map.name!,
  //                       style: TextStyle(
  //                         color: Colors.grey[800],
  //                       ),
  //                     ),
  //                   );
  //                 }).toList(),
  //                 // <DropdownMenuItem<int>>[

  //                 // DropdownMenuItem<int>(
  //                 //   value: 1,
  //                 //   child: Text(
  //                 //     'Admin',
  //                 // style: TextStyle(
  //                 //   color: Colors.grey[800],
  //                 // ),
  //                 //   ),
  //                 // ),
  //                 // DropdownMenuItem<int>(
  //                 //   value: 2,
  //                 //   child: Text(
  //                 //     'User',
  //                 //     style: TextStyle(
  //                 //       color: Colors.grey[800],
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 // DropdownMenuItem<int>(
  //                 //   value: 3,
  //                 //   child: Text(
  //                 //     'Campus',
  //                 //     style: TextStyle(
  //                 //       color: Colors.grey[800],
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 // ],
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 20,
  //             ),

  //             // Row(
  //             //   mainAxisAlignment: MainAxisAlignment.center,
  //             //   children: [
  //             //     Text(
  //             //       "Already have an account?",
  //             //       style: GoogleFonts.outfit(
  //             //         fontWeight: FontWeight.w500,
  //             //         // fontSize: 16,
  //             //         // fontWeight: FontWeight.w400,
  //             //       ),
  //             //     ),
  //             //     TextButton(
  //             //       onPressed: () {
  //             //         // Navigator.push(
  //             //         //   context,
  //             //         //   MaterialPageRoute(builder: (context) => const AuthScreen()),
  //             //         // );
  //             //         Get.off(() => const AuthScreen());
  //             //       },
  //             //       child: Text(
  //             //         "Sign In",
  //             //         style: GoogleFonts.outfit(
  //             //           fontWeight: FontWeight.w600,
  //             //           // fontSize: 16,
  //             //           // fontWeight: FontWeight.w400,
  //             //         ),
  //             //       ),
  //             //     ),
  //             //   ],
  //             // ),
  //           ],
  //         ),
  //         Positioned(
  //           bottom: 0,
  //           left: 0,
  //           right: 0,
  //           child: SubmitButton(
  //             title: 'Register',
  //             onPressed: () async {
  //               if (RegisterformKey.currentState!.validate()) {
  //                 showDialog(
  //                     context: context,
  //                     builder: (context) {
  //                       return Dialog(
  //                         backgroundColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(15.0),
  //                         ),
  //                         child: ClipRRect(
  //                           borderRadius: BorderRadius.circular(15.0),
  //                           child: Padding(
  //                             padding: const EdgeInsets.only(
  //                               top: 3,
  //                               left: 3,
  //                               right: 3,
  //                               bottom: 3,
  //                             ),
  //                             child: Container(
  //                               width: 150,
  //                               decoration: const BoxDecoration(
  //                                 color: Colors.white,
  //                               ),
  //                               child: Padding(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 20.0,
  //                                   vertical: 20,
  //                                 ),
  //                                 child: Column(
  //                                   mainAxisSize: MainAxisSize.min,
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.center,
  //                                   children: [
  //                                     const Text(
  //                                       "Are you sure?",
  //                                       style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontSize: 23,
  //                                         fontWeight: FontWeight.bold,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       height: 30,
  //                                     ),
  //                                     IntrinsicHeight(
  //                                       child: Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.spaceEvenly,
  //                                         children: [
  //                                           GestureDetector(
  //                                             onTap: () {
  //                                               Navigator.of(context).pop();
  //                                             },
  //                                             child: const Padding(
  //                                               padding: EdgeInsets.only(
  //                                                 left: 10,
  //                                                 right: 10,
  //                                               ),
  //                                               child: Text(
  //                                                 "No",
  //                                                 style: TextStyle(
  //                                                     color: Colors.red,
  //                                                     fontWeight:
  //                                                         FontWeight.w500,
  //                                                     fontSize: 17),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           VerticalDivider(
  //                                             color:
  //                                                 Colors.grey.withOpacity(0.5),
  //                                             thickness: 1,
  //                                           ),
  //                                           GestureDetector(
  //                                             onTap: () {
  //                                               registerationController
  //                                                   .registerWithEmail();
  //                                             },
  //                                             child: const Padding(
  //                                               padding: EdgeInsets.only(
  //                                                 left: 10,
  //                                                 right: 10,
  //                                               ),
  //                                               child: Text(
  //                                                 "yes",
  //                                                 style: TextStyle(
  //                                                     color: Color.fromRGBO(
  //                                                         72, 96, 181, 1),
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                     fontSize: 17),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     });
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   const SnackBar(
  //                     duration: Duration(milliseconds: 500),
  //                     content: Text('Please fill in all fields.'),
  //                   ),
  //                 );
  //               }
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

import 'package:newbestshop/controllers/login_controller.dart';
import 'package:newbestshop/controllers/registeration_controller.dart';
import 'package:newbestshop/screens/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          const Positioned(
            right: 320,
            top: 10,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: Color.fromARGB(90, 33, 149, 243),
            ),
          ),
          const Positioned(
            right: 250,
            top: -50,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: Color.fromARGB(90, 33, 149, 243),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Back Again So Soon",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4860b5),
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

          // InputTextFieldWidget(loginController.emailController, 'username'),
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              height: 60,
              child: TextFormField(
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
                      Radius.circular(20),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(143, 0, 140, 255),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  errorStyle: const TextStyle(height: 0),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(146, 87, 111, 168),
                  ),

                  // TextStyle(
                  //   color: Color.fromARGB(146, 87, 111, 168),
                  //   fontWeight: FontWeight.w400,
                  //   fontSize: 16,
                  // ),
                  hintText: 'username',
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          // InputTextFieldWidget(
          //   loginController.passwordController,
          //   'password',
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              height: 60,
              child: TextFormField(
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
                      Radius.circular(20),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(143, 0, 140, 255),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  errorStyle: const TextStyle(height: 0),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(146, 87, 111, 168),
                  ),

                  // TextStyle(
                  //   color: Color.fromARGB(146, 87, 111, 168),
                  //   fontWeight: FontWeight.w400,
                  //   fontSize: 16,
                  // ),
                  hintText: 'password',
                ),
              ),
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
              prefs.setString('username', username);
              loginController.loginWithEmail();
              if (_formKey.currentState!.validate()) {
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

class Register extends StatefulWidget {
  const Register({super.key});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  RegisterationController registerationController =
      Get.put(RegisterationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          const Positioned(
            right: 320,
            top: 10,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: Color.fromARGB(90, 33, 149, 243),
            ),
          ),
          const Positioned(
            right: 250,
            top: -50,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: Color.fromARGB(90, 33, 149, 243),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Onboard",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4860b5),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: registerWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget registerWidget() {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // InputTextFieldWidget(
          //     registerationController.nameController, 'username'),

          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              height: 60,
              child: TextFormField(
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
                      Radius.circular(20),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(143, 0, 140, 255),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  errorStyle: const TextStyle(height: 0),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(146, 87, 111, 168),
                  ),

                  // TextStyle(
                  //   color: Color.fromARGB(146, 87, 111, 168),
                  //   fontWeight: FontWeight.w400,
                  //   fontSize: 16,
                  // ),
                  hintText: 'username',
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          // InputTextFieldWidget(
          //     registerationController.passwordController, 'password'),
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              height: 60,
              child: TextFormField(
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
                      Radius.circular(20),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(143, 0, 140, 255),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  errorStyle: const TextStyle(height: 0),
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(146, 87, 111, 168),
                  ),

                  // TextStyle(
                  //   color: Color.fromARGB(146, 87, 111, 168),
                  //   fontWeight: FontWeight.w400,
                  //   fontSize: 16,
                  // ),
                  hintText: 'password',
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),
          SubmitButton(
            title: 'Register',
            onPressed: () async {
              registerationController.registerWithEmail();
              if (_formKey.currentState!.validate()) {
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
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  // fontSize: 16,
                  // fontWeight: FontWeight.w400,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const AuthScreen()),
                  // );
                  Get.off(() => const AuthScreen());
                },
                child: Text(
                  "Sign In",
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    // fontSize: 16,
                    // fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

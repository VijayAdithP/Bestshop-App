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
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(143, 0, 140, 255),
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
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(143, 0, 140, 255),
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
      appBar: AppBar(
        title: Text(
          "Add users",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4860b5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: registerWidget(),
      ),
    );
  }

  Widget registerWidget() {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    int selectedRole = 1;
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Back Again So Soon",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4860b5),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 15,
              ),
              const Row(
                children: [
                  Text(
                    "Username",
                    style: TextStyle(
                      // color: Colors.red,
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
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(143, 0, 140, 255),
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

              // const SizedBox(
              //   height: 10,
              // ),
              const Row(
                children: [
                  Text(
                    "Phone number",
                    style: TextStyle(
                      // color: Colors.red,
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
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(143, 0, 140, 255),
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
                  hintText: 'phone number',
                ),
              ),

              // const SizedBox(
              //   height: 10,
              // ),
              // InputTextFieldWidget(
              //     registerationController.passwordController, 'password'),
              const Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(
                      // color: Colors.red,
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
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(143, 0, 140, 255),
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

              // const SizedBox(
              //   height: 10,
              // ),
              const Row(
                children: [
                  Text(
                    "Role",
                    style: TextStyle(
                      // color: Colors.red,
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
                  border: Border.all(color: Colors.grey[400]!),
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
                  style: TextStyle(
                    fontSize: 17,
                    // color: greyblue,
                  ),
                  isExpanded: true,
                  value: selectedRole,
                  elevation: 1,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedRole = newValue!;
                    });
                  },
                  items: <DropdownMenuItem<int>>[
                    DropdownMenuItem<int>(
                      value: 1,
                      child: Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text(
                        'User',
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Text(
                        'Campus',
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
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
          ),
        ],
      ),
    );
  }
}

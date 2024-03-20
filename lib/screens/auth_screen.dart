import 'package:newbestshop/controllers/login_controller.dart';
import 'package:newbestshop/controllers/registeration_controller.dart';
import 'package:newbestshop/screens/widgets/input_fields.dart';
import 'package:newbestshop/screens/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  LoginController loginController = Get.put(LoginController());

  var isLogin = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Center(
          child: loginWidget(),
        ),
      ),
    );
  }

  Widget loginWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(loginController.emailController, 'username'),
        const SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
          loginController.passwordController,
          'password',
        ),
        const SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () => loginController.loginWithEmail(),
          title: 'Login',
        ),
        TextButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const Register()),
            // );
            Get.off(() => const Register());
          },
          child: const Text(
            "Register",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
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
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Center(
          child: registerWidget(),
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InputTextFieldWidget(
            registerationController.nameController, 'username'),
        const SizedBox(
          height: 20,
        ),
        InputTextFieldWidget(
            registerationController.passwordController, 'password'),
        const SizedBox(
          height: 20,
        ),
        SubmitButton(
          onPressed: () => registerationController.registerWithEmail(),
          title: 'Register',
        ),
        TextButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const AuthScreen()),
            // );
            Get.off(() => const AuthScreen());
          },
          child: const Text("Back to login"),
        ),
      ],
    );
  }
}

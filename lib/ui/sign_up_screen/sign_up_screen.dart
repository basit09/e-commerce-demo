// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce_task/infrastructure/provider/provider_registration.dart';
import 'package:e_commerce_task/ui/home_screen/home_screen.dart';
import 'package:e_commerce_task/ui/login_screen/login_screen.dart';
import 'package:e_commerce_task/ui/widgets/common_auth_buttons.dart';
import 'package:e_commerce_task/ui/widgets/common_snack_bar.dart';
import 'package:e_commerce_task/ui/widgets/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final authProviderRead = ref.read(authProvider);
    final authProviderWatch = ref.watch(authProvider);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height / 2.8,
              child: Image.asset('assets/images/signup.jpeg'),
            ),
            TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Enter your name',
                textInputType: TextInputType.text),
            TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.text),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            CommonAuthButton(onTap: signUpUser, text: "Sign Up"),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    " Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  void signUpUser() async {
    // set is loading to true.
    ref.watch(authProvider).setIsLoading(true);

    // signup user using our auth method
    String response = await ref.read(authProvider).signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);
    // if string return is success, user has been created and navigate to next screen other wise show error.
    if (response == "success") {
      ref.watch(authProvider).setIsLoading(false);

      //navigate to the next screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      ref.watch(authProvider).setIsLoading(false);

      // show error
      showSnackBar(context, response);
    }
  }

}

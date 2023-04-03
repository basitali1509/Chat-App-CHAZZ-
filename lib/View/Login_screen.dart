import 'package:chat_app/Controller/firebase_auth.dart';
import 'package:chat_app/Utilities/Reusable%20Components/background_gradient.dart';
import 'package:chat_app/View/Forgot_password.dart';
import 'package:chat_app/View/Login_with_phone_no.dart';
import 'package:chat_app/View/Signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            BackgroundGradient(color: const [
              Color(0xFF6930C5),
              Colors.blue,
              Colors.black,
            ]),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * .1,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'CHAZZ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Center(
                        child: Text(
                          'Log in to your account',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Email address',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(.8)),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Email';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              cursorColor: Colors.white,
                              controller: passwordController,
                              obscureText: true,
                              enableInteractiveSelection: false,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(.8)),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter Password';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: size.height * .06),
                            Container(
                              height: 44,
                              width: 200,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black54.withOpacity(.3)),
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.withOpacity(.4),
                                    Colors.black,
                                  ],
                                  begin: Alignment.bottomCenter,
                                ),
                              ),
                              child: Center(
                                  child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    logIn(context, emailController.text,
                                        passwordController.text);
                                  }
                                },
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )),
                            ),
                            SizedBox(height: size.height * .02),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()));
                                },
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white,
                                        Colors.white,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.centerRight,
                                      tileMode: TileMode.clamp,
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    "Forgot password?",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'or',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(height: 30),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginWithPhoneNumber()));
                              },
                              child: Container(
                                width: 250,
                                height: 43,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: Colors.white)),
                                child: const Center(
                                    child: Text(
                                  'Login with Phone Number',
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen()));
                                  },
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]))
          ]),
        ));
  }
}

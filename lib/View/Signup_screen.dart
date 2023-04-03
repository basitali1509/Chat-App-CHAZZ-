import 'package:chat_app/Controller/firebase_auth.dart';
import 'package:chat_app/Utilities/Reusable%20Components/background_gradient.dart';
import 'package:chat_app/Utilities/toast.dart';
import 'package:chat_app/View/Login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  UtilsToast utilsToast = UtilsToast();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

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
    return Scaffold(
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
                        'Sign up to create your account',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            cursorColor: Colors.white,
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(.8)),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            prefixIcon: const Icon(Icons.person,color: Colors.white,)
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Enter Name';

                          }
                          else{
                            return null;
                          }
                        },
                      ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: 'Email address',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(.8)),
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
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: passwordController,
                            cursorColor: Colors.white,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(.8)),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Password';
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: size.height * .06),

                          GestureDetector(
                            onTap: (){
                              if(_formKey.currentState!.validate()){
                                createAccount(
                                    context,
                                    nameController.text,
                                    emailController.text,
                                    passwordController.text);
                              }
                            },
                            child: Container(
                              height: 44,
                              width: 200,
                              child: const Center(child: Text('Sign Up', style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20),)),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black54.withOpacity(.3)

                                ),
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                  colors: [

                                    Colors.blue.withOpacity(.5),
                                    Colors.black,
                                  ],
                                  begin: Alignment.bottomCenter,


                                  //end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account?',
                                  style: TextStyle(
                                      color: Colors.white,
                                     ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  },
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ])
                        ]))
                  ]))
        ]));
  }
}

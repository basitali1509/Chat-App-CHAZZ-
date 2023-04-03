import 'package:chat_app/Utilities/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6930C5),
                  Colors.blue,
                  Colors.black,
                ],
                begin: Alignment.topCenter,
              ),
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: Colors.transparent,
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                      alignment: Alignment.bottomRight,
                    ),
                  ),
                ),
              ]),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * .13,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'Change Password',
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
                        child: Column(children: [
                          TextFormField(
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
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            height: 44,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black54.withOpacity(.3)),
                              borderRadius: BorderRadius.circular(40),
                              gradient: LinearGradient(
                                colors: [
                                  //Color(0xFF6930C5),
                                  Colors.blue.withOpacity(.5),
                                  Colors.black,
                                ],
                                begin: Alignment.bottomCenter,

                                //end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                                child: TextButton(
                              onPressed: () {
                                auth
                                    .sendPasswordResetEmail(
                                        email: emailController.text.toString())
                                    .then((value) {
                                  UtilsToast()
                                      .ShowToast('We have sent you an email');
                                }).onError((error, stackTrace) {
                                  UtilsToast().ShowToast(error.toString());
                                });
                              },
                              child: const Text(
                                'Forgot',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )),
                          ),
                        ]))
                  ]))
        ]));
  }
}

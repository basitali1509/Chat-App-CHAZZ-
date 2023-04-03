import 'package:chat_app/Utilities/Reusable%20Components/background_gradient.dart';
import 'package:chat_app/Utilities/toast.dart';
import 'package:chat_app/View/verify_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
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
                      child: Text(
                        'CHAZZ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'Login with phone number',
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
                            cursorColor: Colors.white,
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              helperText:
                                  '+(country code)(space)(phone number)',
                              helperStyle: const TextStyle(
                                  color: Colors.white, fontSize: 11),
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(.9)),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              prefixIcon: const Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Phone number';
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
                                  Colors.blue.withOpacity(.5),
                                  Colors.black,
                                ],
                                begin: Alignment.bottomCenter,

                              ),
                            ),
                            child: Center(
                                child: TextButton(
                              onPressed: () {
                                _auth.verifyPhoneNumber(
                                    phoneNumber: phoneController.text,
                                    verificationCompleted: (_) {},
                                    verificationFailed: (e) {
                                      UtilsToast().ShowToast(e.toString());
                                    },
                                    codeSent:
                                        (String verification, int? token) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VerifyCodeScreen(
                                                    verification: verification,
                                                  )));
                                    },
                                    codeAutoRetrievalTimeout: (e) {
                                      UtilsToast().ShowToast(e.toString());
                                    });
                                phoneController.clear();
                              },
                              child: const Text(
                                'Log In',
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

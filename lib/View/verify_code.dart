import 'package:chat_app/Utilities/Reusable%20Components/background_gradient.dart';
import 'package:chat_app/Utilities/toast.dart';
import 'package:chat_app/View/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verification;

  VerifyCodeScreen({Key? key, required this.verification}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {


  final _formKey = GlobalKey<FormState>();
  TextEditingController verifyController = TextEditingController();
  final auth = FirebaseAuth.instance;
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
                        'CHAAZING',
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
                        'Verify Code',
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
                            controller: verifyController,
                            obscuringCharacter: '*',
                            obscureText: true,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Enter 6 digit code',
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
                          GestureDetector(
                            onTap: ()async{
                              final authToken = PhoneAuthProvider.credential(
                                  verificationId: widget.verification,
                                  smsCode: verifyController.text.toString());
                              try{
                                await auth.signInWithCredential(authToken);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context)=> const HomeScreen()));

                              }
                              catch(e){
                                UtilsToast().ShowToast(e.toString());
                              }

                            },
                            child: Container(
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
                              child:  const Center(
                                  child: Text(
                                    'Forgot',
                                    style:
                                    TextStyle(color: Colors.white, fontSize: 20),
                                  )),
                            ),
                          ),
                        ]))
                  ]))
        ]));


  }
}

import 'package:chat_app/Controller/splash_controller.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashScreenController splashScreenController = SplashScreenController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreenController.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children:  [
          Container(
              height: size.height,
              width: size.width,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      const Color(0xFF050A30).withOpacity(1),
                      const Color(0xFF050A30).withOpacity(1),
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.center
                ),
              ),

              child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: Container(
                      height:100,
                      width: 100,
                      child:  Image(
                          color: Colors.white,
                          image: AssetImage('images/chat_icon_100.png')
                      ),
                    ),
                  ),
                  //SizedBox(width: 10,),
                  const Center(
                    child: Text(
                      'CHAZZ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}


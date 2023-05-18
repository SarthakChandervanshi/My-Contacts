import 'package:contact_list/constants.dart';
import 'package:contact_list/controller.dart';
import 'package:contact_list/decider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants().appBarColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/app_logo.png",height: 100,width: 100,fit: BoxFit.fitWidth,),
            SizedBox(height: 16,),
            Text("Welcome to your contacts",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w500,color: Colors.white),textAlign: TextAlign.center,),
            SizedBox(height: 32,),
            GestureDetector(
              onTap: () async{
                User? user = await homeController.signInWithGoogle(context: context);
                debugPrint("USER_IS: ${user?.displayName}");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.black.withOpacity(0.1))
                ),
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/google.png",height: 32,width: 32,fit: BoxFit.fitWidth,),
                    SizedBox(width: 16,),
                    Text("Sign in with google",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

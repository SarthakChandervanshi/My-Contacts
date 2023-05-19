import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contact_list/controller.dart';
import 'package:contact_list/entry_screens/login_screen.dart';
import 'package:contact_list/widgets/contact_list_app_bar.dart';
import 'package:contact_list/widgets/contact_list_body.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'entry_screens/home.dart';
import 'model/contact_model.dart';

class Decider extends StatefulWidget {
  Decider({Key? key}) : super(key: key);

  @override
  State<Decider> createState() => _DeciderState();
}

class _DeciderState extends State<Decider> {

  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    homeController.collectionReference = homeController.firestore.collection('contacts');
    checkConnectivity();
  }

  void checkConnectivity() async {
    Connectivity connectivity = Connectivity();
    var connectivityResult = await connectivity.checkConnectivity();// User defined class
    debugPrint("CONNECTIVITY_RESULT: ${connectivityResult.toString()}");
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    checkIfSignedIn();
    } else {
    homeController.state.value = 3;
    }
  }

  Future<int> checkIfSignedIn() async {
    if(homeController.auth.currentUser != null){
      homeController.state.value = 2;
      debugPrint("SIGNED_IN");
      await homeController.getAllContacts();
    }else{
      homeController.state.value = 1;
      debugPrint("NOT_SIGNED_IN");
    }
    return homeController.state.value;
  }

  @override
  void dispose() {
    Get.delete<HomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      if(homeController.state.value == 3){
        return  Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/no_internet.jpg",height: Get.width / 2,width: Get.width / 2,fit: BoxFit.fitHeight,),
                SizedBox(height: 16,),
                Text("No internet",style: TextStyle(fontSize: 32,fontWeight: FontWeight.w600),)
              ],
            ),
          )
        );
      }
      else{
        if(homeController.state.value == -1){
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }
        else if(homeController.state.value == 1){
          return LoginScreen();
        }
        else{
          return Home();
        }
      }
     }
    );
  }
}


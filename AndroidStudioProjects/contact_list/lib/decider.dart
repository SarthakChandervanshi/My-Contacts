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
    checkIfSignedIn();
  }

  Future<int> checkIfSignedIn() async {
    if(homeController.auth.currentUser != null){
      homeController.state.value = 2;
      debugPrint("SIGNED_IN");
      homeController.collectionReference = homeController.firestore.collection('contacts');
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
    );
  }
}


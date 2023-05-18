import 'package:cached_network_image/cached_network_image.dart';
import 'package:contact_list/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactsDrawer extends StatelessWidget {
  ContactsDrawer({Key? key}) : super(key: key);

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        elevation: 1,
        width: 200,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24,horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      height: 45,
                      width: 45,
                      imageUrl: homeController.auth.currentUser?.photoURL ?? "",
                      errorWidget: (context,_,__) => Image.asset("assets/images/profile/male/profile_1.png"),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Flexible(child: Text("Hi, ${homeController.auth.currentUser?.displayName}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),))
                ],
              ),
              Spacer(),
              InkWell(
                customBorder: CircleBorder(),
                onTap: (){
                  homeController.signOutUser();
                },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(Icons.logout,size: 32,color: Colors.black,),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

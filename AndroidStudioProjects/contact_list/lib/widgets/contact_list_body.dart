import 'package:contact_list/controller.dart';
import 'package:contact_list/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import 'contact_tile.dart';

class ContactListBody extends StatelessWidget {
  ContactListBody({Key? key}) : super(key: key);

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx((){
        if(homeController.gettingContacts.value == true){
          return Center(
            child: CircularProgressIndicator(
              color: Constants().appBarColor,
            ),
          );
        }
        else{
          if(homeController.contacts?.isEmpty ?? true){
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/contacts_empty.jpg",height: Get.width / 2, width: Get.width / 2,),
                  SizedBox(height: 16,),
                  Text("Contact list is empty",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),)
                ],
              ),
            );
          }
          else{
            return ListView.separated(
              addAutomaticKeepAlives: false,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 16,left: 16,right: 16),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context,index){
                return ContactTile(index: index,contact: homeController.contacts?[index] ?? ContactModel(uid: "",firstName: "", lastName: "", gender: "",mobileNumber: ""),);
              },
              separatorBuilder: (context,index){
                return SizedBox(height: 16,);
              },
              itemCount: homeController.contacts?.length ?? 0,
            );
          }
        }
      }),
    );
  }
}

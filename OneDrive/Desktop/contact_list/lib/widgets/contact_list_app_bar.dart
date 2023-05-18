import 'package:contact_list/constants.dart';
import 'package:contact_list/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'flexible_widget.dart';

class ContactListAppBar extends StatelessWidget {
  const ContactListAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 390,
      title: const Text("My contacts",style: TextStyle(fontSize: 24 , fontWeight: FontWeight.w600,color: Colors.white),),
      backgroundColor: Constants().appBarColor,
      elevation: 1,
      floating: false,
      pinned: true,
      leadingWidth: 56,
      collapsedHeight: 56,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: FlexibleSpaceBar(
          titlePadding: EdgeInsets.zero,
          background: FlexibleWidget(),
        ),
      ),
      bottom: BottomPart()
    );
  }
}

class BottomPart extends StatelessWidget with PreferredSizeWidget {
  BottomPart({Key? key}) : super(key: key);
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        width: Get.width,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Your contacts list",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
              InkWell(
                onTap: (){
                  if((homeController.contacts?.length ?? 0) > 0){
                    homeController.deleteAllContacts();
                  }
                },
                child: Icon(Icons.delete,color: Colors.black,),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(Get.width,50);
}


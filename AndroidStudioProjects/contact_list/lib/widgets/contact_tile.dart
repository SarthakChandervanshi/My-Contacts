import 'package:contact_list/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../constants.dart';
import '../model/contact_model.dart';

class ContactTile extends StatefulWidget{
  ContactTile({Key? key, required this.index, required this.contact}) : super(key: key);
  final int index;
  final ContactModel contact;

  @override
  State<ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<ContactTile> with AutomaticKeepAliveClientMixin {

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection dismissDirection){
        homeController.removeContact(context: context, contact: widget.contact);
      },
      child: Card(
        child: ListTile(
          title: Text("${widget.contact.firstName.capitalize} ${widget.contact.lastName.capitalize}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
          leading: widget.contact.gender == "male" ? Image.asset(Constants().maleImageAssetPath) : Image.asset(Constants().femaleImageAssetPath),
          onTap: (){},
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
          isThreeLine: false,
          tileColor: Constants().tileColor,
          subtitle: Text(widget.contact.mobileNumber,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black.withOpacity(0.7)),),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

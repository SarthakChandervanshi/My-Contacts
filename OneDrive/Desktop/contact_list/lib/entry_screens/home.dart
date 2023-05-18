import 'package:contact_list/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/contact_list_app_bar.dart';
import '../widgets/contact_list_body.dart';
import '../widgets/drawer.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ContactsDrawer(),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          const ContactListAppBar(),
          ContactListBody()
        ],
      ),
    );
  }
}

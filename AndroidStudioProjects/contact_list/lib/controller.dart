import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math' as math;
import 'model/contact_model.dart';

class HomeController extends GetxController{
  RxList<ContactModel>? contacts = <ContactModel>[].obs;
  List<Color> colors = [
    Colors.blueAccent,
    Colors.blue,
    Colors.redAccent,
    Colors.red,
    Colors.purpleAccent,
    Colors.purple,
    Colors.greenAccent,
    Colors.green,
    Colors.orangeAccent,
    Colors.orange,
    Colors.yellowAccent,
    Colors.yellow
  ];

  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference collectionReference;
  // 0 for not checked state yet , 1 for not signed in and 2 for signed in
  var state = 0.obs;

  var gettingContacts = false.obs;

  Color getRandomColor(){
    int randomIndex = math.Random().nextInt(colors.length);
    return colors[randomIndex];
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      debugPrint("GOOGLE_SIGN_IN_ACCOUNT_NOT_NULL");
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;
        if(user != null){
          debugPrint("USER_SIGNED_IN");
          state.value = 2;
        }
        else{
          debugPrint("USER_NOT_SIGNED_IN");
          state.value = 1;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          debugPrint("ACCOUNT_ALREADY_EXISTS");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("This account already exists",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)));
        }
        else if (e.code == 'invalid-credential') {
          debugPrint("INVALID_CREDENTIALS");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid credentials",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)));
        }
      } catch (e) {
        debugPrint("FIREBASE_EXCEPTION");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Firebase exception",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)));
      }
    }

    return user;
  }
  
  Future<void> signOutUser() async{
    await auth.signOut().then((value) => state.value = 1);
  }

  Future<bool> addContact({required BuildContext context,required String uid, required String firstName, required String lastName , required String mobile,required String gender }) async {
    bool uploadedSuccessfully = false;
    DocumentReference documentReferencer = collectionReference.doc(uid);
    Map<String, dynamic> data = <String, dynamic>{
      "first_name": firstName,
      "last_name": lastName,
      "mobile" : mobile,
      "gender" : gender
    };

    await documentReferencer.set(data).whenComplete(() {
      uploadedSuccessfully = true;
      getAllContacts();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Contact added successfully",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)));
    }).catchError((e) {
      uploadedSuccessfully = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)));
    });
    return uploadedSuccessfully;
  }

  Future<bool> removeContact({required BuildContext context, required ContactModel contact}) async {
    bool deletedSuccessfully = false;
    DocumentReference documentReferencer = collectionReference.doc(contact.uid);

    await documentReferencer.delete().whenComplete((){
      deletedSuccessfully = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Contact deleted successfully",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)));
      getAllContacts();
    }).catchError((e){
      deletedSuccessfully = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)));
    });

    return deletedSuccessfully;
  }

  Future<void> getAllContacts() async {
    gettingContacts.value = true;
    QuerySnapshot querySnapshot = await collectionReference.get();
    contacts?.value = querySnapshot.docs.map((contact) => ContactModel(uid: contact.id,firstName: contact['first_name'], lastName: contact['last_name'], gender: contact['gender'], mobileNumber: contact['mobile'])).toList();
    debugPrint("CONTACTS_LENGTH: ${contacts?.length}");
    gettingContacts.value = false;
  }

  Future<void> deleteAllContacts() async {
    gettingContacts.value = true;
    QuerySnapshot querySnapshot = await collectionReference.get();
    querySnapshot.docs.map((contact) async => await contact.reference.delete()).toList();
    getAllContacts();
    gettingContacts.value = false;
  }
}
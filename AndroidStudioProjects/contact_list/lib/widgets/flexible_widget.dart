import 'package:contact_list/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class FlexibleWidget extends StatefulWidget {
  FlexibleWidget({Key? key}) : super(key: key);

  @override
  State<FlexibleWidget> createState() => _FlexibleWidgetState();
}

class _FlexibleWidgetState extends State<FlexibleWidget> {
  final TextEditingController firstName = TextEditingController();

  final TextEditingController lastName = TextEditingController();

  final TextEditingController mobile = TextEditingController();

  String gender = "male";

  HomeController homeController = Get.find();

  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Add a new contact",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
            SizedBox(height: 16,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: CommonTextField(hintText: "First name",textEditingController: firstName, maxLength: 100,inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))],),
                ),
                SizedBox(width: 16,),
                Flexible(
                  flex: 1,
                  child: CommonTextField(hintText: "Last Name",textEditingController: lastName,maxLength: 100,inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))]),
                )
              ],
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: CommonTextField(hintText: "Mobile number",textEditingController: mobile,maxLength: 10,inputFormatters: [FilteringTextInputFormatter.digitsOnly],textInputType: TextInputType.phone,),
                ),
                SizedBox(width: 16,),
                Flexible(
                  flex: 1,
                  child: FittedBox(
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Male",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                            Radio(
                              activeColor: Colors.white,
                              groupValue: gender,
                              value: "male",
                              onChanged: (String? value){
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Female",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                            Radio(
                              activeColor: Colors.white,
                              groupValue: gender,
                              value: "female",
                              onChanged: (String? value){
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 16,),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    alignment: Alignment.center
                ),
                onPressed: () async {
                  if(firstName.text.trim().isEmpty || lastName.text.trim().isEmpty || mobile.text.trim().isEmpty || mobile.text.length < 10){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are mandatory",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)));
                  }
                  else{
                   bool uploadedSuccessfully = await homeController.addContact(context: context, uid: uuid.v1().toString(),firstName: firstName.text, lastName: lastName.text, mobile: mobile.text, gender: gender);

                   if(uploadedSuccessfully == true){
                     firstName.clear();
                     lastName.clear();
                     mobile.clear();
                     gender = "male";
                     FocusManager.instance.primaryFocus?.unfocus();
                   }
                  }
                },
                child: Text("Submit",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black),),
              ),
            ),
            SizedBox(height: 55,)
          ],
        )
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  CommonTextField({Key? key,required this.hintText, required this.textEditingController,required this.maxLength,this.inputFormatters,this.textInputType}) : super(key: key);
  String hintText;
  TextEditingController textEditingController;
  int maxLength;
  List<TextInputFormatter>? inputFormatters;
  TextInputType? textInputType;

  OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.white,width: 1),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: TextStyle(fontSize: 16,color: Colors.black),
      keyboardType: textInputType ?? TextInputType.name,
      decoration: InputDecoration(
        border: border,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.6)),
        focusedErrorBorder: border,
        disabledBorder: border,
        focusedBorder: border,
        enabledBorder: border,
        errorBorder: border,
        fillColor: Colors.white,
        filled: true,
        counterText: ""
      ),
      maxLength: maxLength,
      inputFormatters: inputFormatters,
    );
  }
}


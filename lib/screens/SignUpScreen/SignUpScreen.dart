

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/Navigation/BottomNavigation.dart';
import 'package:qfoods/constants/CustomSnackBar.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';

import 'package:http/http.dart' as http;
import 'package:qfoods/model/VerifyOTPModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
   final String phone_number;
 
  const SignUpScreen({super.key, required this.phone_number});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  final formGlobalKey = GlobalKey < FormState > ();
   bool loading = false;
   TextEditingController name = TextEditingController();
   TextEditingController email = TextEditingController();
   
@override
 void dispose(){
  name.dispose();
  email.dispose();
  super.dispose();
 }

   
Future<void> SignUpHandler(BuildContext context) async{


     FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }

  loading = true;
  setState(() { });
  try{
    dynamic data = {
      "phone_number": widget?.phone_number,
      "name": name!.value.text,
      "email": email!.value!.text
    };

   var response = await http.post(Uri.parse(ApiServices.signUp), body: data);
  

   if(response.statusCode == 200){
   final responseBody = jsonDecode(response.body);
   print(responseBody);
   
final prefs = await SharedPreferences.getInstance();
Detail detail = Detail.fromJson(responseBody);
  int Userid = detail?.userId ?? 0;
     if(Userid != 0){
    await prefs.setBool('isLogged', true);
await prefs.setInt('qfoods_user_id', detail?.userId ?? 0);
  loading = false;
  setState(() { });
  
 Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavigation()
      ));
 
   }else{
      loading = false;
  setState(() { });
  
      CustomSnackBar().ErrorMsgSnackBar("Something went wrong");
 
   }
  
   }
   else if(response.statusCode == 401){
      loading = false;
  setState(() { });
  
    CustomSnackBar().ErrorMsgSnackBar("Already User Exist");
   }
   else{
      loading = false;
  setState(() { });
  
    CustomSnackBar().ErrorMsgSnackBar("Something went wrong");
   }
   

  }catch(e){
       loading = false;
  setState(() { });
  CustomSnackBar().ErrorSnackBar();
  }
 }





  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColors.whitecolor,
        bottomSheet:  Container(
          height: height * 0.09,
           margin: const EdgeInsets.only(bottom: 10),
                       alignment: Alignment.center,

          child:
          
           loading ? Container(
                       alignment: Alignment.center,
                           decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                                        height: height * 0.065,
          width: width * 0.90,
                           padding: EdgeInsets.all(12),
                        
                     child: SizedBox(
                            height: ScreenUtil().setHeight(20),
                            width: ScreenUtil().setWidth(20),
                             child: CircularProgressIndicator(
                              color: AppColors.whitecolor,
                              strokeWidth: 1,
                              
                             )
                      ),
                   ) :
           InkWell(
                      onTap: (){
                        if (!formGlobalKey.currentState!.validate()) {
                        return;
                      }
                      SignUpHandler(context);
                      },
                       child: Container(
                       height: height * 0.065,
          alignment: Alignment.center,
                       decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                       width: width * 0.90,
                       padding: EdgeInsets.all(12),
                       
                       child:
                        Text("Sign Up", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.normal),),
                       ),
                     ),
        ),
        body: GestureDetector(
          onTap: (){
                      FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }

          },
          child: SafeArea(
            child: Stack(
              children: [
                  Align(
                  alignment: Alignment.topCenter,
                  child: Container( 
                    alignment: Alignment.topLeft,
                    height: height * 0.13,
                    width: width,
                    color: AppColors.primaryColor,
                    child:  Padding(
                     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                     child: Image.asset("assets/images/logo.png",
                      width: width * 0.38,
                     ),
                   ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                 child: Container(
                   height: height * 0.87,
                      width: width,
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    
                      color: AppColors.whitecolor,
                      ),
                      child: Form(
                      key: formGlobalKey,
                      child: SingleChildScrollView(
                        
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(22)), ),
                            Text("Create an account", style: TextStyle(fontWeight: FontWeight.w200,color: AppColors.lightgreycolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)), )
                          ,
                          SizedBox(height: height * 0.02,),
                          Container(
                            width: width * 0.90,
                                 decoration: boxdecoration,
                                 child: TextFormField(
                                  controller: name,
                                    validator: ((value){
                            if(value == "") return "First name is required";
                            return null;
                          }),
                                               style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                               cursorColor: AppColors.greycolor,
                                              decoration:  InputDecoration(
                                      labelText: 'First name',
                                        hintText: 'First name',
                                  
                                      floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                       focusedBorder: focusedborder,
                                       focusedErrorBorder: focusedborder,
                                       enabledBorder: enableborder,
                                        errorBorder: errorborder,
                                      labelStyle: labelstyle
                                              // TODO: add errorHint
                                              ),
                                            ),
                               ),
                        
                          SizedBox(height: height * 0.02,),
                          Container(
                            width: width * 0.90,
                                 decoration: boxdecoration,
                                 child: TextFormField(
                                    validator: ((value){
                            if(value == "") return "Email is required";
                             if(!isValidEmail(value ?? '')) return "Invalid Email";
                           return null;
                          }),
                          controller: email,
                                               style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                               cursorColor: AppColors.greycolor,
                                             keyboardType: TextInputType.emailAddress,
                                               decoration:  InputDecoration(
                                      labelText: 'Email',
                                        hintText: 'Email',
                                    
                                      floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                       focusedBorder: focusedborder,
                                       focusedErrorBorder: focusedborder,
                                       enabledBorder: enableborder,
                                         errorBorder: errorborder,
                                     labelStyle: labelstyle
                                              // TODO: add errorHint
                                              ),
                                            ),
                               ),
                        
                          SizedBox(height: height * 0.03,),
                    
                           
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  BoxDecoration boxdecoration =  BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(13),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 20,
                                            color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                          ),
                                        ],
                                      );
  
  OutlineInputBorder focusedborder = OutlineInputBorder(
                                     borderRadius: BorderRadius.all(Radius.circular(4)),
                                     borderSide: BorderSide(width: 1,color: AppColors.primaryColor),
                                   );
  OutlineInputBorder enableborder = OutlineInputBorder(
                                     borderRadius: BorderRadius.all(Radius.circular(4)),
                                     borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                   );


OutlineInputBorder errorborder = OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.red,
                          ));
  TextStyle labelstyle = TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor);                            

 bool isValidEmail(String val) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(val);
  }
}
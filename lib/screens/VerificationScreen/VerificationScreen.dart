

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:qfoods/Navigation/BottomNavigation.dart';
import 'package:qfoods/constants/CustomSnackBar.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';

import 'package:http/http.dart' as http;
import 'package:qfoods/model/VerifyOTPModel.dart';
import 'package:qfoods/screens/SignUpScreen/SignUpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationScreen extends StatefulWidget {
  final String phone_number;
  const VerificationScreen({super.key, required this.phone_number});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {

 bool loading = false;
 String otp = "";

 
Future<void> VerifyOTPhandler(BuildContext context) async{


     FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }

if(otp?.length != 6) return CustomSnackBar().ErrorMsgSnackBar("Please fill the otp field");

  loading = true;
  setState(() { });
  try{
    dynamic data = {
      "phone_number": widget?.phone_number,
      "otp": otp
    };

   var response = await http.post(Uri.parse(ApiServices.verifyOtp), body: data);
    loading = false;
  setState(() { });
  

   if(response.statusCode == 200){
   final responseBody = jsonDecode(response.body);
   
final prefs = await SharedPreferences.getInstance();

   VerifyOTPModel verify  = VerifyOTPModel.fromJson(responseBody);
   if(verify.isNewUser != null){
     int Userid = verify?.detail?.userId ?? 0;
     print(responseBody);
     if(verify?.isNewUser ?? false){
Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SignUpScreen(phone_number: widget!.phone_number)
      ));
   
      
     }else{
      
   if(Userid != 0){
    await prefs.setBool('isLogged', true);
await prefs.setInt('qfoods_user_id', verify?.detail?.userId ?? 0);
 Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BottomNavigation()
      ));
 
   }else{
      CustomSnackBar().ErrorMsgSnackBar("Something went wrong");
 
   }
     }
   }else{
   CustomSnackBar().ErrorMsgSnackBar("Something went wrong");
    
   }



  
   }
   else if(response.statusCode == 401){
    CustomSnackBar().ErrorMsgSnackBar("Invalid OTP");
   }
   else{
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
                    child: SingleChildScrollView(
                      
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enter OTP", style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(22)), ),
                        //   Text("Enter your phone number to proceed", style: TextStyle(fontWeight: FontWeight.w200,color: AppColors.lightgreycolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)), )
                        // ,
                        SizedBox(height: height * 0.02,),
                        Theme(
                         data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                            cursorColor: AppColors.primaryColor
                  ),
                  ),         
                            child: OTPTextField(
                          length: 6,
                          width: width * 0.90,
                          fieldWidth: width * 0.10,
                          
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: AppColors.blackcolor
                          ),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.box,
                          otpFieldStyle: OtpFieldStyle(
                            focusBorderColor: AppColors.primaryColor,
                            enabledBorderColor: AppColors.lightgreycolor.withOpacity(0.5)),
                          onCompleted: (pin) {
                            print("Completed: " + pin);
                            otp = pin;
                            setState(() {});
                          },
                        ),
                        ),
                        SizedBox(height: height * 0.03,),
                          
                           loading ? Container(
                       alignment: Alignment.center,
                           decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
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
                        VerifyOTPhandler(context);
                        },
                         child: Container(
                         alignment: Alignment.center,
                         decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                         width: width * 0.90,
                         padding: EdgeInsets.all(12),
                         
                         child:
                          Text("Verify", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.normal),),
                         ),
                       )
                        ],
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
}
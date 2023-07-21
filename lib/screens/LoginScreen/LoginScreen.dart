

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/CustomSnackBar.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/screens/VerificationScreen/VerificationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  TextEditingController phoneNumberController = TextEditingController();

  final formGlobalKey = GlobalKey < FormState > ();
 bool loading = false;


@override
 void dispose(){
  phoneNumberController.dispose();
  super.dispose();
 }



Future<void> LoginHandler(BuildContext context) async{

     FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }

  loading = true;
  setState(() { });
  try{
    dynamic data = {
      "phone_number": phoneNumberController?.value?.text,
    };
print(ApiServices.login);
   var response = await http.post(Uri.parse(ApiServices.login), body: data);
    loading = false;
  setState(() { });
   if(response.statusCode == 200){
   final responseBody = response.body;

   if(responseBody == "otp_sent"){
 Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => VerificationScreen(phone_number: phoneNumberController!.value!.text,)
      ));
   }else{
   CustomSnackBar().ErrorMsgSnackBar("Something went wrong");
 
   }


  
   }else{
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
                    child:  Form(
                      key: formGlobalKey,
                      child: SingleChildScrollView(
                        
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Welcome Back", style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(22)), ),
                            Text("Enter your phone number to proceed", style: TextStyle(fontWeight: FontWeight.w200,color: AppColors.lightgreycolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)), )
                          ,
                          SizedBox(height: height * 0.02,),
                          Container(
                            width: width * 0.90,
                                 decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(13),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: Offset(0, 4),
                                                blurRadius: 20,
                                                color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                              ),
                                            ],
                                          ),
                                 child: TextFormField(
                                  validator: ((value){
                            if(value == "") return "Phone number is required";
                            if((value?.length ?? 0) != 10) return "Invalid Phone number";
                            return null;
                          }),
                                
                                controller: phoneNumberController,
                                          
                                               style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                               cursorColor: AppColors.greycolor,
                                             keyboardType: TextInputType.number,
                                               decoration:  InputDecoration(
                                      labelText: 'Phone Number',
                                        hintText: 'Phone Number',
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
                           if (!formGlobalKey.currentState!.validate()) {
                          return;
                        }
                        LoginHandler(context);
                          },
                           child: Container(
                           alignment: Alignment.center,
                           decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                           width: width * 0.90,
                           padding: EdgeInsets.all(12),
                           
                           child:
                            Text("Continue", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.normal),),
                           ),
                         )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
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

}
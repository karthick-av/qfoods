
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/screens/LoginScreen/LoginScreen.dart';
import 'package:qfoods/screens/MyOrdersScreen/MyGroceryOrdersScreen.dart';
import 'package:qfoods/screens/MyOrdersScreen/MyOrdersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  @override
  Widget build(BuildContext context) {
     Size size = MediaQuery.of(context).size;
   
   double width = size.width;

LogoutDialog(BuildContext context){

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("No",  style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w500,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15))),
    onPressed:  () {
     Navigator.of(context, rootNavigator: true).pop(context);
    },
  );
  Widget continueButton = TextButton(
    
    child: Text("Yes", style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w500,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),),
    onPressed:  () async{
 final prefs = await SharedPreferences.getInstance();
                     prefs.remove("isLogged");
                     prefs.remove("qfoods_user_id");
       Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const LoginScreen();
                              },
                            ),
                            (_) => false,
                          );
                    
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Logout"),
    content: Text("Are you sure to logout?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
                Padding(
                     padding: const EdgeInsets.symmetric(vertical: 8),
                     child: Row(
                       children: [
                          Text("My Account", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.w500),)
                       ],
                     ),
                   ),
                     Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            height: 1,
                            color: Color(0XFFe9e9eb),
                           ),
              SingleChildScrollView
              (child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: width * 0.95,
                  decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(10),
                           boxShadow: [
                             BoxShadow(
                               offset: Offset(0, 4),
                               blurRadius: 20,
                               color: const Color(0xFFB0CCE1).withOpacity(0.29),
                             ),
                           ],
                  ),
                  child: Theme(
                     data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                     child: ExpansionTile(
                        tilePadding: EdgeInsets.all(0),
                         collapsedTextColor: AppColors.blackcolor,
                         collapsedIconColor: AppColors.blackcolor,
                         textColor: AppColors.blackcolor,
                         iconColor: AppColors.blackcolor,
                     
                         initiallyExpanded: false,
                           title: Text(
                          "My Orders",maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                           ),
                       children: [
      
                        InkWell(
                          onTap: (){
                              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => 
               MyOrdersScreen()),
              );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0XFFe9e9eb),))
                            ),
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            width: width * 0.95,
                            child: Text("Orders", style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14.0))),
                          ),
                        ),
                         InkWell(
                          onTap: (){
 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => 
               MyGroceryOrdersScreen()),
              );

                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0XFFe9e9eb),))
                            ),
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            width: width * 0.95,
                            child: Text("Grocery Orders", style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14.0))),
                          ),
                        )
                       ],
                    ),
                  ),
                ),

                   SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    LogoutDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    width: width * 0.95,
                    decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(10),
                             boxShadow: [
                               BoxShadow(
                                 offset: Offset(0, 4),
                                 blurRadius: 20,
                                 color: const Color(0xFFB0CCE1).withOpacity(0.29),
                               ),
                             ],
                    ),
                    child:  Text(
                            "Logout",maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                             ),
                  ),
                )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
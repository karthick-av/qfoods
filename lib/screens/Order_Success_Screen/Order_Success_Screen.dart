import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:qfoods/Navigation/BottomNavigation.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
 void initState(){
  Future.delayed(Duration(seconds: 4), () {
  Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => 
              BottomNavigation()),
            );

});
   super.initState();
   }

   void dispose(){
    super.dispose();
   }


  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:  Center(
        child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
         'assets/images/success.json',
         repeat: false,
         height: ScreenUtil().setHeight(170),
         fit: BoxFit.cover,
         alignment: Alignment.center
         ),
         FadeInUp(
          delay: Duration(milliseconds: 800),
          child: Text("Order Recieved !!", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold, color: AppColors.pricecolor),))
        , SizedBox(height: 10,),
         FadeInUp(
          delay: Duration(milliseconds: 1100),
          
          child: Text("Your Order will be delivered soon !!", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold, color: AppColors.blackcolor),))
           
          ],
        ),
      ),
    );
  }
}
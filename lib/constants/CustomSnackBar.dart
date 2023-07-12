import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qfoods/constants/colors.dart';

class CustomSnackBar{
 void ErrorMsgSnackBar(String msg){
    Get.snackbar("", 
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.blackcolor,
    colorText: AppColors.whitecolor,
    titleText: SizedBox(height: 0,),
    margin:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
    maxWidth: ScreenUtil().setWidth(330)
    );
  }

  void successMsgSnackbar(String msg){
    Get.snackbar("", 
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: AppColors.whitecolor,
    titleText: SizedBox(height: 0,),
    margin:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
    maxWidth: ScreenUtil().setWidth(330)
    );
 
  }

  void MaximumQuantitySnackBar(){
    print("object");
    Get.snackbar("", 
    "Sorry you can't  add more  of this item",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.blackcolor,
    colorText: AppColors.whitecolor,
    titleText: SizedBox(height: 0,),
    margin:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
    maxWidth: ScreenUtil().setWidth(330)
    );
  }

  void ErrorSnackBar(){
    print("object");
    Get.snackbar("", 
    "Please..Try Again Later !!",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.blackcolor,
    colorText: AppColors.whitecolor,
    titleText: SizedBox(height: 0,),
    margin:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
    maxWidth: ScreenUtil().setWidth(330)
    );
  }

}
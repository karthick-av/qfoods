import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

  Widget RestaurantLoadingCard(BuildContext context,int len){
         double itemheight = ScreenUtil().setHeight(100);

    double itemWidth = MediaQuery.of(context).size.width * 0.90;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          for(int i = 0; i < len; i ++)
 Shimmer.fromColors(child: Container(
                  height: itemheight,
                  width: itemWidth,
                  margin: const EdgeInsets.only(top: 10),
                 decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                           
                          ),
              ), 
                 baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
                )
        ],
      ),
    );
  }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:shimmer/shimmer.dart';


Widget ShimmerContainer(double height, double width, double radius){
  return Shimmer.fromColors(child: Container(
                  height: height,
                  width: width,
                 decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(radius),
                           
                          ),
              ), 
                 baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
                );
}
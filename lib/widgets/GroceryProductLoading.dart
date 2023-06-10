import 'package:flutter/material.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:shimmer/shimmer.dart';
class GroceryProductLoading extends StatelessWidget {
  const GroceryProductLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
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
      ) 
    
    ,
      baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
               );
  }
}
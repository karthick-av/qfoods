import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/DishesHomeTagsModel.dart';

class DishesHomeTagsCard extends StatelessWidget {
  final Items items;
  const DishesHomeTagsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    double itemheight = ScreenUtil().setHeight(170);

double itemWidth = ScreenUtil().setWidth(140);

    return Container(
          height: itemheight * 0.94,
        margin: const EdgeInsets.only(left: 10.0),
        width: itemWidth,
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

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    ClipRRect(
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      child:  Container(
                        height: itemheight/2.5, width: itemWidth, 
                        child: Image.network(items.image!.toString() ?? "", fit: BoxFit.cover,
                        height: double.infinity, width: double.infinity,
                        )),
                    ),
                     SizedBox(height: 10.0,),
                     Padding(padding: EdgeInsets.only(left: 5.0),
                     child: Column(
                      children: [
                        
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                         Container(
                          width: itemWidth/1.6,
                          child:   Text(items.name!.toString() ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0)),),
              
                         ),
                       Container(
                        margin: EdgeInsets.only(right: 5.0),
                        child:   Row(
                          children: [
                               Icon(Icons.stars, color: AppColors.primaryColor,size: ScreenUtil().setSp(13.0),),
                             SizedBox(width: 2.0,),
                               Text("4.7", style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(11.0)),)
                          ],
                         ),
                       )
                        ],
                     
                       ),
                      Container(
                        margin: EdgeInsets.only(left: 4.0),
                        child: Column(
                          children: [
                             Align(
                        alignment: Alignment.topLeft,
                        child:       Text(items.shortDescription!.toString() ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.greycolor, fontSize: ScreenUtil().setSp(11.0)))
                 ,
                       ),
                         Align(
                        alignment: Alignment.topLeft,
                        child:       Text("Rs ${items.price!.toString() ?? ""}", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(11.0)))
                 ,
                       ),
                         Align(
                        alignment: Alignment.topLeft,
                        child:       Text(items.restaurantName!.toString() ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.greycolor, fontSize: ScreenUtil().setSp(11.0)))
                 ,
                       ),
                          ],
                        ),
                      )
                      ],
                     ),
                     )
                      ],
                  ),
       );
  }
}
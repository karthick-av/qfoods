import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryHomeProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryHomeTagsModel.dart';
import 'package:qfoods/widgets/GroceryTagCard.dart';

class groceryproductsListWidget extends StatefulWidget {
 
  groceryproductsListWidget({Key? key}) : super(key: key);
  
  @override
  State<groceryproductsListWidget> createState() => _groceryproductsListWidgetState();
}

class _groceryproductsListWidgetState extends State<groceryproductsListWidget> {
  @override
  void initState() {
   
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     if(Provider.of<GroceryHomeProvider>(context, listen: false)?.homeTags?.length == 0){
       Provider.of<GroceryHomeProvider>(context, listen: false).getHomeTags();
     }
    });
    super.initState();
   
   
  }
  @override
  Widget build(BuildContext context) {
    
double itemheight = ScreenUtil().setHeight(185);

double itemWidth = ScreenUtil().setWidth(100);
 final homeProvider =  Provider.of<GroceryHomeProvider>(context, listen: true);
      return  ListView.builder(
      shrinkWrap: true,
      itemCount: homeProvider.homeTags?.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
      return Padding(padding:  const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text(homeProvider.homeTags?[index]?.tagName.toString() ?? '',style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(15.0), fontWeight: FontWeight.bold),),
            ),

     
       new Container(
      height: itemheight,
      child: new ListView.builder(
        
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: homeProvider.homeTags?[index]?.products?.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      
      itemBuilder: (context, ind) {
        return  GroceryTagCard(products: homeProvider.homeTags[index].products![ind]);
      },
      
    )
    ),
    
        ]
      )
      );
    }));
  }
}
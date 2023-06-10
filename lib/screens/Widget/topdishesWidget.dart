import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/DishesHomeTagsModel.dart';
import 'package:qfoods/widgets/DishesHomeTagCard.dart';

class topdishesWidget extends StatefulWidget {
   final List<DishesHomeTagsModel> dishesHomeTags;
 
  const topdishesWidget({super.key, required this.dishesHomeTags});

  @override
  State<topdishesWidget> createState() => _topdishesWidgetState();
}

class _topdishesWidgetState extends State<topdishesWidget> {
  String img = "https://res.cloudinary.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_208,h_208,c_fit/mdc5yxrav6u7ka5ddwoe";
  @override
  Widget build(BuildContext context) {
    
double itemheight = ScreenUtil().setHeight(170);

double itemWidth = ScreenUtil().setWidth(140);


    return Padding(padding:  const EdgeInsets.all(10.0),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.dishesHomeTags!.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0, top: 20.0),
              child: Text(widget.dishesHomeTags[index]!.tagName!.toString() ?? "",style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(15.0), fontWeight: FontWeight.bold),),
            ),

     
       new Container(
      height: itemheight,
      child: new ListView.builder(
        
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: widget.dishesHomeTags[index]!.items!.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      
      itemBuilder: (context, i) {
        return  DishesHomeTagsCard(items: widget.dishesHomeTags[index]!.items![i],);
      },
      
    )
    ),
    
        ]
      );

      }))
      );
  }
}
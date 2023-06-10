import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/TopRestaurantsModel.dart';
import 'package:qfoods/screens/RestaurantScreenWithDishes/RestaurantScreenWithDishes.dart';

class TopRestaurantCard extends StatelessWidget {
  final TopRestaurantsModel topRestaurantsModel;
  const TopRestaurantCard({super.key, required this.topRestaurantsModel});


  @override
  Widget build(BuildContext context) {
     double itemheight = ScreenUtil().setHeight(100);

double itemWidth = MediaQuery.of(context).size.width * 0.90;


    return  InkWell(
                    onTap: (){

               if(topRestaurantsModel.status == 1){
                       Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => 
              RestaurantScreenWithDishes(restaurant_id: topRestaurantsModel?.restaurantId?.toString() ?? "",
              category: "",
              search: "",
              categoryName: ""

              )),
            );
               }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: itemheight,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: itemheight,
                          width: itemWidth * 0.32,
                         child: ClipRRect(
                     borderRadius: BorderRadius.circular(10.0),
                      child: topRestaurantsModel?.status == 0 ?
                        ColorFiltered(
  colorFilter: ColorFilter.mode(
    Colors.grey,
    BlendMode.saturation,
  ),
  child:   Image.network(topRestaurantsModel!.image!.toString() ?? "", fit: BoxFit.fitWidth,width: itemWidth/2.5 ),
)
                      : 
                      Image.network(topRestaurantsModel!.image!.toString() ?? "", fit: BoxFit.fitWidth,width: itemWidth/2.5 ),
                         )),
                  
                         Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                          Container(
                            width: itemWidth * 0.58,
                            child:   Text(topRestaurantsModel!.restaurantName!.toString() ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), color: AppColors.blackcolor, fontWeight: FontWeight.bold),)
                  ,
                          ),
                           SizedBox(height: 2.0,),
                          Row(
                            children: [
                                 Icon(Icons.stars, color: AppColors.primaryColor,size: ScreenUtil().setSp(14.0),),
                               SizedBox(width: 2.0,),
                                 Text("4.7", style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(13.0)),)
                            ],
                           ),
                           SizedBox(height: 2.0,),
                           Container(
                            width: itemWidth * 0.58,
                            child:   Text(topRestaurantsModel!.shortDescription!.toString() ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), color: AppColors.greycolor, fontWeight: FontWeight.normal),)
                  ,
                          ),
                          ],
                         ),
                         
                         )
                      ],
                    ),
                    ),
                  );
 
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/HomeProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/TopRestaurantsModel.dart';
import 'package:qfoods/screens/RestaurantScreenWithDishes/RestaurantScreenWithDishes.dart';
import 'package:qfoods/widgets/RestaurantCardLoading.dart';
import 'package:qfoods/widgets/TopRestaurantsCard.dart';
import 'package:shimmer/shimmer.dart';
class TopRestaurants extends StatefulWidget {
  const TopRestaurants({super.key});

  @override
  State<TopRestaurants> createState() => _TopRestaurantsState();
}

class _TopRestaurantsState extends State<TopRestaurants> {
  @override
  void initState() {
   
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(Provider.of<HomeProvider>(context, listen: false).topRestaurants?.length == 0){
      Provider.of<HomeProvider>(context, listen: false).getTopRestaurants();
      }
    });
    super.initState();
   
   
  }
 @override
  Widget build(BuildContext context) {
   double itemheight = ScreenUtil().setHeight(100);

double itemWidth = MediaQuery.of(context).size.width * 0.90;
 final homeProvider =  Provider.of<HomeProvider>(context, listen: true);
 
    return 
    homeProvider.TopRestaurantLoading
    ? RestaurantLoadingCard(context, 2)
    :
    Padding(
      padding:  const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text("Top Restaurants",style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(15.0), fontWeight: FontWeight.bold),),
            ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child:  ListView.builder(
            
                itemCount: homeProvider.topRestaurants?.length,
                 shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  return TopRestaurantCard(topRestaurantsModel: homeProvider.topRestaurants![index]);
                })),
            
          )
        ]
      )
    );
  }

}
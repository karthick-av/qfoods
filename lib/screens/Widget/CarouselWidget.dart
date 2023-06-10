import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/HomeProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/model/DishesHomeCategoriesModel.dart';
import 'package:qfoods/model/RestaurantHomeCarousel.dart';
import 'package:qfoods/model/RestaurantTag.dart';
import 'package:qfoods/screens/CategoryScreen/CategoryScreen.dart';
import 'package:qfoods/screens/RestaurantTagScreen/RestaurantTagScreen.dart';
import 'package:qfoods/widgets/ShimmerContainer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselWidget extends StatefulWidget {
 
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
   int currentposition = 0;

@override
  void initState() {
   
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(Provider.of<HomeProvider>(context, listen: false).home_carousel?.length == 0){
      Provider.of<HomeProvider>(context, listen: false).getCarousel();
      }
    });
    super.initState();
   
   
  }

  @override
  Widget build(BuildContext context) {
     final homeProvider =  Provider.of<HomeProvider>(context, listen: true);
   
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          homeProvider.carouselLoading
          ? ShimmerContainer(ScreenUtil().setHeight(140), MediaQuery.of(context).size.width * 0.90, 8)
          :
          CarouselSlider(
            items: [
                for (var i = 0; i < (homeProvider?.home_carousel?.length ?? 0); i++)
                   InkWell(
                    onTap: (){
                      if(homeProvider?.home_carousel?[i]?.type == "category"){
                           Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
               CategoryScreen(dishesHomeCategoriesModel: DishesHomeCategoriesModel(categoryId: homeProvider?.home_carousel?[i].typeId, withoutdetail: true))),
            );
                      }
                      else if(homeProvider?.home_carousel?[i]?.type == "tag"){
                         Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
               RestaurantTagScreen(restaurantTag: RestaurantTag(tagId: homeProvider?.home_carousel?[i]?.typeId ?? 0, withoutdetail: true))),
            );
                      }
                    },
                     child: ClipRRect(
                           borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(homeProvider?.home_carousel?[i]?.image ?? "",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.90,
                          
                            ),
                          ),
                   )

            ], options: CarouselOptions(
              enableInfiniteScroll: true,
              aspectRatio: 1.5,
              viewportFraction: 0.9,
                height: ScreenUtil().setHeight(140),
                    
                      autoPlay: true,
                      enlargeCenterPage: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      reverse: true,
                       onPageChanged: (index, reason) {
                        setState(() {
                          currentposition = index;
                        });
                      },
                   
            )),

          //    AnimatedSmoothIndicator(
          //   activeIndex: currentposition,
          //   count: data.length,
          //   effect: JumpingDotEffect(
          //           spacing: 5.0,
          //       radius: 50.0,
          //       dotWidth: ScreenUtil().setSp(8.0),
          //       dotHeight: ScreenUtil().setSp(8.0),
          //       dotColor: Colors.grey[200]!,
          //       activeDotColor: AppColors.primaryColor,
          //           jumpScale: .7,
          //           verticalOffset: 15,
          //         )
          // )
        ],
      ),
    );
  }
}
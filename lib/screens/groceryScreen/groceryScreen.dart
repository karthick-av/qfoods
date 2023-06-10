import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/Provider/GroceryHomeProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryHomeCarousel.dart';
import 'package:qfoods/model/GroceryHomeCategoriesModel.dart';
import 'package:qfoods/model/GroceryHomeTagsModel.dart';
import 'package:qfoods/screens/GroceryCartScreen/GroceryCartScreen.dart';
import 'package:qfoods/screens/GrocerySearchScreen/GrocerySearchScreen.dart';
import 'package:qfoods/screens/groceryScreen/widget/groceryCarouselWidget.dart';
import 'package:qfoods/screens/groceryScreen/widget/groceryCategoryWidget.dart';
import 'package:qfoods/screens/groceryScreen/widget/groceryproductsListWidget.dart';
import 'package:http/http.dart' as http;
import 'package:qfoods/constants/api_services.dart';


class GroceryScreen extends StatefulWidget {
 
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {


@override
  void initState() {
   
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<GroceryCartProvider>(context, listen: false).getCart();
    });

    super.initState();
  
  }
  

  @override
 Widget build(BuildContext context) {
   final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true);
  
    double width = MediaQuery.of(context).size.width;
   return Scaffold(
    
    backgroundColor: AppColors.whitecolor,
      body: SafeArea(

        child: Stack(
            alignment: Alignment.bottomCenter,
          children: [
            GlowingOverscrollIndicator(
              color: AppColors.primaryColor,
              axisDirection: AxisDirection.down,
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                  onRefresh: ()async{
        Provider.of<GroceryHomeProvider>(context, listen: false).getCarousel();
    Provider.of<GroceryHomeProvider>(context, listen: false).getHomeCategories();
     Provider.of<GroceryHomeProvider>(context, listen: false).getHomeTags();
   
         return;
        },
                child: CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                    
                      elevation: 0,
                      backgroundColor: AppColors.whitecolor,
                      floating: true,
                      pinned: true,
                      snap: false,
                      centerTitle: false,
                      title:   Text.rich(
                        
                TextSpan(
                  children: [
                TextSpan(text: 'Q ', style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(20.0))),
                   
                TextSpan(text: 'foods',style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(20.0))),
                  ],
                ),
                          
                      ),
                      actions: [
                        IconButton(
                          color: AppColors.primaryColor,
                          icon:  Icon(Icons.favorite_border, size:  ScreenUtil().setSp(14.0),),
                          
                          onPressed: () {
                          },
                          
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(ScreenUtil().setHeight(60.0)),
                      child: Container(
                        
                         padding: const EdgeInsets.symmetric(vertical: 10.0),
                          width: double.infinity,
                          height: ScreenUtil().setHeight(60.0),
                          child:  Center(
                            child: InkWell(
                                      onTap: (){
                                              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GrocerySearchScreen()),
                    );
                                      },
                                      child: Container(
                                        width: width * 0.90,
                                          height: ScreenUtil().setHeight(52.0),
                                  
                                        decoration:
                                            const BoxDecoration(
                                              color: Color(0xffF0F1F5),
                                            borderRadius:   BorderRadius.all(
                              Radius.circular(5.0),
                            )
                                            ),
                                            
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                           Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              "Search grocery or items",
                                              style: TextStyle(
                                              color: AppColors.lightgreycolor,
                                               fontSize: ScreenUtil().setSp(14),
                                                 fontFamily: FONT_FAMILY,
                                              ),
                                            )
                                            
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10.0),
                                            child: Icon(
                                              
                                              Icons.search,
                                              color: const Color(0xffC4C6CC),
                                              size: ScreenUtil().setSp(24),
                                            ),
                                            
                                          ),
                                          
                                        ]),
                                      ),
                                    )
                          ),
                        ),)
                    ),
                    // Other Sliver Widgets
                    SliverList(
                      delegate: SliverChildListDelegate([
                        groceryCarouselWidget(),
                        CategoryGroceryWidget(),
                        groceryproductsListWidget(),
                      
                    
                      ]),
                    ),
                  ],
                ),
              ),
            ),
         if((cartProvider?.CartData?.items?.length ?? 0) > 0) 
           Container(
      height: ScreenUtil().setHeight(55.0),
      margin: const EdgeInsets.only(bottom: 5),
      width: width * 0.95,
      decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: const Color(0xFFB0CCE1).withOpacity(0.60),
                      ),
                    ],
                  ),
      
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${cartProvider?.CartData?.items?.length?.toString() ?? ""} items", style: TextStyle(color: AppColors.greycolor, fontWeight:  FontWeight.w500,fontFamily: FONT_FAMILY),),
                              SizedBox(height: 3.0,),
                                Text("Rs ${cartProvider?.CartData?.total ?? ""}", style: TextStyle(color: AppColors.blackcolor, fontWeight:  FontWeight.bold,fontFamily: FONT_FAMILY),)
                            
                            
                            ],
                          ),
                        ),
                        Padding(
                       padding: const EdgeInsets.only(right: 18.0),
                       child: InkWell(
                        onTap: (){
                           Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GroceryCartScreen()),
            );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Text("View Cart", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w400),),
                        ),
                       ),
                           )
                    ],
                  ),
    ) 
          ],
        ),
      ),
    );
  }
}
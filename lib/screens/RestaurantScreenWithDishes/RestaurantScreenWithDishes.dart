
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/CartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/model/RestaurantAndDishesModel.dart';
import 'package:http/http.dart' as http;
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/screens/CartScreen/CartScreen.dart';
import 'package:qfoods/widgets/DishCard.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shimmer/shimmer.dart';


class RestaurantScreenWithDishes extends StatefulWidget {
  final String restaurant_id;
   final String category;
    final String search;
    final String categoryName;
  const RestaurantScreenWithDishes({super.key, required this.categoryName,required this.restaurant_id, required this.category,required this.search});

  @override
  State<RestaurantScreenWithDishes> createState() => _RestaurantScreenWithDishesState();
}

class _RestaurantScreenWithDishesState extends State<RestaurantScreenWithDishes> {
final scrollDirection = Axis.vertical;

  late AutoScrollController controller;
bool loading  = false;
String? title = "";
 bool menuNameToggle = false;

   RestaurantandDishesModel? restaurantandDishesModel;



  void initState() {
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
restaurantScreenWithDishesHandler();  
    super.initState();
  }


  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  
 Future<void> restaurantScreenWithDishesHandler()async {
  String url = "${ApiServices.restaurant_and_dishes}${widget.restaurant_id}?category=${widget.category}&search=${widget.search}";
 setState(() {
   loading = true;
 });
  try{
    var response = await http.get(Uri.parse(url));
    print(response.statusCode);
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       print(response_body);
       
      
       if(RestaurantandDishesModel.fromJson(response_body).restaurantId != null){
        print(RestaurantandDishesModel.fromJson(response_body).restaurantName);
            restaurantandDishesModel = RestaurantandDishesModel.fromJson(response_body);
            title = RestaurantandDishesModel.fromJson(response_body)?.restaurantName?.toString() ?? "";
            loading = false;
          setState(() {
          });
       }
    }
  }
  catch(err){

  }
}


void MenuDialog(context){
  
    double width = MediaQuery.of(context).size.width;
 showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: ScreenUtil().setHeight(250.0),
                  width: width * 0.90,
                 // margin: EdgeInsets.only(bottom: 50, left: 12, right:12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("Menu",style: TextStyle(decoration: TextDecoration.none,color: AppColors.blackcolor, fontWeight: FontWeight.bold,fontFamily: "Poppins", fontSize: ScreenUtil().setSp(18.0)),),),
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: restaurantandDishesModel?.menus?.length ?? 0,
                            itemBuilder: ((context, index) {
                              return GestureDetector(
                                onTap: () async{
                                  Navigator.of(context).pop();
                                   await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(index);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 0.5, color: AppColors.lightgreycolor))
                                  ),
                                  child: Row(
                                    children: [
                                      Text('${restaurantandDishesModel?.menus?[index]?.menuName ?? ""} (${restaurantandDishesModel?.menus?[index]?.dishes?.length ?? ""})', style: TextStyle(decoration: TextDecoration.none,color: AppColors.blackcolor, fontWeight: FontWeight.w300,fontFamily: "Poppins", fontSize: ScreenUtil().setSp(14.0)),)
                                    ],
                                  ),
                                ),
                              );
                            
                          })),
                        ),
                      ],
                    )
                  ),
                ),
                GestureDetector(
                   onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 50, top: 30),
                            decoration: BoxDecoration(
                  color: AppColors.whitecolor,
                               shape: BoxShape.circle,
                              // border: Border.all(color: Colors.black)
                            ),
                            child: Icon(Icons.close, color: Colors.black,size: ScreenUtil().setSp(30.0),),
                          ),
                )
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), 
                          end: Offset(0,0)).animate(anim1),
          child: child,
        );
      },
    );
}


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
      final cartProvider =  Provider.of<CartProvider>(context, listen: true);
   
    // ignore: non_constant_identifier_names
    return RefreshIndicator(
    color:  AppColors.primaryColor,
    strokeWidth: 3,
    triggerMode: RefreshIndicatorTriggerMode.onEdge,
    onRefresh: () async {
    
    await restaurantScreenWithDishesHandler();
    return;
    },
      child: Scaffold(
        backgroundColor: AppColors.whitecolor,
        floatingActionButton: 
        (!loading && (restaurantandDishesModel?.menus?.length ?? 0) > 0)
        ?
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SlideInRight(
              animate: (cartProvider.CartData?.items?.length ?? 0) > 0,
              child:  FloatingActionButton(
          backgroundColor: AppColors.whitecolor,
            shape: RoundedRectangleBorder(side: BorderSide(width: 1,color: AppColors.primaryColor),borderRadius: BorderRadius.circular(100)),
          
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, color: AppColors.primaryColor,),
            ],
          )),
      onPressed: () {
      Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
      },
    ),),
    SizedBox(height: 10.0,),
          
            FloatingActionButton(
          backgroundColor: AppColors.primaryColor,
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.food_bank, color: AppColors.whitecolor,),
              Text("Menu", style: TextStyle(color: AppColors.whitecolor, fontFamily: "Poppins", fontSize: ScreenUtil().setSp(10.0)),)
            ],
          )),
      onPressed: () {
       MenuDialog(context);
      },
    )
          ],
        ) : null,
        appBar: AppBar(
      leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.black, size: ScreenUtil().setSp(25.0)),
      onPressed: () => Navigator.of(context).pop(),
      ), 
      title: AnimatedSwitcher(
      // key: ValueKey<String>(title),
    
      duration: Duration(seconds: 1),
      
      
      child: Text(title?.toString() ?? "", style: TextStyle(color: AppColors.blackcolor, fontFamily: "Poppins", fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(17.0)),)),
      centerTitle: true,
      backgroundColor: AppColors.whitecolor,
      elevation: 0.0,
      actions: [
      Padding(padding: const EdgeInsets.only(right: 20.0), child: 
      Icon(Icons.search, color: AppColors.blackcolor, size: ScreenUtil().setSp(25.0),),)
      ],
    ),
        body: loading ? RestaurantDishLoading(context)
        : GlowingOverscrollIndicator(
            color: AppColors.primaryColor,
     axisDirection: AxisDirection.down,
     
          child: SingleChildScrollView(
               scrollDirection: scrollDirection,
        controller: controller,
        physics: AlwaysScrollableScrollPhysics(),
            child: Column(
                   
            children: [
            SizedBox(height: 15.0,),
             Center(
             child: Container(
               width: width * 0.90,
               padding: const EdgeInsets.all(10.0),
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
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                               Text("${restaurantandDishesModel?.restaurantName ?? ""}", maxLines: 2,style: TextStyle(fontFamily: "Poppins", overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),),
                            SizedBox(height: 10.0,),
                                 Row(
                           children: [
                                Icon(Icons.stars, color: AppColors.primaryColor,size: ScreenUtil().setSp(15.0),),
                              SizedBox(width: 2.0,),
                                Text("${restaurantandDishesModel?.rating ?? '0'}", style: TextStyle(fontFamily: "Poppins", color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(13.0)),),
                              SizedBox(width: 2.0,),
                            Text("Ratings", maxLines: 2,style: TextStyle(fontFamily: "Poppins", overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14.0)),)
                           
                           ],
                          ),
                               SizedBox(height: 10.0,),
                             Text("${restaurantandDishesModel?.address ?? ""}", maxLines: 2,style: TextStyle(fontFamily: "Poppins", overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14.0)),)
                           
                         ],
                       ),
                     ),
             ),
             ),
              
             if((restaurantandDishesModel?.searchResults?.length ?? 0) >0)
             Padding(
             padding: const EdgeInsets.all(10.0),
             child: Container(
                   margin: const EdgeInsets.symmetric(vertical: 10.0),
                     padding: const EdgeInsets.all(10.0),
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
                 child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                   child: ExpansionTile(
                     tilePadding: EdgeInsets.all(0),
                     collapsedTextColor: AppColors.blackcolor,
                     collapsedIconColor: AppColors.blackcolor,
                     textColor: AppColors.blackcolor,
                     iconColor: AppColors.blackcolor,
                 
                     initiallyExpanded: true,
                       title: Text(
                         "Looking for ${widget.categoryName != '' ? widget.categoryName : (widget.search ?? '')}",maxLines: 2,style: TextStyle(fontFamily: "Poppins", overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                       ),
                       
                       children: [
                        ListView.builder(
                           physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                   itemCount: restaurantandDishesModel?.searchResults?.length ?? 0,
                         itemBuilder: ((context, i) {
                           return DishCard(dish: restaurantandDishesModel?.searchResults?[i],
                           rstatus: restaurantandDishesModel?.status,
                           );
                 
                         })
                        )
                       ],
                     ),
                 )), 
             ),
            Padding(
             padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
              //  itemScrollController: itemScrollController,
            
                 itemCount: restaurantandDishesModel?.menus?.length ?? 0,
                 physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
              padding: EdgeInsets.only(left: 10, right: 10),
                 itemBuilder: ((context, index) {
                 return AutoScrollTag(
                   key: ValueKey(index),
                  controller: controller,
                  index: index,
                   highlightColor: AppColors.primaryColor.withOpacity(0.1),
                   child: Container(
                     margin: const EdgeInsets.symmetric(vertical: 10.0),
                       padding: const EdgeInsets.all(10.0),
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
                   child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                     child: ExpansionTile(
                       tilePadding: EdgeInsets.all(0),
                       collapsedTextColor: AppColors.blackcolor,
                       collapsedIconColor: AppColors.blackcolor,
                       textColor: AppColors.blackcolor,
                       iconColor: AppColors.blackcolor,
                   
                       initiallyExpanded: true,
                         title: Text(
                           restaurantandDishesModel?.menus?[index]?.menuName ?? "",maxLines: 2,style: TextStyle(fontFamily: "Poppins", overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                         ),
                         
                         children: [
                          ListView.builder(
                             physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                     itemCount: restaurantandDishesModel?.menus?[index]?.dishes?.length ?? 0,
                           itemBuilder: ((context, i) {
                             return DishCard(dish: restaurantandDishesModel?.menus?[index]?.dishes?[i],
                             rstatus: restaurantandDishesModel?.status,
                             );
                   
                           })
                          )
                         ],
                       ),
                   )),
                 );
               })),
            ),
            
            ],
            ),
          ),
        )
      ),
    );
  }










  Widget RestaurantDishLoading(BuildContext context){
       double itemWidth = MediaQuery.of(context).size.width * 0.90;

    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.only(left: ScreenUtil().setWidth(15.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           Shimmer.fromColors(child: Container(
                    height: ScreenUtil().setHeight(90.0),
                    width: itemWidth,
                    margin: const EdgeInsets.only(top: 10),
                   decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                             
                            ),
                ), 
                   baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
                  ) ,

                  for(int i = 0; i < 3; i++)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Shimmer.fromColors(child: Container(
                    height: ScreenUtil().setHeight(20.0),
                    width: itemWidth * 0.30,
                    margin: const EdgeInsets.only(top: 10),
                   decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                             
                            ),
                ), 
                   baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
                  ) ,

           Shimmer.fromColors(child: Container(
                    height: ScreenUtil().setHeight(90.0),
                    width: itemWidth * 0.95,
                    margin: const EdgeInsets.only(top: 10),
                   decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                             
                            ),
                ), 
                   baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
                  ) ,

  Shimmer.fromColors(child: Container(
                    height: ScreenUtil().setHeight(90.0),
                    width: itemWidth * 0.95,
                    margin: const EdgeInsets.only(top: 10),
                   decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                             
                            ),
                ), 
                   baseColor: Color(0xFFF5F5F5), highlightColor: AppColors.whitecolor
                  ) ,
             ],
                  )         
          ],
        ),
      ),
    );
  }
}
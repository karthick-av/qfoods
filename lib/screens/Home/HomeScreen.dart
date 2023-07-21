import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/CartProvider.dart';
import 'package:qfoods/Provider/HomeProvider.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/DishesHomeCategoriesModel.dart';
import 'package:qfoods/model/DishesHomeTagsModel.dart';
import 'package:qfoods/model/GroceryHomeTagsModel.dart';
import 'package:qfoods/model/RestaurantHomeCarousel.dart';
import 'package:qfoods/model/TopRestaurantsModel.dart';
import 'package:qfoods/screens/CartScreen/CartScreen.dart';
import 'package:qfoods/screens/SearchScreen/SearchScreen.dart';
import 'package:qfoods/screens/Widget/CarouselWidget.dart';
import 'package:qfoods/screens/Widget/CategoryWidget.dart';
import 'package:qfoods/screens/Widget/TopRestaurants.dart';
import 'package:qfoods/screens/Widget/topdishesWidget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



@override
  void initState() {
   
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context, listen: false).getCart();
   UpdateFcmTokenHandler();
    });
    super.initState();
   
   
  }
  



Future<void> UpdateFcmTokenHandler() async{
  try{
 final uri = Uri.parse(ApiServices.update_fcmtoken);
 String? token = await FirebaseMessaging.instance.getToken();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
  if(user_id == null) return;
    final data = {
      "user_id": user_id?.toString(),
      "fcm_token": token
    };

    var jsonString = json.encode(data);
    print(jsonString);
     var header ={
  'Content-type': 'application/json'
 };
    final response = await http.put(uri, body: jsonString, headers: header);

  }
  catch(e){

  }
}


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
     final cartProvider =  Provider.of<CartProvider>(context, listen: true);
   
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
        Provider.of<HomeProvider>(context, listen: false).getCarousel();
    Provider.of<HomeProvider>(context, listen: false).getHomeCategories();
     Provider.of<HomeProvider>(context, listen: false).getTopRestaurants();
   
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
                   icon:  Icon(Icons.local_grocery_store, size:  ScreenUtil().setSp(25.0),),
                   
                   onPressed: () {
                      Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => CartScreen()));
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
               MaterialPageRoute(builder: (context) => SearchScreen()),
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
                                       "Search Restaurant or dish",
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
                 CarouselWidget(),
                 CategoryWidget(),
                // topdishesWidget(dishesHomeTags: DishesHomeTags,),
                  TopRestaurants(),
          

               SizedBox(height: ScreenUtil().setHeight(200),)
          
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
       MaterialPageRoute(builder: (context) => CartScreen()),
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
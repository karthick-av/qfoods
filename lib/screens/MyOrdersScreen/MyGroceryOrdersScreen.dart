import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryOrderModel.dart';
import 'package:qfoods/model/OrderModel.dart';
import 'package:http/http.dart' as http;
import 'package:qfoods/screens/ViewOrderScreen/ViewGroceryOrderScreen.dart';
import 'package:qfoods/screens/ViewOrderScreen/ViewOrderScreen.dart';
import 'package:qfoods/widgets/RestaurantCardLoading.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyGroceryOrdersScreen extends StatefulWidget {
  const MyGroceryOrdersScreen({super.key});

  @override
  State<MyGroceryOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyGroceryOrdersScreen> {

 ScrollController scrollController = ScrollController();

bool ApiCallDone = false;
int current_page = 1;
bool CompleteAPI = false;
int per_page = 10;
bool loading = false;
bool footer_loading = false;
bool header_loading = false;

List<GroceryOrderModel> orders = [];


 @override
  void initState() {
    getOrdersHandler();
    scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
        BottomGetOrdersHandler();
       }
    }

   
    });
    
    super.initState();
  }

     Future<String> URL() async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
    if(user_id == null) return "";
    String userid =user_id!.toString();
  
      String url = "${ApiServices.get_grocery_orders}${userid}?page=${current_page}&per_page=${per_page}";
return url;
}

Future<void> APIHandler()async{
   ApiCallDone = false;
 current_page = 1;
 CompleteAPI = false;
 per_page = 10;
 loading = true;
 footer_loading = false;
 setState(() {});

 getOrdersHandler();
}

Future<void> getOrdersHandler()async {
  List<GroceryOrderModel> _orders= [];
  setState(() {
    loading = true;
  });
try{
  
    var response = await http.get(Uri.parse(await URL()));
     setState(() {
    loading = false;
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      _orders.add(GroceryOrderModel.fromJson(json));
       }

       setState(() {
         orders= _orders;
         current_page = current_page + 1;
         loading = false;


       });
    }
  }
  catch(err){
 setState(() {
    loading = false;
  });
  }
  
}

Future<void> BottomGetOrdersHandler()async {
  if(CompleteAPI) return;

  List<GroceryOrderModel> _orders= [];
  setState(() {
    footer_loading = true;
    ApiCallDone = true;
  });
try{
  
    var response = await http.get(Uri.parse(await URL()));
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);

       if(response_body!.length == 0){
        setState(() {
          CompleteAPI = true;
        });
       }
       
       for(var json in response_body){
     
      _orders.add(GroceryOrderModel.fromJson(json));
       }

       setState(() {
         footer_loading = false;
    current_page = current_page + 1;
    ApiCallDone = false;
 
         orders=  [...orders, ..._orders];
      


       });
    }else{
      setState(() {
    ApiCallDone = false;
  });
    }
  }
  catch(err){
 setState(() {
    ApiCallDone = false;
  });
  }
  
}

void dispose(){
  scrollController.dispose();
 
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
        double height= MediaQuery.of(context).size.height;
  
        double width = MediaQuery.of(context).size.width;
  
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      appBar: AppBar(
   iconTheme: IconThemeData(
    color: Colors.black, // <-- SEE HERE
   ),
        backgroundColor: AppColors.whitecolor,
        elevation: 0.5,
        title: Text("Grocery Orders", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16.0), fontWeight: FontWeight.bold,color: AppColors.blackcolor),),
      ),
      body: SafeArea(
        child: RefreshIndicator(
           color: AppColors.primaryColor,
                  onRefresh: ()async{
                    await APIHandler();
          },
          child: loading ? 
          SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: RestaurantLoadingCard(context, 8), physics: AlwaysScrollableScrollPhysics(),)
          :  SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
               Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              height: 1,
                              color: Color(0XFFe9e9eb),
                             ),
                
              ListView.builder(
               physics: ClampingScrollPhysics(),
                controller: scrollController,
                shrinkWrap: true,
                itemCount: orders?.length ?? 0,
                itemBuilder:(context, index) {
                     var parsedDate = DateTime.parse(orders[index]?.orderCreated ?? '');
        
          final DateFormat formatter = DateFormat('MMM dd,yyyy hh:mm a');
          final String formatted = formatter.format(parsedDate);
          
                return InkWell(
                  onTap: (){
                         Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => 
               ViewGroceryOrderScreen(orderDetail: orders[index],)),
              );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                     padding: const EdgeInsets.all(14.0),
                     
                          width: width * 0.90,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order Id: ${orders?[index]?.orderId ?? ''}",style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500)),
                            SizedBox(height: 5,),
                            Text("${formatted ?? ''}",style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11.0), fontWeight: FontWeight.w400)),
                         
                          ],
                        )
                     
                        ,Text("RS ${orders?[index]?.grandTotal ?? ''}",style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold))
                     
                      ],
                    ),
                  ),
                );
                
             
              }),
                SizedBox(height:height * 0.50)
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
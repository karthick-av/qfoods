import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/CustomSnackBar.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/OrderModel.dart';
import 'package:qfoods/screens/ViewOrderScreen/TimeLine.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class ViewOrderScreen extends StatefulWidget {
  final OrderModel orderDetail;
  const ViewOrderScreen({super.key, required this.orderDetail});

  @override
  State<ViewOrderScreen> createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  OrderModel? order;
  bool? loading;
  bool isReviewModal = false;
 IO.Socket? socket;

 List<dynamic> reviewItemList = [];
  
  @override
  void initState(){
    order = widget.orderDetail;
    if(order?.isDelivered == 0 && order?.isCancelled == 0){
      initSocket();

     
    }
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   openReviewModal(order);
    List<dynamic> _list = [];
      order?.dishItems?.forEach((e){
      
        _list.add({
        "item_id": e?.dishId?.toString(),
        "variant_id": (e?.variantItems?.length ?? 0) > 0 ? e?.variantItems?.map((e) => e?.variantItemId)?.toList().join(",") : null,
        "name": e?.name?.toString(),
        "variant_name": e?.variantName?.toString(),
        "rating": 0,
        "review": ""
       });
      });
      reviewItemList = _list;
      setState(() {});
   });
super.initState();
  }

 void openReviewModal(OrderModel? ord){
  print(ord?.isDelivered == 1 && (ord?.isReviewed == 0 || ord?.isDeliveryPersonRating == 0));

    if(ord?.isDelivered == 1 && (ord?.isReviewed == 0 || ord?.isDeliveryPersonRating == 0)){
       _showBottomSheet();
     }
 }

  @override
void dispose() {
  socket?.disconnect();
  socket?.dispose();
  super.dispose();
}

 void _showBottomSheet() {
   isReviewModal=  true;
   setState(() {});

    _scaffoldKey.currentState!.showBottomSheet((context) {
      
      double width = MediaQuery.of(context).size.width;
      return new Container(
       height: ScreenUtil().setHeight(80),
       width: double.infinity,
       alignment: Alignment.center,
        child: InkWell(
          onTap: (){
             if(order?.isDeliveryPersonRating == 0){
               ReviewBottomSheet(context);
             }else{
DishesReviewBottomSheet(context, reviewItemList);
             }
                        
          },
          child: Container(
          height: ScreenUtil().setSp(15) * 3,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            width:width * 0.90,
            child: Text("Give your Review",
            style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),
            ),
          ),
        ),
      );
    });
  }
  
initSocket() {
  try{
  socket = IO.io(ApiServices.SOCKET_ORDER_URL, <String, dynamic>{
    'autoConnect': true,
    'transports': ['websocket'],
  });
  socket?.connect();
  socket?.onConnect((_) {
    print('Connection established');
  });
  socket?.onDisconnect((_) => print('Connection Disconnection'));
  socket?.onConnectError((err) => print(err));
  socket?.onError((err) => print(err));
  socket?.emit("join_restaurant_order", {"order_id": "restaurant_order_${order?.orderId}"});
  socket?.on("changes_order", (data){
    print(data);
   try{
 if(data["type"] == "restaurant"){
     if(data["data"] != null){
       OrderModel order_ = OrderModel.fromJson(data["data"]);
      if(order_?.orderId != null){
        order = order_;
        setState(() { });
      }
     } 
    }
   }catch(e){

   }
  });
  }
  catch(e){
    
  }
}

Future<void> getOrderHandler() async{
   setState(() {
    loading = true;
  });
  try{
 var response = await http.get(Uri.parse("${ApiServices.get_order}${order?.orderId}"));
     setState(() {
    loading = false;
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
      OrderModel __order = OrderModel.fromJson(response_body);
   
 if(__order?.orderId != null){
    
       order = __order;
       setState(() {});
     }
    }
  }catch(e){
 print(e);
  }
}

void updateOrder(OrderModel ord){
   order = ord;
       setState(() {});
}

Future<bool> _onWillPop() async {
    if(isReviewModal){
Navigator.pop(context);
    }
        
  Navigator.of(context).pop();
  return true;
  }
  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
  
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
         key: _scaffoldKey,
        backgroundColor: AppColors.whitecolor,
        body: SafeArea(
          child: Column(
            children: [
               Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                   child: Row(
                     children: [
                       InkWell(
                        onTap: (){
                        },
                        child: Icon(Icons.arrow_back, color: AppColors.blackcolor, size: ScreenUtil().setSp(18),),
                        
                       ),
                       SizedBox(width: 10,),
                       Text("View Order", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.w500),)
                     ],
                   ),
                 ),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
              await getOrderHandler();
              return;
            },
    
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child:  Column(
                        children: [
                          
                            Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        width: double.infinity,
                                        height: 1,
                                        color: Color(0XFFe9e9eb),
                                       ),
                        
                        SizedBox(height: 8,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                               Column(
                                children: [
                                     Text("Order Id: ${order?.orderId ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),)
                                 
                                ],
                               ),
                               Text("Total Rs ${order?.grandTotal ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontWeight: FontWeight.bold,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),)
                               ],
                              ),
                            )  ,
    
    
    
                       if(order?.isCancelled  == 1)
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(14.0),
                                            width: width * 0.90,
                                             decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
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
                                      Text("Cancelled Reason:-", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                      ,
                                      SizedBox(height: 5,),
                                       Text("${order?.cancelDetail?.cancelledReason ?? ''}", 
                                       style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.normal),)
                                   
                                    ],
                                  ),
                        ),
    
                            
    
                            if(order?.isCancelled == 0)
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: TimeLine(order: order,),
                           ),
                           SizedBox(
                                  height: 5,
                                ),
                        
    
                        if(order?.deliveryPersonId != null && order?.deliveryPersonDetail?.phoneNumber != null)
                                Container(
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
                                   child: Theme(
                               data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                               child: ExpansionTile(
                                    tilePadding: EdgeInsets.all(0),
                                     collapsedTextColor: AppColors.blackcolor,
                                     collapsedIconColor: AppColors.blackcolor,
                                     textColor: AppColors.blackcolor,
                                     iconColor: AppColors.blackcolor,
                               
                                     initiallyExpanded: true,
                                     title:      Container(
                                    
                           width: width * 0.80,
                      child: Text("Delivery Person", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold))),
                       children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                        Container(
               width: ScreenUtil().setWidth(50),
               height: ScreenUtil().setHeight(50),
               decoration: BoxDecoration(
                 color: const Color(0xff7c94b6),
                 image: DecorationImage(
                   image: NetworkImage('${order?.deliveryPersonDetail?.image ?? ''}'),
                   fit: BoxFit.cover,
                 ),
                 borderRadius: BorderRadius.all( Radius.circular(50.0)),
                
               ),
             ),
    
             Container(
              margin: const EdgeInsets.only(left: 10),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${order?.deliveryPersonDetail?.name ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),),
                 SizedBox(height: 3,),
                  Text("${order?.deliveryPersonDetail?.phoneNumber ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY),),
                ],
               ),
             )
    
                            ],
                          ),
                        )
                       ],                       
                               )
                                   ),                   
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                        
                                Container(
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
                                   child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Delievery Address :-", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                                 Theme(
                               data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                               child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                   collapsedTextColor: AppColors.blackcolor,
                                   collapsedIconColor: AppColors.blackcolor,
                                   textColor: AppColors.blackcolor,
                                   iconColor: AppColors.blackcolor,
                               
                                   initiallyExpanded: false,
                                   title:      Container(
                                  
                           width: width * 0.80,
                      child: Text("${order?.address?.address1 != '' ? order?.address?.address1 : order?.address?.address2}", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),)),
                       children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                      width: width * 0.80,
                                child: Text("${order?.address?.address2 ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),))
                             , Container(
                              margin: const EdgeInsets.only(top: 5),
                                      width: width * 0.80,
                                child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Land Mark:-", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),),
                                    Container(
                                      width: width * 0.40,
                                
                                      child: Text("${order?.address?.landmark ?? ''}", 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),)),
                                  ],
                                )),
                                Container(
                              margin: const EdgeInsets.only(top: 5),
                                      width: width * 0.80,
                                child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Alt phone Number:-", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),),
                                    Container(
                                      width: width * 0.40,
                                
                                      child: Text("${order?.address?.alternatePhoneNumber ?? ''}", 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),)),
                                  ],
                                ))
                            
                            
                            ],
                          ),
                        )
                       ],                       
                               )
                                 )
                                  
                                   ]),                   
                                ),
                                SizedBox(height: 10,),
                           Container(
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
                            child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Sub Total", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                                  Text("Rs ${order?.subTotal ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                                
                                                ],
                                              ),
                                              
                                              SizedBox(height: ScreenUtil().setSp(20.0),),
                                               Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Delivery Charges", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                                      SizedBox(height: 4,),
                                                    //  if(_checkouttotal?.kms != null)
                                                      
                                                    ],
                                                  ),
                                                  Text("Rs ${order?.deliveryCharges ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                                
                                                ],
                                              ),
                                              SizedBox(height: ScreenUtil().setSp(20.0),),
                                               Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Grand Total", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                                  Text("Rs ${order?.grandTotal ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                                
                                                ],
                                              )
                                            ],
                                          ),
                           )
                                
                                  ,
                                   SizedBox(height: 10,),                 
                      
                                  Container(
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
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      
                        Text("Order Items :-", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                        SizedBox(height: 3,),
                                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order?.dishItems?.length,
                      itemBuilder: ((context, index) {
                      return 
                      (order?.dishItems?[index]?.variantItems?.length ?? 0) > 0
                      ?
                      Theme(
                               data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                               child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                   collapsedTextColor: AppColors.blackcolor,
                                   collapsedIconColor: AppColors.blackcolor,
                                   textColor: AppColors.blackcolor,
                                   iconColor: AppColors.blackcolor,
                               
                                   initiallyExpanded: false,
                                   title: Container(
                          width: width * 0.90,
                          
                          margin: const EdgeInsets.only(top: 5),
                           padding: const EdgeInsets.all(1),             
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: width * 0.60,
                                  child:  Text("${order?.dishItems?[index]?.name ?? ''}  (X${order?.dishItems?[index]?.quantity ?? ''})",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 1),
                                  width: width * 0.60,
                                  child:  Text("${order?.dishItems?[index]?.restaurantName ?? ''}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(11), fontFamily: FONT_FAMILY),
                                  ),
                                
                                  
                                  
                                ),
                                  Container(
                                  margin: const EdgeInsets.only(top: 1),
                                  width: width * 0.60,
                                  child:  Text("${order?.dishItems?[index]?.variantName ?? ''}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(11), fontFamily: FONT_FAMILY),
                                  ),
                                
                                  
                                  
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 1),
                                  width: width * 0.60,
                                  child:  Text("Rs ${order?.dishItems?[index]?.total ?? ''}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(11), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                                  ),
                                
                                  
                                  
                                ),
                                
                                
                              ],
                            ),
                            
                        ],),
                      ),
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: order?.dishItems?[index]?.variantItems?.length ?? 0,
                          itemBuilder: ((context, i) {
                            return Row(
                              children: [
                                Container(
                          width: width * 0.80,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0XFFe9e9eb))
                            )
                          ),
                           padding: const EdgeInsets.all(2),             
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.30,
                              child:  Text("${order?.dishItems?[index]?.variantItems?[i]?.name ?? ''}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(12), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                              ),
                            ),
                          Container(
                              alignment: Alignment.centerRight,
                              width: width * 0.20,
                              child:  Text("Rs ${order?.dishItems?[index]?.variantItems?[i]?.price ?? ''}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500,fontFamily: FONT_FAMILY),
                              ),
                            )
                        ],),
                      )
                              ],
                            );
                          }),
                        )
                      ],
                               )
                      )
                                
                                   : Container(
                          width: width * 0.90,
                          margin: const EdgeInsets.only(top: 5),
                           padding: const EdgeInsets.all(1),             
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: width * 0.60,
                                  child:  Text("${order?.dishItems?[index]?.name ?? ''}  (X${order?.dishItems?[index]?.quantity ?? ''})",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 1),
                                  width: width * 0.60,
                                  child:  Text("${order?.dishItems?[index]?.restaurantName ?? ''}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(11), fontFamily: FONT_FAMILY),
                                  ),
                                  
                                ),
                                
                              ],
                            ),
                             Container(
                              alignment: Alignment.centerRight,
                              width: width * 0.20,
                              child:  Text("Rs ${order?.dishItems?[index]?.total ?? ''}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500,fontFamily: FONT_FAMILY),
                              ),
                            )
                        ],),
                      );
                                  })),
                        ],
                      ),
                                  ),
                                
                          SizedBox(height: MediaQuery.of(context).size.height * 0.50,)      
                        ],
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
Future<void> DishesReviewBottomSheet(BuildContext mcxt, List<dynamic> DishesReview) async {
 
  bool loading = false;

  Future<void> ApplyReviewHandler(BuildContext cxt) async{
  try{
    List<dynamic> data = [];
    DishesReview?.forEach((v){
     data.add({
       "variant_id": v["variant_id"] != null ? v["variant_id"] : v["variant_id"]?.toString(),
      "item_id": v["item_id"]?.toString(),
      "rating": v["rating"]?.toString(),
      "review": v["review"]?.toString(),
      "user_id": "1",
      "order_id": order?.orderId?.toString()
     });
    });
    loading = true;
    setState((){});
            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
 final jsonData = json.encode(data?.toList());
 
var header ={
  'Content-type': 'application/json'
 };
  
 var response = await http.post(Uri.parse(ApiServices.apply_review), body: jsonData, headers: header);
 
    loading = false;
    setState((){});
      if(response.statusCode == 200){
      final responsebody = json.decode(response.body);
 Navigator.of(cxt).pop();
 
 
        OrderModel __order = OrderModel.fromJson(responsebody);
        if(__order?.orderId != null){
          updateOrder(__order);
 if(__order?.isDelivered == 1 && (__order?.isReviewed == 0 || __order?.isDeliveryPersonRating == 0)){
   
 }else{
  if(isReviewModal){
Navigator.pop(context);
    }
 }
CustomSnackBar().successMsgSnackbar("Thank you for Review");
        }else{

CustomSnackBar().ErrorSnackBar();
        }
               
      
   }
  }catch(e){
       loading = false;
    setState((){});
CustomSnackBar().ErrorSnackBar();
  }
  }
   double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  
  
       showDialog(
      context: context,
      builder: (BuildContext contex_t) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: Scaffold(
                backgroundColor: AppColors.whitecolor,
                  bottomNavigationBar: Container( 
           height: height * 0.08,
         width: width,
         alignment: Alignment.center,
         padding: const EdgeInsets.all(2),
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
        
          child: 
          loading
          ?
          Container( 
             height: height * 0.055,
            width: width * 0.90,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration( 
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: SizedBox(
              height: ScreenUtil().setSp(20),
              width: ScreenUtil().setSp(20),
              child: CircularProgressIndicator(color: AppColors.whitecolor, )),
          )
          :
          
          InkWell( 
            onTap: (){
               FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
    ApplyReviewHandler(contex_t);
               },
            child:  Container( 
             height: height * 0.055,
            width: width * 0.90,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration( 
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Submit", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),),
          ),
         ),
          ),
      
                appBar: AppBar(
                  elevation: 0.5,
                  backgroundColor: AppColors.whitecolor,
                  title: const Text('Write Review',
                  style: 
                 TextStyle(color: AppColors.blackcolor,  fontWeight: FontWeight.bold),),
            
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.blackcolor,),
                  )
                ],
                ),
                body: ListView.builder(
                  padding: const EdgeInsets.all(10),
                          itemCount: DishesReview?.length,
                          
                          shrinkWrap: true,
                          itemBuilder: (cxxt, int i){
                            return Container(
                              margin:  EdgeInsets.only(top: ScreenUtil().setSp(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(DishesReview[i]["name"] ?? "",
                                  style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w600),
                                  ),
                                  DishesReview[i]["variant_name"] != "" ?
                                  Text(DishesReview[i]["variant_name"] ?? "",
                                  style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w600),
                                  ) : SizedBox(),
                                    RatingBar.builder(
                                         initialRating: 0,
                                         minRating: 1,
                                         direction: Axis.horizontal,
                                         allowHalfRating: false,
                                         itemCount: 5,
                                         itemSize: ScreenUtil().setSp(28),
                                         unratedColor: AppColors.lightgreycolor,
                                         itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                         itemBuilder: (context, _) => Icon(
                                           Icons.star_rounded,
                                           color: AppColors.primaryColor,
                                         ),
                                         glow: false,
                                        onRatingUpdate: (rating_) {
                                 DishesReview[i]["rating"] =rating_.toInt();
                                 setState(() {});
                               }
                                      ),
                                      SizedBox(height: 10,),
                                      
                                       SizedBox(
                                        height: 70,
                                         child: TextField(
                                          onChanged: (String val){
                                            DishesReview[i]["review"] = val;
                                            setState(() { });
                                          },
                                        
                                          
                                       style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                       maxLines: null, // <-- SEE HERE
                                                       // minLines: 1,
                              expands: true,
                               cursorColor: AppColors.greycolor,
                                   keyboardType: TextInputType.multiline,  
                                       decoration:  InputDecoration(
                                    //    contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                              labelText: 'Write an Review',
                              errorStyle: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(8.0)),
                              border: OutlineInputBorder(
                              )
                              ,
                                 focusedBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(4)),
                                 borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(4)),
                                 borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                               ),
                              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                      // TODO: add errorHint
                                      ),
                                    ),
                                       )
                                ],
                              ),
                            );
                          }),
              ),
            );
          });
      });
  


 }



 Future<void> ReviewBottomSheet(BuildContext mcxt) async {
  int rating = 0;
  String review = "";
  bool loading = false;

  Future<void> ApplyReviewHandler(StateSetter myState) async{
  try{
    
    loading = true;
    myState((){});
            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }


    dynamic data = {
      "user_id": "1",
      "order_id": widget.orderDetail?.orderId?.toString(),
      "rating": rating?.toString(),
      "review": review?.toString(),
      "type": "restaurant"
    };
 var response = await http.post(Uri.parse(ApiServices.apply_delivery_person_rating), body: data);
 
    loading = false;
    myState((){});
      if(response.statusCode == 200){
      final responsebody = json.decode(response.body);
      if(responsebody["message"] != null){
       CustomSnackBar().ErrorMsgSnackBar(responsebody["message"]);
       
                        Navigator.of(context).pop();
      }else{
        OrderModel __order = OrderModel.fromJson(responsebody);
        if(__order?.orderId != null){
          updateOrder(__order);
          openReviewModal(__order);
          print('jjjj');
          print((__order?.isDelivered == 1 && (__order?.isReviewed == 0 || __order?.isDeliveryPersonRating == 0)));
 if(__order?.isDelivered == 1 && (__order?.isReviewed == 0 || __order?.isDeliveryPersonRating == 0)){
  
                        Navigator.of(context).pop();
   DishesReviewBottomSheet(context, reviewItemList);
 }else{
  if(isReviewModal){
Navigator.pop(context);
    }
 }
CustomSnackBar().successMsgSnackbar("Thank you for Review");
        }else{

                        Navigator.of(context).pop();
CustomSnackBar().ErrorSnackBar();
        }
               
      }
   }
  }catch(e){
       loading = false;
    myState((){});
CustomSnackBar().ErrorSnackBar();
  }
}


  showModalBottomSheet(
    context: mcxt,
 isScrollControlled: true,
 builder: (BuildContext context) {

    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext cxt, StateSetter myState) {
        return Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0), // content padding
              child: Container(
                child: Column(
              children: <Widget>[
                
              Row( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Review", style: 
                  TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold),),
                   IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close_rounded),
                      iconSize: ScreenUtil().setSp(25.0),
                    )
                ]
              ),

                        Column(
                children: [
                  SingleChildScrollView(
                     padding: const EdgeInsets.only(bottom: 50),
               child: Column(
                      children: [
                        RatingBar.builder(
             initialRating: 0,
             minRating: 1,
             direction: Axis.horizontal,
             allowHalfRating: false,
             itemCount: 5,
             unratedColor: AppColors.lightgreycolor,
             itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
             itemBuilder: (context, _) => Icon(
               Icons.star_rounded,
               color: AppColors.primaryColor,
             ),
             glow: false,
            onRatingUpdate: (rating_) {
     rating =rating_.toInt();
     myState(() {});
   }
          ),
          SizedBox(height: 10,),
          
           SizedBox(
            height: 100,
             child: TextField(
              onChanged: (String val){
                review = val;
                setState(() { });
              },
            
              
                                     style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                     maxLines: null, // <-- SEE HERE
                           // minLines: 1,
                            expands: true,
                             cursorColor: AppColors.greycolor,
                                 keyboardType: TextInputType.multiline,  
                                     decoration:  InputDecoration(
                                  //    contentPadding: EdgeInsets.symmetric(vertical: 40.0),
                            labelText: 'Write an Review',
                            errorStyle: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(8.0)),
                            border: OutlineInputBorder(
                            )
                            ,
                               focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(4)),
                               borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                             ),
                             enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(4)),
                               borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                             ),
                            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                    // TODO: add errorHint
                                    ),
                                  ),
           )
                      ],
                    ),
                  ),
                  
                  loading 
                  ? 
                  Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.5), borderRadius: BorderRadius.circular(8.0)),
                    child: SizedBox(
                      height: ScreenUtil().setSp(20),
                      width: ScreenUtil().setSp(20),
                      child: CircularProgressIndicator(color: AppColors.whitecolor, strokeWidth: 0.5,)),
                  )
                  :
                  InkWell( 
                    onTap: (){
                      ApplyReviewHandler(myState);
                    },
                    child: Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8.0)),
                    child: Text("Submit", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.normal),),
                  ),
                  )
                ],
              )

              ],
            )))
          );
        }
      )
    );
 }
  );

 } 
}
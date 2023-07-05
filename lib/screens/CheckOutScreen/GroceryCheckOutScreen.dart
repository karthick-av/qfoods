
import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/CustomSnackBar.dart';
import 'package:qfoods/constants/Messages.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/CheckOutModel.dart';
import 'package:qfoods/model/GroceryCartModel.dart';
import 'package:qfoods/screens/GroceryCartScreen/GroceryCartScreen.dart';
import 'package:qfoods/screens/Order_Success_Screen/Order_Success_Screen.dart';
import 'package:qfoods/widgets/ShimmerContainer.dart';

import 'package:http/http.dart' as http;
import 'package:scroll_to_index/scroll_to_index.dart';

class GroceryCheckOutScreen extends StatefulWidget {
 final CheckOutModel? checkOut;
   const GroceryCheckOutScreen({super.key, required this.checkOut});

  @override
  State<GroceryCheckOutScreen> createState() => _GroceryCheckOutScreenState();
}

class _GroceryCheckOutScreenState extends State<GroceryCheckOutScreen> {
  
  int payment_id = 0;
bool payment_method_error = false;

  bool order_loading = false;

bool loading = false;
CheckouttotalModel? _checkouttotal;
String? bottombtn = "";
final scrollDirection = Axis.vertical;

 TextEditingController couponController = TextEditingController();

  late AutoScrollController controller;

  final formGlobalKey = GlobalKey < FormState > ();
void initState(){
  controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
 WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  CheckOutHandler();
    });
  super.initState();
}

void dispose(){
  controller?.dispose();
  couponController?.dispose();
  super.dispose();
}

Future<void> ApplyCouponHandler() async{
  try{
    context.loaderOverlay.show();

            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }


    dynamic data = {
      "user_id": "1",
      "latitude": widget.checkOut?.latitude?.toString(),
      "longitude": widget.checkOut?.longitude?.toString(),
      "code": couponController.value.text
    };
 var response = await http.post(Uri.parse(ApiServices.apply_grocery_coupon), body: data);
 context.loaderOverlay.hide();
   if(response.statusCode == 200){
      final responsebody = json.decode(response.body);
      setState(() {
        loading = false;
      });
      if(responsebody["message"] != null){
       CustomSnackBar().ErrorMsgSnackBar(responsebody["message"]);
      }else{
        print(responsebody);
      couponController.clear();
      
        CheckouttotalModel checkOut_total = CheckouttotalModel.fromJson(responsebody);
        _checkouttotal = checkOut_total;
            bottombtn = "total";
       
        setState(() { });
               
      }
   }
  }catch(e){
 context.loaderOverlay.hide();
  }
}


Future<void> CreateOrderHandler() async{
  if(payment_id == 0){
    await controller.scrollToIndex(2,
        preferPosition: AutoScrollPosition.begin);

payment_method_error = true;
setState(() {
  });

                          return;
}
 final cartProvider = Provider.of<GroceryCartProvider>(context, listen: false);
  
  setState(() {
    
payment_method_error = false;
    order_loading =true;
  });
try{
  final data = {
"user_id": "1", "latitude": widget?.checkOut?.latitude?.toString() ?? "0",
 "longitude": widget?.checkOut?.longitude?.toString() ?? "", "address1": widget?.checkOut?.address1?.toString() ?? "",
  "address2": widget?.checkOut?.address2?.toString() ?? "","landmark": widget?.checkOut?.landMark?.toString() ?? "",
   "alternate_phone_number": widget?.checkOut?.alternate_phone_number?.toString() ?? "", 
   "instructions": widget?.checkOut?.instructions?.toString() ?? "",
   "payment_id": payment_id?.toString() ?? "0",
   "code": _checkouttotal?.couponCode ?? ''
  };

    var response = await http.post(Uri.parse(ApiServices.grocery_create_order), body: data);
    print(response.statusCode);
     setState(() {
    order_loading =false;
  });
    if(response.statusCode == 200){
      cartProvider.AddCartData(GroceryCartModel(total: "0", items: []));
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => 
              OrderSuccessScreen()),
            );
    }else{
      CustomSnackBar().ErrorSnackBar();
    }
}
catch(e){
  
      CustomSnackBar().ErrorSnackBar();
  setState(() {
    order_loading =false;
  });
}
}

Future<void> CheckOutHandler() async{
  print("object");
  setState(() {
    loading = true;
  });
try{
  
dynamic jsonMap = {
      "user_id": "1",
      "latitude": widget.checkOut?.latitude?.toString(),
      "longitude": widget.checkOut?.longitude?.toString()
    };
print(ApiServices.grcoery_check_out);
    print(jsonMap);
       var header ={
  'Content-type': 'application/json'
 };

    var response = await http.post(Uri.parse(ApiServices.grcoery_check_out), body: jsonMap);
    
    if(response.statusCode == 200){
      final responsebody = json.decode(response.body);
      setState(() {
        loading = false;
      });
      if(responsebody["message"] != null){
         if(responsebody["message"] == "out_of_location"){
          print(responsebody);
          setState(() {
            bottombtn = "out_of_location";
          });
         }
      }else{
        CheckouttotalModel checkOut_total = CheckouttotalModel.fromJson(responsebody);
        _checkouttotal = checkOut_total;
            bottombtn = "total";
       
        setState(() { });
       
      }
    }
      }
  catch(err){
    print(err);
 setState(() {
    loading = false;
  });
  }
 
}


Future<void> UpdateQuantityHandler(dynamic data) async{
  print(data);
  print(ApiServices.grocery_checkout_update_quantity);
final cart_ = Provider.of<GroceryCartProvider>(context, listen: false);
  
  cart_.AddLoadingid(data!["cart_id"] ?? '');
   
 try{
  
    var response = await http.post(Uri.parse(ApiServices.grocery_checkout_update_quantity), body: data);
    cart_.AddLoadingid("");
    if(response.statusCode == 200){
      final responseBody = jsonDecode(response.body);
       if(responseBody?["message"] == Messages.Maximum_quantity){
         CustomSnackBar().MaximumQuantitySnackBar();
      }
    if(responseBody["total"] != null){
        CheckouttotalModel total =  CheckouttotalModel.fromJson(responseBody["total"]);
        if(total.total != null){
          setState(() {
            _checkouttotal = total;
          });
        }
      }

      if(responseBody["cart"] != null){
        if(responseBody["cart"]["items"] != null){
            if(responseBody["cart"]["items"]?.length == 0){
        cart_.AddCartData(GroceryCartModel(items: [], total: "0"));
       
Navigator.of(context).pop();
   return;   
        }
          GroceryCartModel _cartModel = GroceryCartModel.fromJson(responseBody["cart"] ?? []);
          cart_.AddCartData(_cartModel);
        }
      }


    }
    print(data);
}
catch(e){
cart_.AddLoadingid("");
}
}

Future<void>DeleteProductHandler(dynamic data) async{
final cart_ = Provider.of<GroceryCartProvider>(context, listen: false);
  print(data);
  cart_.AddLoadingid(data!["cart_id"][0]?.toString() ?? '');

try{
  print("ggg");
    var header ={
  'Content-type': 'application/json'
 };
  var jsonString = json.encode(data);
   
    final response = await http.delete(Uri.parse(ApiServices.grocery_checkout_delete_product), body: jsonString, headers: header);
   if(response.statusCode == 200){
      final responseBody = jsonDecode(response.body);
       if(responseBody?["message"] == Messages.Maximum_quantity){
         CustomSnackBar().MaximumQuantitySnackBar();
      }
    if(responseBody["total"] != null){
        CheckouttotalModel total =  CheckouttotalModel.fromJson(responseBody["total"]);
        if(total.total != null){
          setState(() {
            _checkouttotal = total;
          });
        }
      }

      if(responseBody["cart"] != null){
        if(responseBody["cart"]["items"] != null){
            if(responseBody["cart"]["items"]?.length == 0){
        cart_.AddCartData(GroceryCartModel(items: [], total: "0"));
       
Navigator.of(context).pop();
   return;   
        }
          GroceryCartModel _cartModel = GroceryCartModel.fromJson(responseBody["cart"] ?? []);
          cart_.AddCartData(_cartModel);
        }
      }


    }    
   
        
}
catch(e){
  print(e);
}
}

Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => 
              GroceryCartScreen()),
            );
        
  return true;
  }

Widget OutOfLocation(){
  return SlideInUp(
    animate: bottombtn == "out_of_location",
    child: Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(130),
      padding: const EdgeInsets.all(20.0),
      
         decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            color: const Color(0xFFB0CCE1).withOpacity(0.90),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning, color: AppColors.primaryColor, size: ScreenUtil().setSp(23),),
                              SizedBox(width: 10.0,),
                              Container(
                                alignment: Alignment.topLeft,
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Does not deliver to your location",
                                     overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w600),
                                    ),
                                      Text("This location is outside the outlet's delivery area",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                style: TextStyle(color: AppColors.lightgreycolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.normal),
                                )
                       
                                  ],
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8.0)),
                              child: Text("Change delivery address", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.bold),),
                            ),
                            
                          ),
                          
                          ],
                      ),
    ),
  );
}


Widget PlaceOrder(){
  return   SlideInUp(
    animate: bottombtn == "total",
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: (){
          CreateOrderHandler();
        },
                              child: Container(
                                height: ScreenUtil().setHeight(40),
                                width: MediaQuery.of(context).size.width * 0.90,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8.0)),
                                child: Text("Place Order", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.bold),),
                              ),
                              
                            ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true);
       double width = MediaQuery.of(context).size.width;
        int unavailable = cartProvider?.CartData?.items?.where((e) => e?.status == 0)?.length ?? 0;

  //    bottomSheet: bottombtn == "total" ? PlaceOrder() : (bottombtn == "out_of_location" ? OutOfLocation() : SizedBox()),
       
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.whitecolor,
           bottomSheet: unavailable > 0 ? unavailableContainer(width) : (bottombtn == "total" ? PlaceOrder() : (bottombtn == "out_of_location" ? OutOfLocation() : SizedBox())),
         body: GestureDetector(
            onTap: (){
              FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
         currentFocus.focusedChild?.unfocus();
          }
          },
           child: SafeArea(
                child: LoaderOverlay(
                   useDefaultLoading: false,
                 overlayWidget: Center(
            child: SizedBox(width: ScreenUtil().setSp(25), height: ScreenUtil().setSp(25), child: CircularProgressIndicator(
                                                            strokeWidth: 1.0,
                                                            color: AppColors.primaryColor,),)
                 ),
                
                  child: Column(
                    children: [
                       Container(
                       padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 0.8, color: Color(0XFFF0F0F0)))
                        ),
                         child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                      //            Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(builder: (context) => 
                      //     CartScreen()),
                      // );
                     // CheckOutHandler();
                              },
                              child: Icon(Icons.arrow_back, color: AppColors.blackcolor, size: ScreenUtil().setSp(25),),
                            
                            ),
                            SizedBox(width: ScreenUtil().setSp(10),),
                            Text("CheckOut", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                          ],
                      ),
                       ),
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.primaryColor,
                          onRefresh: () async{
                            await CheckOutHandler();
                            await cartProvider.getCart();
                          },
                          child: Form(
                            key: formGlobalKey,
                            child: SingleChildScrollView(
                              scrollDirection: scrollDirection,
                                                controller: controller,
                              physics:  AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                loading ? Loading(context)
                                : Column(
                                children: [
                                Center(
                                  child: Container(
                                    width: width * 0.90,
                                      decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 20,
                                        color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                      ),
                                    ],
                                  ),
                                 
                                    child:  ListView.builder(
                                  shrinkWrap: true,
                                    itemCount: cartProvider?.CartData?.items?.length ?? 0,
                                   physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: ((context, index) {
                                   return Container(
                                           padding: const EdgeInsets.all(5.0),
                              child: Slidable(
                                                    startActionPane: ActionPane(
                                    extentRatio: 0.25,
                                     motion: const ScrollMotion(),
                                        children:  [
                                              // A SlidableAction can have an icon and/or a label.
                                              SlidableAction(
                                                onPressed: ((context) {
                             DeleteProductHandler({
                              "user_id": "1",
                              "cart_id": [cartProvider?.CartData?.items?[index]?.cartId]
                            });
                                                }),
                                                backgroundColor: Color(0xFFFE4A49),
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                                label: 'Delete',
                                              )
                                            ],
                                   ) ,
                                   endActionPane: ActionPane(
                                    extentRatio: 0.25,
                                     motion: const ScrollMotion(),
                                        children:  [
                                              // A SlidableAction can have an icon and/or a label.
                                              SlidableAction(
                                                 onPressed: ((context) {
                             DeleteProductHandler({
                              "user_id": "1",
                              "cart_id": [cartProvider?.CartData?.items?[index]?.cartId]
                            });
                                                }),
                                                backgroundColor: Color(0xFFFE4A49),
                                                foregroundColor: Colors.white,
                                                icon: Icons.delete,
                                                label: 'Delete',
                                              )
                                            ],
                                   ) ,
                                                
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                     children: [
                                                      Container(
                                                    margin: const EdgeInsets.only(bottom: 2),
                                                          width: width * 0.37,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                           if(cartProvider?.CartData?.items?[index]?.variantid != null)
                                                          Text("${cartProvider?.CartData?.items?[index]?.productName ?? ""}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500,color: AppColors.blackcolor),),
                                                       
                                                        Container(
                                                          width: width /2,
                                                          child:  Text("${cartProvider?.CartData?.items?[index]?.name ?? ""}",
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                           style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11), fontWeight: FontWeight.w500,color: AppColors.blackcolor.withOpacity(0.7)),)
                                                        ,
                                                        ),
                                                        Text("Rs ${cartProvider?.CartData?.items?[index]?.price ?? ""}", style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11), fontWeight: FontWeight.w500,color: AppColors.blackcolor.withOpacity(0.7)),)
                                                           ,
                                                           
                                                           ],
                                                      ),
                                                    ),
                                                                   cartProvider?.CartData?.items?[index]?.status == 0
                                             ?
                                             Container(
                                                width: width * 0.30,
                                               alignment: Alignment.center,
                                               child: Container(
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: Color(0XFFD3D3D3))
                                                ),
                                                child: Text("unavailable", style: TextStyle(color: Color(0XFFbdbdbd), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)),),
                                               ),
                                             )
                                             :
                                      
                                                 ((cartProvider?.CartData?.items?[index]?.cartId?.toString() == cartProvider.loadingId) ? 
                                                  Container(
                                                    width: width * 0.33,
                                                alignment: Alignment.center,
                                                    child: Container(
                                                          child: SizedBox(width: ScreenUtil().setSp(20), height: ScreenUtil().setSp(20), child: CircularProgressIndicator(
                                                            strokeWidth: 1.0,
                                                            color: AppColors.primaryColor,),)),
                                                  )
                                                 :   Container(
                                                  width: width * 0.33,
                                               
                                                          child: Row(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap: (){
                                                                 
                                                                  if(cartProvider?.CartData?.items?[index]?.variantid != null){
                                                        UpdateQuantityHandler({
                                                          "cart_id": cartProvider?.CartData?.items?[index]?.cartId?.toString() ?? "",
                                                          "type": "minus",
                                                          "user_id": "1",
                                                          "product_type": "variant",
                                                        "latitude": widget.checkOut?.latitude?.toString(),
                                                                    "longitude": widget.checkOut?.longitude?.toString()
                                                                   });
                                                      
                                                       }else{
                                              UpdateQuantityHandler({
                                                          "cart_id": cartProvider?.CartData?.items?[index]?.cartId?.toString() ?? "",
                                                          "type": "minus",
                                                          "user_id": "1",
                                                          "product_type": "",
                                                        "latitude": widget.checkOut?.latitude?.toString(),
                                                                    "longitude": widget.checkOut?.longitude?.toString()
                                                        });
                                                       }
                                                                },
                                                                child: Container(
                                                                   decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(4),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                offset: Offset(0, 4),
                                                blurRadius: 20,
                                                color: const Color(0xFFB0CCE1).withOpacity(0.40),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  padding: const EdgeInsets.all(5),
                                                                  child: Icon(Icons.remove, size: ScreenUtil().setSp(22.0), color: AppColors.primaryColor,)),
                                                                
                                                              ),
                                                              Container(
                                                                
                                                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                                                child: Text("${cartProvider?.CartData?.items?[index]?.quantity ?? ""}", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),),
                                                              ),
                                                                InkWell(
                                                                    onTap: (){
                                                                  
                                                        if(cartProvider?.CartData?.items?[index]?.variantid != null){
                                                        UpdateQuantityHandler({
                                                          "cart_id": cartProvider?.CartData?.items?[index]?.cartId?.toString() ?? "",
                                                          "type": "plus",
                                                          "user_id": "1",
                                                          "product_type": "variant",
                                                        "latitude": widget.checkOut?.latitude?.toString(),
                                                                    "longitude": widget.checkOut?.longitude?.toString()
                                                        });
                                                      
                                                       }else{
                                              UpdateQuantityHandler({
                                                          "cart_id": cartProvider?.CartData?.items?[index]?.cartId?.toString() ?? "",
                                                          "type": "plus",
                                                          "user_id": "1",
                                                          "product_type": "",
                                                        "latitude": widget.checkOut?.latitude?.toString(),
                                                                    "longitude": widget.checkOut?.longitude?.toString()
                                                        });
                                                       }                   },
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                    color: Colors.white,
                                                                    borderRadius: BorderRadius.circular(4),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                offset: Offset(0, 4),
                                                blurRadius: 20,
                                                color: const Color(0xFFB0CCE1).withOpacity(0.40),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  padding: const EdgeInsets.all(5),
                                                                  child: Icon(Icons.add, size: ScreenUtil().setSp(20.0), color: AppColors.primaryColor,)),
                                                                
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                     ],
                                                    ),
                              
                                                                    cartProvider?.CartData?.items?[index]?.status == 0
                                             ?  IconButton(onPressed: (){
                                               DeleteProductHandler({
                                                "user_id": "1",
                                                "cart_id": [cartProvider?.CartData?.items?[index]?.cartId]
                                              });  
                                             }, icon: Icon(Icons.delete, color: AppColors.greycolor,size: ScreenUtil().setSp(20),))
                                              : 
                                                        Text("Rs ${cartProvider?.CartData?.items?[index]?.total ?? "" }", style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w600,color: AppColors.blackcolor),)
                                                  ],
                                                ),
                                ),
                              ),
                                          );
                                 })),
                                  ),
                                ),
                                        
                                  Center(
                                  child: AutoScrollTag(
                                     key: ValueKey(2),
                                                controller: controller,
                                                index: 2,
                                    child: Container(
                                      margin:  EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                      padding: const EdgeInsets.all(14.0),
                                      width: width * 0.90,
                                        decoration: BoxDecoration(
                                      color: Colors.white,
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
                                        Text("Payment Method", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),)
                                      ,ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _checkouttotal?.paymentMethod?.length ?? 0,
                                        itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                           Checkbox(
                                                activeColor: AppColors.primaryColor,
                                                hoverColor: AppColors.primaryColor,
                                              
                                                value: payment_id == _checkouttotal?.paymentMethod?[index]?.paymentId, 
                                                onChanged: ((value) {
                                                    payment_id = value! ? (_checkouttotal?.paymentMethod?[index]?.paymentId ?? 0) : 0;
                                                      payment_method_error = false;
                                                  setState(() {
                                                  });
                                               }))
                                  
                                               ,Text(_checkouttotal?.paymentMethod?[index]?.paymentName ?? '',
                                               style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13)),
                                               )
                                          ],
                                        );
                                      })
                                  
                                  
                                  ,
                                  BounceInLeft(
                                    animate: payment_method_error,
                                    child:   Column(
                                    
                                      children: [
                                    
                                             SizedBox(height: ScreenUtil().setHeight(10),),
                                    
                                            Text("Please..Select the Payment Method", style: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(12)),),
                                    
                                      ],
                                    
                                    ),
                                  )
                                  
                                  
                                      ],
                                    ),
                                    ),
                                  ),
                                 ),   
                                        
                                   (_checkouttotal?.couponAmount != null && _checkouttotal?.couponCode != null)
                                   ?
                                   Center(
                                                
                                      child: Container(
                                          margin:  EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                          padding: const EdgeInsets.all(14.0),
                                          width: width * 0.90,
                                            decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 20,
                                              color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                            ),
                                          ],
                                              
                                        ),
                                        child:    Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                         Row(
                                          children: [
                                             Text("'${_checkouttotal?.couponCode?.toUpperCase()}'",
                                          style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w600),
                                          ),
                                            SizedBox(width: 5),
                                           Text("Applied",
                                          style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.5), fontWeight: FontWeight.w600),
                                          )
                                          ]
                                         ),
                                         SizedBox(height: 5),
                                         Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                             Text("  Rs ${_checkouttotal?.couponAmount}",
                                          style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(width: 5),
                                            Text("Coupon Savings",
                                          style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)),
                                          )
                                          ],
                                         )
                                        ]
                                      ),
                                              
                                       InkWell(
                                              onTap: (){
                                                CheckOutHandler();
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                child: Text("Remove", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w600))),
                                            )
                                     ])
                                      ))
                                    
                                   : 
                                                
                                     Center(
                                                
                                      child: Container(
                                          margin:  EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                          padding: const EdgeInsets.all(14.0),
                                          width: width * 0.90,
                                            decoration: BoxDecoration(
                                          color: Colors.white,
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
                                                   Text("Coupon", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),)
                                   
                                   , 
                                   SizedBox(height: 10),
                                   
                                   Row(
                                     children: [
                                       Flexible(
                                         child: TextFormField(
                                           validator: ((value){
                              if(value == "") return "Coupon Code is required";
                              return null;
                            }),
                                            
                                                  controller: couponController,
                                          
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                               
                                                 decoration:  InputDecoration(
                                                               labelText: 'Enter Coupon',
                                                               contentPadding: EdgeInsets.all(8),
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
                                       ),
                                            InkWell(
                                              onTap: (){
                                                print('hhh');
                                                 if (!formGlobalKey.currentState!.validate()) {
                              return;
                            }
                                                ApplyCouponHandler();
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(left: 10),
                                                child: Text("Apply", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w600))),
                                            )
                                     ],
                                   )
                                        ]
                                        
                                        
                                        
                                        ),
                                      )
                                     ),     
                                 Center(
                                  child: Container(
                                    margin:  EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                    padding: const EdgeInsets.all(14.0),
                                    width: width * 0.90,
                                      decoration: BoxDecoration(
                                    color: Colors.white,
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
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Sub Total", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                          Text("Rs ${_checkouttotal?.subTotal ?? ''}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                        
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
                                               Text("${_checkouttotal?.kms ?? ''} kms", style: TextStyle(color: AppColors.lightgreycolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11.0), fontWeight: FontWeight.normal),),
                                           
                                            ],
                                          ),
                                          Text("Rs ${_checkouttotal?.deliveryCharges ?? ''}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                        
                                        ],
                                      ),
                                       if(_checkouttotal?.couponAmount != null)
                                     Column(
                                      children: [
                                         SizedBox(height: ScreenUtil().setSp(20.0),),
                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Coupon", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                              SizedBox(height: 4,),
                                            //  if(_checkouttotal?.kms != null)
                                               Text("${_checkouttotal?.couponCode ?? ''} ", style: TextStyle(color: AppColors.lightgreycolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11.0), fontWeight: FontWeight.normal),),
                                           
                                            ],
                                          ),
                                          Text("Rs ${_checkouttotal?.couponAmount ?? ''}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                        
                                        ],
                                      ),
                                      ]
                                     ),
                                      SizedBox(height: ScreenUtil().setSp(20.0),),
                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Grand Total", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                          Text("Rs ${_checkouttotal?.total ?? ''}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                        
                                        ],
                                      )
                                    ],
                                  ),
                                  ),
                                 )
                                  
                                ],
                            ),
                              ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),
         ),
          ),

      if(order_loading)
            Opacity(
        opacity: 0.7,
        child: ModalBarrier(dismissible: false, color: Colors.black),
      ),
      if(order_loading)
       Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryColor,
        ),
      ),
        ],
      ),
    );
  }


  Widget Loading(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(children: [
         ShimmerContainer(ScreenUtil().setHeight(80), width * 0.90, 10),
         SizedBox(height: ScreenUtil().setSp(10),),
         ShimmerContainer(ScreenUtil().setHeight(80), width * 0.90, 10),
         SizedBox(height: ScreenUtil().setSp(20),),
          ShimmerContainer(ScreenUtil().setHeight(120), width * 0.90, 10),
         SizedBox(height: ScreenUtil().setSp(20),),
          ShimmerContainer(ScreenUtil().setHeight(120), width * 0.90, 10)
      ]),
    );
  }

  Widget unavailableContainer(double width){
  return Container(
      height: ScreenUtil().setHeight(58.0),
      width: width,
      padding:  const EdgeInsets.all(10),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning, color: AppColors.primaryColor, size: ScreenUtil().setSp(25),),
                      SizedBox(width: 10,),
                      Column(
                        children: [
                          Container(
                            width: width * 0.80,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
  maxLines: 3,
                              "Some Items Currently are not available", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.bold),))
                       
                       ,
                       SizedBox(height: 5,),
                        Container(
                            width: width * 0.80,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
  maxLines: 3,
                              "Please remove items from Cart", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11), fontWeight: FontWeight.normal),))
                       
                        ],
                      )
                    ],
                  ),
  );
}
}
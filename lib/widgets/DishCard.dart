import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/CartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/RestaurantAndDishesModel.dart';
import 'package:qfoods/widgets/DishVariantBottomSheet.dart';

class DishCard extends StatelessWidget {
  final SearchResults? dish;
  final int? rstatus;
  const DishCard({super.key, required this.dish, required this.rstatus});


  Widget unAvailable(){
    return Container(
       // margin:  EdgeInsets.only(right: ScreenUtil().setHeight(14.0)),
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0 ),
                                    decoration: BoxDecoration(
                                      color: AppColors.whitecolor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(width: 1, color: AppColors.greycolor),
                                         boxShadow: [
                                                        BoxShadow(
                                                          offset: Offset(0, 4),
                                                          blurRadius: 20,
                                                          color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                                        ),
                                                      ],
                                    ),
      child: Text("Unavailable",
      style: TextStyle(color: Colors.grey[800], fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true).CartData.items;
    final cart_provider =  Provider.of<CartProvider>(context, listen: true);
       bool?   isExist = cartProvider?.any((el) => (el?.id == dish?.dishId)) ?? false;
  final  CartProduct = isExist ? cartProvider!.firstWhere((element) => element?.id == dish?.dishId) : null;
  
print(CartProduct?.name);
    return Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.5, color: AppColors.lightgreycolor))
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${dish?.name ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w600, color: AppColors.blackcolor,fontSize: ScreenUtil().setSp(14.0)),
                                ),
                                SizedBox(height: 5.0,),
                                  Row(
                                    children: [
                                      Text(
                                      "Rs ${dish?.price ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                                ),

                                if(dish?.salePrice != "" && dish?.salePrice != 0)
                                
                                 Container(
                                  margin: const EdgeInsets.only(left: 10),
                                   child: Text(
                                        "Rs ${dish?.salePrice ?? ''}",
                                maxLines: 2,style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.greycolor, fontSize: ScreenUtil().setSp(14.0)),
                                ),
                                 ),
                                    ],
                                  ),
                                 SizedBox(height: 5.0,),
                                 Text("${dish?.description ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(12.0)),
                                ),
                                  ],
                                ),
 ( 
   cart_provider.loadingId == dish?.dishId?.toString() ?
                                Container(
                                  margin:  EdgeInsets.only(right: ScreenUtil().setSp(20)),
                                  child: SizedBox(width: ScreenUtil().setSp(20), height: ScreenUtil().setSp(20), child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    color: AppColors.primaryColor,),))
                                    :
                             
  
  isExist 
                                  ? Container(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                        cart_provider.updateQuantity(CartProduct?.cartId?.toString() ?? '', "minus", '${CartProduct!.id}');
                                        },
                                        child: Icon(Icons.remove, size: ScreenUtil().setSp(22.0), color: AppColors.primaryColor,),
                                        
                                      ),
                                     
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                        child: Text(CartProduct!.quantity.toString(), style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                      ),
                                        InkWell(
                                            onTap: (){
                                 cart_provider.updateQuantity(CartProduct?.cartId?.toString() ?? '', "plus", '${CartProduct!.id}');
                                               },
                                        child: Icon(Icons.add, size: ScreenUtil().setSp(20.0), color: AppColors.primaryColor,),
                                        
                                      ),
                                    ],
                                  ),
                                )
                               :
                              
                                   ( dish?.image == ""
                                ?
                               (
                                (dish?.status == 0 || rstatus == 0)
                                ? unAvailable()
                                :
                                 InkWell(
                                  onTap: (){
                                     print("object");
                                     print(dish?.variant == "true" && (dish?.dishVariants?.length ?? 0) > 0);
                                    if(dish?.variant == "true" && (dish?.dishVariants?.length ?? 0) > 0){
DishVariantBottomSheet().dishVariantModal(dish, rstatus,context);
                                    }else{
                                         Provider.of<CartProvider>(context, listen: false).addCart({
                                   "user_id": 1,
                                   "product_id": dish?.dishId
                                 });
                                    }
                                  },
                                  child: Container(
                                    margin:  EdgeInsets.only(right: ScreenUtil().setHeight(14.0)),
                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0 ),
                                    decoration: BoxDecoration(
                                      color: AppColors.whitecolor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(width: 1, color: AppColors.primaryColor),
                                         boxShadow: [
                                                        BoxShadow(
                                                          offset: Offset(0, 4),
                                                          blurRadius: 20,
                                                          color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                                        ),
                                                      ],
                                    ),
                                    child: Text("ADD", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14.0)),),
                                  )
                                ))
                                : Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Stack(
                                    alignment: new Alignment(0.0, 1.5),
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child:  (dish?.status == 0 || rstatus == 0)
                               
                                          ? ColorFiltered(child: Image.network("${dish?.image ?? ''}", fit: BoxFit.cover,height: ScreenUtil().setHeight(80.0), width: ScreenUtil().setWidth(100.0),),
                                            colorFilter: ColorFilter.mode(
    Colors.grey,
    BlendMode.saturation,
  ),
                                          )
                                          : Image.network("${dish?.image ?? ''}", fit: BoxFit.cover,height: ScreenUtil().setHeight(80.0), width: ScreenUtil().setWidth(100.0),)),
                                   (
                                   (dish?.status == 0 || rstatus == 0)
                               
                                    ? unAvailable()
                                    : 
                                   
                                    InkWell(
                                       onTap: (){
                                        print("object");
                                      print(dish?.variant == "true");
                                   if(dish?.variant == "true" && (dish?.dishVariants?.length ?? 0) > 0){
DishVariantBottomSheet().dishVariantModal(dish,rstatus,context);
                                    }else{
                                         Provider.of<CartProvider>(context, listen: false).addCart({
                                   "user_id": 1,
                                   "product_id": dish?.dishId
                                 });
                                    }
                                  },
                                      child:  Container(
                                        
                                       padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0 ),
                                                                     decoration: BoxDecoration(
                                                                        color: AppColors.whitecolor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(width: 1, color: AppColors.primaryColor),
                                         boxShadow: [
                                                            BoxShadow(
                                                              offset: Offset(0, 4),
                                                              blurRadius: 20,
                                                              color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                                            ),
                                                          ],
                                      ),
                                        child: Text("ADD", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14.0)),)),
                                    )
                                  )
                                    ],
                                  ),
                                )))
                              ],
                            )
                          );
  }
}
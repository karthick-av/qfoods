import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/CartProvider.dart';
import 'package:qfoods/Provider/SelectedVariantProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/CartModel.dart';
import 'package:qfoods/model/SelectedVariantModel.dart';
import 'package:qfoods/widgets/CartDishVariantBottomSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCard extends StatelessWidget {
  final int index;
  const CartCard({super.key,  required this.index});



  @override
  Widget build(BuildContext context) {

     double width = MediaQuery.of(context).size.width;
   final cartProvider = Provider.of<CartProvider>(context, listen: true);

    return Container(
                         margin:  EdgeInsets.only(top: index == 0 ? 0.0 : 20.0),
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
                          child: Slidable(
                             startActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        onPressed: ((context) async{
           final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
  if(user_id == null) return;
           cartProvider.deleteProduct({
            "user_id": user_id?.toString(),
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
         onPressed: ((context) async{
           final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
  if(user_id == null) return;
           cartProvider.deleteProduct({
            "user_id": user_id?.toString(),
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
                            child: Container(
                             padding: const EdgeInsets.all(10.0),
                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                               Row(
                                children: [
   Container(
                                  margin: const EdgeInsets.only(bottom: 2),
                                        width: width * 0.40,
                                  
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${cartProvider?.CartData?.items?[index]?.name ?? ""}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500,color: AppColors.blackcolor),),
                                     
                                      Container(
                                        width: width /2,
                                        child:  Text("${cartProvider?.CartData?.items?[index]?.restaurantName ?? ""}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                         style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11), fontWeight: FontWeight.w500,color: AppColors.blackcolor.withOpacity(0.7)),)
                                      ,
                                      ),
                                      Text("Rs ${cartProvider?.CartData?.items?[index]?.price ?? ""}", style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11), fontWeight: FontWeight.w500,color: AppColors.blackcolor.withOpacity(0.7)),)
                                         ,
                                     if((cartProvider?.CartData?.items?[index]?.variants?.length ?? 0) > 0 && (cartProvider?.CartData?.items?[index]?.dishVariants?.length ?? 0) > 0)
                                         InkWell(
                                          onTap: (){
                          List<SelectedVariantModel> SelectedVariant = [];
                                            cartProvider?.CartData?.items?[index]?.variants?.forEach((e) => SelectedVariant.add(SelectedVariantModel(VariantId: e?.variantId?.toString() ?? '', variantItemId: e?.variantItemId?.toString() ?? '')));
                                            Provider.of<SelectedVariantProvider>(context, listen: false).addCartVariants(SelectedVariant, cartProvider?.CartData?.items?[index]?.dishVariants,cartProvider?.CartData?.items?[index]?.price ?? 0);
                          
                                            CartDishVariantBottomSheet().CartVariantModal(cartProvider?.CartData?.items?[index], context);
                                          },
                                          child: Row(
                                            children: [
                                      Text("Customize", style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11), fontWeight: FontWeight.w500,color: AppColors.blackcolor.withOpacity(0.7)),)
                          ,
                                         Icon(Icons.arrow_drop_down_rounded)     
                                            ],
                                          ),
                                         )
                                         
                                         ],
                                    ),
                                  ),
                               
                              (  

(

(
(cartProvider?.CartData?.items?[index]?.variants?.length ?? 0) > 0 && cartProvider?.CartData?.items?[index]?.variantItemsStatus == 0 ) ?
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
: (cartProvider?.CartData?.items?[index]?.status == 0
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
                               (
                               (cartProvider?.CartData?.items?[index]?.id?.toString() == cartProvider.loadingId) ? 
                                Container(
                                  alignment: Alignment.center,
                                   width: width * 0.30,
                               
                                      child: SizedBox(width: 20, height: ScreenUtil().setSp(20), child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        color: AppColors.primaryColor,),))
                               :   Container(
                                width: width * 0.30,
                                        child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                 cartProvider.updateQuantity(cartProvider?.CartData?.items?[index]?.cartId?.toString() ?? '', "minus", '${cartProvider?.CartData?.items?[index]?.id?.toString()}');
                                        
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
                                                 cartProvider.updateQuantity(cartProvider?.CartData?.items?[index]?.cartId?.toString() ?? '', "plus", '${cartProvider?.CartData?.items?[index]?.id?.toString()}');
                                        
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
                                                child: Icon(Icons.add, size: ScreenUtil().setSp(20.0), color: AppColors.primaryColor,)),
                                              
                                            ),
                                          ],
                                        ),
                                      )
                               ))
 
)


                                                             
                               
                               )
                                ],
                               ),
                               cartProvider?.CartData?.items?[index]?.status == 0
                               ?  IconButton(onPressed: () async{
                                 final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
  if(user_id == null) return;
                                 cartProvider.deleteProduct({
            "user_id": user_id?.toString(),
            "cart_id": [cartProvider?.CartData?.items?[index]?.cartId]
          });  
                               }, icon: Icon(Icons.delete, color: AppColors.greycolor,size: ScreenUtil().setSp(20),))
                                :      Text("Rs ${cartProvider?.CartData?.items?[index]?.total ?? "" }", style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w600,color: AppColors.blackcolor),)
                                ],
                              ),
                            ),
                          ),
                        );  
   }
}
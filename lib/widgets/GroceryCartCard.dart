import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroceryCartCard extends StatelessWidget {
  final int index;
  
  const GroceryCartCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
         double width = MediaQuery.of(context).size.width;
         final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true);
  

         return Container(
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
                   
                          margin:  EdgeInsets.only(top: index == 0 ? 0.0 : 20.0),
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
                            child: Padding(
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
                                     if(cartProvider?.CartData?.items?[index]?.variantid != null)
                                       Text("${cartProvider?.CartData?.items?[index]?.productName ?? ""}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500,color: AppColors.blackcolor),),
                                        
                                        Text("${cartProvider?.CartData?.items?[index]?.name ?? ""}", maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500,color: AppColors.blackcolor),),
                                        Text("Rs ${cartProvider?.CartData?.items?[index]?.price ?? ""}", style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(10), fontWeight: FontWeight.w500,color: AppColors.blackcolor.withOpacity(0.7)),)
                                     
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
                               ((cartProvider?.CartData?.items?[index]?.variantid != null ? (cartProvider?.loadingId == 'v${cartProvider?.CartData?.items?[index]?.variantid}' ) : (cartProvider?.loadingId == cartProvider?.CartData?.items?[index]?.groceryId?.toString())) ? 
                                Container(
                                   width: width * 0.30,
                               alignment: Alignment.center,
                                  child: Container(
                                        child: SizedBox(width: ScreenUtil().setSp(20), height: ScreenUtil().setSp(20), child: CircularProgressIndicator(
                                          strokeWidth: 1.0,
                                          color: AppColors.primaryColor,),)),
                                )
                               :   Container(
                                width: width * 0.30,
                                       // width: width * 0.25,
                                       // color: AppColors.greycolor,
                                       // alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                             if(cartProvider?.CartData?.items?[index]?.variantid != null){
                                              cartProvider.updateVariantQuantity("${cartProvider?.CartData?.items?[index]?.cartId}", "minus", 'v${"${cartProvider?.CartData?.items?[index]?.variantid}"}');
                                            
                                             }else{
 cartProvider.updateQuantity(cartProvider?.CartData?.items?[index]?.cartId?.toString() ?? "", "minus", cartProvider?.CartData?.items?[index]?.groceryId?.toString() ?? "");
                                   
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
                                              cartProvider.updateVariantQuantity("${cartProvider?.CartData?.items?[index]?.cartId}", "plus", 'v${"${cartProvider?.CartData?.items?[index]?.variantid}"}');
                                            
                                             }else{
                                    cartProvider.updateQuantity(cartProvider?.CartData?.items?[index]?.cartId?.toString() ?? "", "plus", cartProvider?.CartData?.items?[index]?.groceryId?.toString() ?? "");
                                          
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
                                                child: Icon(Icons.add, size: ScreenUtil().setSp(20.0), color: AppColors.primaryColor,)),
                                              
                                            ),
                                          ],
                                        ),
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
                                :  
                                     Text("Rs ${cartProvider?.CartData?.items?[index]?.total ?? "" }", style:  TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w600,color: AppColors.blackcolor),)
                                ],
                              ),
                            ),
                          ),
                        );
 
  }
}
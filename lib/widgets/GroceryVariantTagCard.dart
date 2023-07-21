import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryHomeTagsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GroceryVariantTagCard extends StatelessWidget {
  final VariantsProducts variantsProducts;
  final  Products products;
  
  const GroceryVariantTagCard({super.key, required this.variantsProducts, required this.products});

  @override
  Widget build(BuildContext context) {
 final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true).CartData.items;
    final groceryProvider =  Provider.of<GroceryCartProvider>(context, listen: true);
       bool?   isExist = cartProvider?.any((el) => (el.groceryId == products?.groceryId) && (el?.variantid == variantsProducts?.id)) ?? false;
      final  CartVariant = isExist ? cartProvider!.firstWhere((element) => (element.groceryId ?? 0) == (products.groceryId ?? 0) && (element.variantid ?? 0) == (variantsProducts.id ?? 0)) : null;
     
     print(groceryProvider.loadingId);
             return Container(
      margin: const EdgeInsets.only(top: 10.0),
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
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                             variantsProducts!.image != ""
                             ? Image.network(variantsProducts!.image.toString(), height: ScreenUtil().setHeight(50.0), fit: BoxFit.contain,)
                                  : Container(
                                    height: ScreenUtil().setHeight(50.0),
                                    width: ScreenUtil().setHeight(50.0),
                                  ),
                                  
                                  Text(variantsProducts!.name.toString(), style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(12.0)),)
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                       Text("Rs ${variantsProducts!.price.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(12.0)),),
                                     
                                        SizedBox(width: 10.0,),
                                       if(variantsProducts!.salePrice != 0 && variantsProducts!.offers == "true")
                                          Text("${variantsProducts!.regularPrice.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(decoration: TextDecoration.lineThrough,color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(12.0)),),
                                     
                                    ],
                                  )
                                ],
                              ),

                              (
                                variantsProducts?.status == 0 ?
                                Container(
                                  width: ScreenUtil().setWidth(100),
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
   
                                 groceryProvider!.loadingId == 'v${variantsProducts!.id}'
                                ? Container(
                                  margin:  EdgeInsets.only(right: ScreenUtil().setSp(20)),
                                  child: SizedBox(width: ScreenUtil().setSp(20), height: ScreenUtil().setSp(20), child: CircularProgressIndicator(color: AppColors.primaryColor,),))
                                : (
                                  isExist 
                                  ? Container(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          groceryProvider.updateVariantQuantity(CartVariant!.cartId.toString(), "minus", 'v${variantsProducts!.id}');
                                        },
                                        child: Icon(Icons.remove, size: ScreenUtil().setSp(22.0), color: AppColors.primaryColor,),
                                        
                                      ),
                                     
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                        child: Text(CartVariant!.quantity.toString(), style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                      ),
                                        InkWell(
                                            onTap: (){
                                          groceryProvider.updateVariantQuantity(CartVariant!.cartId.toString(), "plus", 'v${variantsProducts!.id}');
                                        },
                                        child: Icon(Icons.add, size: ScreenUtil().setSp(20.0), color: AppColors.primaryColor,),
                                        
                                      ),
                                    ],
                                  ),
                                )
                               : GestureDetector(
                                onTap: () async{
                                   final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
  if(user_id == null) return;
                                Provider.of<GroceryCartProvider>(context, listen: false).addCart({
                                   "user_id": user_id?.toString(),
    "product_id": products!.groceryId,
    "variant_id": variantsProducts!.id
                                 });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                                  
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(5.0),
                                   // color: AppColors.primaryColor.withOpacity(0.3)
                                  ),
                                child: Text("add", style: TextStyle(color: AppColors.primaryColor, fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w400),),
                                )
                              )
                                )
                              )
                            ],
                          ),
                          );
        
  }
}
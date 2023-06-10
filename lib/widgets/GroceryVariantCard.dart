

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryCartModel.dart';
import 'package:qfoods/model/GrocerySearchModel.dart';
import 'package:qfoods/model/GroeryVariantItemModel.dart';

import 'dart:developer';

class GroceryVariantCard extends StatelessWidget {
  final GrocerySearchModel grocerySearchModelData;
  // ignore: non_constant_identifier_names
  final GroeryVariantItemModel VariantItem;
  
  const GroceryVariantCard({super.key, required this.grocerySearchModelData, required this.VariantItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true).CartData.items;
    final groceryProvider =  Provider.of<GroceryCartProvider>(context, listen: true);

        // var isExist = cartProvider!.any((element) => (element.groceryId ?? 0) == (grocerySearchModelData.groceryId ?? 0) && (element.variantid ?? 0) == (VariantItem.id ?? 0));
        // // ignore: non_constant_identifier_names
        // final  CartVariant = isExist ? cartProvider.firstWhere((element) => (element.groceryId ?? 0) == (grocerySearchModelData.groceryId ?? 0) && (element.variantid ?? 0) == (VariantItem.id ?? 0)) : null;
     

        bool?   isExist = cartProvider?.any((el) => (el.groceryId == grocerySearchModelData?.groceryId) && (el?.variantid == VariantItem?.id)) ?? false;
      final  CartVariant = isExist ? cartProvider!.firstWhere((element) => (element.groceryId ?? 0) == (grocerySearchModelData.groceryId ?? 0) && (element.variantid ?? 0) == (VariantItem.id ?? 0)) : null;
     
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
                             VariantItem.image != ""
                             ? Image.network(VariantItem.image.toString(), height: ScreenUtil().setHeight(50.0), fit: BoxFit.contain,)
                                  : Container(
                                    height: ScreenUtil().setHeight(50.0),
                                    width: ScreenUtil().setHeight(50.0),
                                  ),
                                  
                                  Text(VariantItem.name.toString(), style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(12.0)),)
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                       Text("Rs ${VariantItem.price.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(12.0)),),
                                     
                                        SizedBox(width: 10.0,),
                                       if(VariantItem.salePrice != 0 && VariantItem.offers == "true")
                                          Text("${VariantItem.regularPrice.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(decoration: TextDecoration.lineThrough,color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(12.0)),),
                                     
                                    ],
                                  )
                                ],
                              ),
                              (
                                  groceryProvider?.loadingId == 'v${VariantItem?.id}'
                                ? Container(
                                  margin:  EdgeInsets.only(right: ScreenUtil().setSp(20)),
                                  child: SizedBox(width: ScreenUtil().setSp(20), height: ScreenUtil().setSp(20), child: CircularProgressIndicator(color: AppColors.primaryColor,),))
                              :
                               isExist
                                ?  Container(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          groceryProvider.updateVariantQuantity(CartVariant!.cartId.toString(), "minus", 'v${VariantItem!.id}');
                                        },
                                        child: Icon(Icons.remove, size: ScreenUtil().setSp(22.0), color: AppColors.primaryColor,),
                                        
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                        child: Text(CartVariant!.quantity.toString(), style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                      ),
                                        InkWell(
                                            onTap: (){
                                          groceryProvider.updateVariantQuantity(CartVariant!.cartId.toString(), "plus", 'v${VariantItem!.id}');
                                        },
                                        child: Icon(Icons.add, size: ScreenUtil().setSp(20.0), color: AppColors.primaryColor,),
                                        
                                      ),
                                    ],
                                  ),
                                )

                              : InkWell(
                                onTap: (){
                                  
                                Provider.of<GroceryCartProvider>(context, listen: false).addCart({
                                   "user_id": 1,
    "product_id": grocerySearchModelData.groceryId,
    "variant_id": VariantItem.id
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
                            ],
                          ),
                          );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GrocerySearchModel.dart';
import 'package:qfoods/widgets/GroceryVariantBottomSheet.dart';




class GroceryProductCard extends StatelessWidget {
  final GrocerySearchModel grocerysearchData;
  
  const GroceryProductCard({super.key, required this.grocerysearchData});

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true).CartData.items;
    final groceryProvider =  Provider.of<GroceryCartProvider>(context, listen: true);
       bool?   isExist = cartProvider?.any((el) => (el.groceryId == grocerysearchData?.groceryId)) ?? false;
  final  CartProduct = isExist ? cartProvider!.firstWhere((element) => (element.groceryId ?? 0) == (grocerysearchData!.groceryId ?? 0)) : null;
    

    return Container(
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
          Container(height: (MediaQuery.of(context).size.height / 2) / 4, width: double.infinity, 
          child: Image.network(grocerysearchData.image.toString(),
          errorBuilder: ((context, error, stackTrace) {
            return Image.asset("assets/images/no-image.jpg");
          }),
          ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(grocerysearchData.name.toString(),textAlign: TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(14.0)),),
                
                SizedBox(height: 1.0,),
                Text(grocerysearchData.weight.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.pricecolor.withOpacity(0.8), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(12.0)),),
               SizedBox(height: 2.0,),
               
                if(grocerysearchData.combo.toString() == 'true')
                Text(grocerysearchData.comboDescription.toString(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.pricecolor.withOpacity(0.8), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(12.0)),),
              

                             Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                    Column(
                      children: [
                       
                        Text("Rs ${grocerysearchData.price.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(12.0)),),
                      
                       if(grocerysearchData.salePrice != 0 && grocerysearchData.offers == "true")
                        Text("Rs ${grocerysearchData.regularPrice.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(decoration: TextDecoration.lineThrough,color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(12.0)),),
                       
                      ],
                    ),
                   
                   (grocerysearchData.variant == "true" && grocerysearchData.variants!.length > 0)

                    ? InkWell(
                      onTap: (){
                          FocusScope.of(context).unfocus();
                    
                      GroceryVariantBottomSheet().bottomDetailsSheet(grocerysearchData, context);
                      },
                      child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text("Options", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(11.0)),),
                           ),
                    )
               : 
               (
                 groceryProvider!.loadingId == grocerysearchData!.groceryId!.toString()
                                ? Container(
                                  margin:  EdgeInsets.only(right: ScreenUtil().setSp(20)),
                                  child: SizedBox(width: ScreenUtil().setSp(20), height: ScreenUtil().setSp(20), child: CircularProgressIndicator(color: AppColors.primaryColor,),))
                                :
                                (
                                   isExist 
                                  ? Container(
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          groceryProvider.updateQuantity(CartProduct!.cartId.toString(), "minus", '${CartProduct!.id}');
                                        },
                                        child: Icon(Icons.remove, size: ScreenUtil().setSp(22.0), color: AppColors.primaryColor,),
                                        
                                      ),
                                     
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                        child: Text(CartProduct!.quantity.toString(), style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                      ),
                                        InkWell(
                                            onTap: (){
                                          groceryProvider.updateQuantity(CartProduct!.cartId.toString(), "plus", '${CartProduct!.id}');
                                        },
                                        child: Icon(Icons.add, size: ScreenUtil().setSp(20.0), color: AppColors.primaryColor,),
                                        
                                      ),
                                    ],
                                  ),
                                )
                               :
                    
               InkWell(
                onTap: (){
                    Provider.of<GroceryCartProvider>(context, listen: false).addCart({
                                   "user_id": 1,
                                   "product_id": grocerysearchData?.groceryId
                                 });
                },
                 child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text("ADD", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14.0)),),
                           ),
               )
                             )
               )
             ],
               )
              ],
            ),
          )
        ],
       ),
              );
  }
}

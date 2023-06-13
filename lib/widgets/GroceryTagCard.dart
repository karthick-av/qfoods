import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryHomeTagsModel.dart';
import 'package:qfoods/widgets/GroceryVariantBottomSheet.dart';

class GroceryTagCard extends StatelessWidget {
   final Products products;
 
  const GroceryTagCard({super.key,required this.products});

  @override
  Widget build(BuildContext context) {
        
double itemheight = ScreenUtil().setHeight(170);

double itemWidth = ScreenUtil().setWidth(100);
final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true).CartData.items;
    final groceryProvider =  Provider.of<GroceryCartProvider>(context, listen: true);
       bool?   isExist = cartProvider?.any((el) => (el.groceryId == products?.groceryId)) ?? false;
  final  CartProduct = isExist ? cartProvider!.firstWhere((element) => (element.groceryId ?? 0) == (products.groceryId ?? 0)) : null;
     

    return Container(
          height: itemheight * 0.94,
        margin: const EdgeInsets.only(left: 10.0),
        width: itemWidth,
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
                    ClipRRect(
                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                      child:  Container(
                        height: itemheight/2.8, width: itemWidth,
                        child: Image.network(
                          products!.image!.toString()
                          , height: double.infinity, width: double.infinity, fit: BoxFit.cover,),
                      ),
                    ),
                     SizedBox(height: 10.0,),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(
                            products!.name!.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0)),),
                        Text(products!.weight!.toString(), maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.greycolor, fontSize: ScreenUtil().setSp(11.0))),
                                         Row(
                        children: [
                         
                          Text("Rs ${products!.price!.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(12.0)),),
                        
                         if(products!.salePrice != 0 && products!.offers == "true")
                          Text("Rs ${products!.regularPrice!.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(decoration: TextDecoration.lineThrough,color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(12.0)),),
                        
                          ],
                        ) 
                        ],
                                          ),
                      ),
                   (
                    products?.status == 0
                    ?
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
                    
                    
                    : (products!.variant == "true" && products!.variantsItems!.length > 0)
                    ?  InkWell(
                      onTap: (){
                        GroceryVariantTagBottomSheet().bottomDetailsTagSheet(products, context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: AppColors.primaryColor
                        //   )
                        // ),
                        child: Row(
                          children: [
                           // Icon(Icons.add, color: AppColors.primaryColor,),
                            Text("Options", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), color: AppColors.primaryColor,fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                          ],
                        ),
                       ),
                    ) 
                   :
                  (
                    groceryProvider!.loadingId == products!.groceryId!.toString()
                                ? Container(
                                  margin:  EdgeInsets.only(left: ScreenUtil().setSp(20), top: ScreenUtil().setSp(5.0)),
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
                     Container(
                      padding: const EdgeInsets.all(2.0),
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: AppColors.primaryColor
                      //   )
                      // ),
                      child: InkWell(
                        onTap: (){
                           Provider.of<GroceryCartProvider>(context, listen: false).addCart({
                                   "user_id": 1,
                                   "product_id": products!.groceryId
                                 });
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add, color: AppColors.primaryColor,),
                            Text("ADD", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), color: AppColors.primaryColor,fontWeight: FontWeight.bold, letterSpacing: 1.0),),
                          ],
                        ),
                      ),
                     )
                  )
                     )

                     )

                      ],
                     )
                      ],
                  ),
       );
  }
}
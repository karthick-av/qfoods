
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/CartProvider.dart';
import 'package:qfoods/Provider/SelectedVariantProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/CartModel.dart';
import 'package:qfoods/model/SelectedVariantModel.dart';
import 'package:qfoods/widgets/DishVariantCard.dart';


class CartDishVariantBottomSheet{
  Future<void> CartVariantModal(Items? dish, BuildContext context)async {

print("object");
    double width = MediaQuery.of(context).size.width;

    final Selected_Variant = Provider.of<SelectedVariantProvider>(context, listen: false);

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (_) {
        final SelectedVariant =
            Provider.of<SelectedVariantProvider>(_, listen: true);

        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.8,
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close_rounded),
                    iconSize: ScreenUtil().setSp(25.0),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        child: SingleChildScrollView(
                                          child: Column(children: [
                            
                                for (var index = 0; index < (dish?.dishVariants?.length ?? 0); index++)
                                 Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                  width: width * 0.95,
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
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
                                   
                                       Text("${dish?.dishVariants?[index]?.name ?? ''}", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), color: AppColors.blackcolor, fontWeight: FontWeight.bold),),
                                       ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        controller: controller,
                                                 itemCount: dish?.dishVariants?[index]?.variantItems?.length ?? 0,
                                      itemBuilder: (_, i){
                                     return CartDishVariantCard(
                                      dishVariants: dish?.dishVariants,
                                      price: dish?.price ?? 0,
                                      variantId: dish!.dishVariants![index].variantId!.toString(),
                                      variant: dish!.dishVariants![index].variantItems![i], type: dish?.dishVariants?[index]?.type ?? "",);
                              }
                                       )
                                  ]
                                )
                              )
                                 )  ,  
                        
                               SizedBox(height: ScreenUtil().setHeight(80),)    
                        

                                          ]),
                                        ),
                      ),

                       
                  Positioned(
                    bottom: 0,
                    left:0,
                    right: 0,
                    child:   AnimatedSwitcher(
                  
                      duration: Duration(milliseconds: 800),
                      switchOutCurve: Curves.easeInOut,
                      child: (SelectedVariant.SelectedVariants?.length ?? 0) > 0 ? SlideInUp(
                               duration: new Duration(milliseconds: 800),
                        animate: (SelectedVariant.SelectedVariants?.length ?? 0) > 0,
                 
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.0),
                            width: double.infinity,
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
                              Text("Rs ${SelectedVariant?.total ?? ''}", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), fontWeight: FontWeight.bold, color: AppColors.blackcolor),)
                            ,
                            InkWell(
                              onTap: (){
                                Provider.of<CartProvider>(context, listen: false).updateVariant({
                                   "user_id": 1,
                                   "product_id": dish?.id,
                                   "variants": SelectedVariant.SelectedVariants?.map((e) => e?.variantItemId)?.toList(),
                                   "cart_id": dish?.cartId
                                 });
                                 Navigator.of(context).pop();
                               
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8.0)
                                ),
                                child: Text("Update", style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.whitecolor, fontWeight: FontWeight.w500),),
                              ),
                            )
                            
                            ]),
                          ),
                      ) : SizedBox() 
                      )
                  )
                    ],
                  )
                
                )
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      Selected_Variant.EmptyVariantsList();
    });
  
  }
}


class CartDishVariantCard extends StatelessWidget {
  final VariantItems? variant;
   final String type;
   final String variantId;
   final int price;
   final List<DishVariants>? dishVariants;
  const CartDishVariantCard({super.key, required this.price,required this.dishVariants,required this.variant, required this.type, required this.variantId});

  @override
  Widget build(BuildContext context) {

    final SelectedVariant = Provider.of<SelectedVariantProvider>(context, listen: true);

    bool isSelected = SelectedVariant.SelectedVariants.any((element) => element.variantItemId?.toString() == variant?.variantItemId?.toString());
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text("${variant?.name ?? ''}", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), fontWeight: FontWeight.w500, color: AppColors.blackcolor),)
          ,
          Row(
            children: [
                   if(variant?.salePrice != 0 && variant?.offers == "true")
                        Text("Rs ${variant?.regularPrice?.toString()}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(decoration: TextDecoration.lineThrough,color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(12.0)),),
                         SizedBox(width: ScreenUtil().setSp(15.0),),

           Text("Rs ${variant?.price ?? ''}", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), fontWeight: FontWeight.w500, color: AppColors.blackcolor),)
              ,
             type == "radio"
             ?  InkWell(
              onTap: (){
                 SelectedVariant.CartaddVariant(SelectedVariantModel(VariantId: variantId, variantItemId: variant?.variantItemId?.toString() ?? ''), type, dishVariants, price);
  
              },
               child: Container(
                margin: const EdgeInsets.only(left: 10),
                height: ScreenUtil().setHeight(17),
                width: ScreenUtil().setWidth(17),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(shape: BoxShape.circle,
               border: Border.all(color: isSelected ?  AppColors.primaryColor : AppColors.lightgreycolor, 
               width: 2)
                ),
                        child: Container(
                height: ScreenUtil().setHeight(10),
                width: ScreenUtil().setWidth(10),
                 decoration: BoxDecoration(shape: BoxShape.circle,
               color: isSelected ? AppColors.primaryColor : AppColors.whitecolor,
                 )
                        ),
               ),
             )
             
             : Checkbox(
              activeColor: AppColors.primaryColor,
              hoverColor: AppColors.primaryColor,
            
              value: isSelected, 
              onChanged: ((value) {
                 SelectedVariant.CartaddVariant(SelectedVariantModel(VariantId: variantId, variantItemId: variant?.variantItemId?.toString() ?? ''), type, dishVariants, price);
             })),
            ],
          )
       
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/SelectedVariantProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/RestaurantAndDishesModel.dart';
import 'package:qfoods/model/SelectedVariantModel.dart';


class DishVariantCard extends StatelessWidget {
  final VariantItems? variant;
   final String type;
   final String variantId;
   final int price;
   final List<DishVariants>? dishVariants;
   final int? rstatus;
  const DishVariantCard({super.key, required this.rstatus,required this.price,required this.dishVariants,required this.variant, required this.type, required this.variantId});


 Widget unAvailable(){
  return Container(
           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0 ),
           margin: const EdgeInsets.only(left: 10.0),
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
             (variant?.status == 0 || rstatus == 0)
             ? unAvailable()
             :
             (type == "radio"
             ?  
             InkWell(
              onTap: (){
             SelectedVariant.addVariant(SelectedVariantModel(VariantId: variantId, variantItemId: variant?.variantItemId?.toString() ?? ''), type, dishVariants, price);
      
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
                 SelectedVariant.addVariant(SelectedVariantModel(VariantId: variantId, variantItemId: variant?.variantItemId?.toString() ?? ''), type, dishVariants, price);
             }))
          )
            ],
          )
       
        ],
      ),
    );
  }
}
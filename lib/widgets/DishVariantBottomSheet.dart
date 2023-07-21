import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/CartProvider.dart';
import 'package:qfoods/Provider/SelectedVariantProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/CartModel.dart';
import 'package:qfoods/model/RestaurantAndDishesModel.dart';
import 'package:qfoods/widgets/DishVariantCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DishVariantBottomSheet {
  Future<void> dishVariantModal(
      SearchResults? dish, int? rstatus, BuildContext context) async {
    double width = MediaQuery.of(context).size.width;

    final Selected_Variant =
        Provider.of<SelectedVariantProvider>(context, listen: false);

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
                                   return DishVariantCard(
                                    dishVariants: dish?.dishVariants,
                                    price: dish?.price ?? 0,
                                    rstatus: rstatus,
                                    variantId: dish!.dishVariants![index].variantId!.toString(),
                                    variant: dish!.dishVariants![index].variantItems![i], type: dish?.dishVariants?[index]?.type ?? "",);
                            }
                                     )
                                ]
                              )
                            )
                               ),
                               SizedBox(height: ScreenUtil().setHeight(80),)    
                        

                                          ]),
                                        ),
                      ),

                       
                  Positioned(
                    bottom: 0,
                    left:0,
                    right: 0,
                    child: AnimatedSwitcher(
                                    
                      duration: Duration(milliseconds: 100),
                      switchOutCurve: Curves.easeInOut,
                      child: (SelectedVariant.SelectedVariants?.length ?? 0) > 0 ? SlideInUp(
                        delay: new Duration(milliseconds: 300),
                             //  duration: new Duration(milliseconds: 700),
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
                              onTap: () async{
                                 final SharedPreferences prefs = await SharedPreferences.getInstance();
    final user_id = await prefs.getInt("qfoods_user_id") ?? null;
  if(user_id == null) return;
                                Provider.of<CartProvider>(context, listen: false).addCart({
                                   "user_id": user_id?.toString(),
                                   "product_id": dish?.dishId,
                                   "variants": SelectedVariant.SelectedVariants?.map((e) => e?.variantItemId)?.toList()
                                 });
                                 Navigator.of(context).pop();
                               
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8.0)
                                ),
                                child: Text("Add to Cart", style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.whitecolor, fontWeight: FontWeight.w500),),
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

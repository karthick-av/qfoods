import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryHomeTagsModel.dart';
import 'package:qfoods/model/GrocerySearchModel.dart';
import 'package:qfoods/widgets/GroceryVariantCard.dart';
import 'package:qfoods/widgets/GroceryVariantTagCard.dart';

class GroceryVariantBottomSheet{
  Future<void> bottomDetailsSheet(GrocerySearchModel grocerySearchModelData, BuildContext context) {
    double width = MediaQuery.of(context).size.width;

   
 return  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return DraggableScrollableSheet(
        maxChildSize: 0.8,
        initialChildSize: 0.7,
        expand: false,
        builder: (_, controller) {
          return Column(
            children: [
                               Container(
                                                     alignment: Alignment.topRight,
                                                     child: IconButton(onPressed: (){
                                                       Navigator.of(context).pop();
                                                     },icon: Icon(Icons.close_rounded), iconSize: ScreenUtil().setSp(25.0),),
                                                   ),

     
              Expanded(
                child: SingleChildScrollView(
                  
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      children: [
                        
                          for (var index = 0; index < (grocerySearchModelData?.variants?.length ?? 0); index++)
                           Center(
                        child: Container(
                            width: width * 0.90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                 Text("${grocerySearchModelData?.variants?[index]?.name ?? ''}", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), color: AppColors.blackcolor, fontWeight: FontWeight.bold),),
                                 ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
                                  shrinkWrap: true,
                                  controller: controller,
                                           itemCount: grocerySearchModelData?.variants?[index]?.items?.length ?? 0,
                                itemBuilder: (_, i){
                               return GroceryVariantCard(grocerySearchModelData: grocerySearchModelData, VariantItem: grocerySearchModelData.variants![index].items![i]);
                        }
                                 )
                            ]
                          )
                        )
                           )    
                      ],
                    ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
  }
}

class GroceryVariantTagBottomSheet{
  Future<void> bottomDetailsTagSheet(Products products, BuildContext context) {
       double width = MediaQuery.of(context).size.width;

   
 return  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return DraggableScrollableSheet(
        maxChildSize: 0.8,
        initialChildSize: 0.7,
        expand: false,
        builder: (_, controller) {
          return Column(
            children: [
                               Container(
                                                     alignment: Alignment.topRight,
                                                     child: IconButton(onPressed: (){
                                                       Navigator.of(context).pop();
                                                     },icon: Icon(Icons.close_rounded), iconSize: ScreenUtil().setSp(25.0),),
                                                   ),

     
              Expanded(
                child: SingleChildScrollView(
                  
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                      children: [
                        
                          for (var index = 0; index < (products?.variantsItems?.length ?? 0); index++)
                           Center(
                        child: Container(
                            width: width * 0.90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                 Text("${products?.variantsItems?[index]?.name ?? ''}", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), color: AppColors.blackcolor, fontWeight: FontWeight.bold),),
                                 ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
                                  shrinkWrap: true,
                                  controller: controller,
                                           itemCount: products!.variantsItems![index]!.variantsProducts!.length,
                                itemBuilder: (_, i){
                                 return GroceryVariantTagCard(variantsProducts: products!.variantsItems![index]!.variantsProducts![i], products: products);          
                                }
                                 )
                            ]
                          )
                        )
                           )    
                      ],
                    ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
  
}
}
/*
 return showModalBottomSheet(
     enableDrag: true,
                        isDismissible: true,
                        context: context,
                        isScrollControlled: true,
                         shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.0))),
    builder:(context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
        final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true).CartData;
  
         return Container(
        height: MediaQuery.of(context).size.height /2,
        child: 
          
            Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  },icon: Icon(Icons.close_rounded), iconSize: ScreenUtil().setSp(25.0),),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                     physics: BouncingScrollPhysics(),
                    itemCount: grocerySearchModelData.variants!.length,
                    itemBuilder: ((context, index) {
                    
                    return Container(
                              padding: const EdgeInsets.all(10.0),
                                
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: grocerySearchModelData.variants?[index].items!.length,
                                    itemBuilder: ((context, i) {
                                   // var isExist = items!.firstWhere((element) => element.groceryId == grocerySearchModelData.groceryId && element.id == grocerySearchModelData.variants![index].items![i].id);
                                     var isExist = cartProvider.items!.any((element) =>   element.variantid == grocerySearchModelData.variants![index].items![i].id);
                                  
                                         return GroceryVariantCard(grocerySearchModelData: grocerySearchModelData, VariantItem: grocerySearchModelData.variants![index].items![i]);
                                    
                                  })),
                                ],
                              ),
                            );
                  })),
                ),
              ],
            )
              
      );
        }
    );
  },);
 */
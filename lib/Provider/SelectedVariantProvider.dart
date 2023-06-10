

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:qfoods/model/DishesHomeTagsModel.dart';
import 'package:qfoods/model/RestaurantAndDishesModel.dart';
import 'package:qfoods/model/SelectedVariantModel.dart';
import 'package:qfoods/model/CartModel.dart' as CartModel;

class SelectedVariantProvider extends ChangeNotifier{
  List<SelectedVariantModel> SelectedVariants = [];
   String total = "";

  Future<void> addCartVariants(List<SelectedVariantModel> cartVariants,List<CartModel.DishVariants>? dishVariants, int price) async{
    SelectedVariants = cartVariants;

    CartVariantCalculateTotal(SelectedVariants, dishVariants, 0);
    
    notifyListeners();
  }


   Future<void> addVariant(SelectedVariantModel variant, String type, List<DishVariants>? dishVariants, int price) async{
   bool isSelected = SelectedVariants.any((element) => element.variantItemId == variant.variantItemId);
    if(type == "radio"){
SelectedVariants.removeWhere((element) => element.VariantId == variant.VariantId);
if(!isSelected){
     SelectedVariants.add(variant);
}
    } else{
       if(isSelected){
 SelectedVariants.removeWhere((element) => element.variantItemId == variant.variantItemId);
   }else{
     SelectedVariants.add(variant);
   }
    } 
CalculateTotal(SelectedVariants, dishVariants, price);
    notifyListeners();
   }




Future<void> CalculateTotal(List<SelectedVariantModel> Selectedvariants,List<DishVariants>? dishVariants, int price) async{
List<int> price_list = [];
bool priceType = false;


print("${SelectedVariants?.length} ${dishVariants!.length}");

dishVariants?.forEach((ele) {
  if(Selectedvariants.any((sv) => sv.VariantId?.toString() == ele?.variantId?.toString())){
    if(ele.priceType == 1){
priceType = true;
    }
    ele.variantItems?.forEach((vt) { 
      if(Selectedvariants.any((vs) => vs?.variantItemId?.toString() == vt.variantItemId?.toString())){
        price_list.add(vt?.price ?? 0);
      }
      

    });
  }
});
 var total_value = price_list.reduce((sum, element){
    return sum + element;
  }); 
if(priceType){
  total_value = price + total_value;
  }

  total = total_value?.toString() ?? '';
  print("total ${total}");


  notifyListeners();
}

    Future<void> EmptyVariantsList() async{
    SelectedVariants = [];
    total = "";
    notifyListeners();
   }


   Future<void> CartaddVariant(SelectedVariantModel variant, String type, List<CartModel.DishVariants>? dishVariants, int price) async{
   bool isSelected = SelectedVariants.any((element) => element.variantItemId == variant.variantItemId);
    if(type == "radio"){
SelectedVariants.removeWhere((element) => element.VariantId == variant.VariantId);
     SelectedVariants.add(variant);
 
    } else{
       if(isSelected){
 SelectedVariants.removeWhere((element) => element.variantItemId == variant.variantItemId);
   }else{
     SelectedVariants.add(variant);
   }
    } 
CartVariantCalculateTotal(SelectedVariants, dishVariants, price);
    notifyListeners();
   }

   Future<void> CartVariantCalculateTotal(List<SelectedVariantModel> Selectedvariants,List<CartModel.DishVariants>? dishVariants, price) async{
List<int> price_list = [];
print("${SelectedVariants?.length} ${dishVariants!.length}");

dishVariants?.forEach((ele) {
  if(Selectedvariants.any((sv) => sv.VariantId?.toString() == ele?.variantId?.toString())){
    ele.variantItems?.forEach((vt) { 
      if(Selectedvariants.any((vs) => vs?.variantItemId?.toString() == vt.variantItemId?.toString())){
        price_list.add(vt?.price ?? 0);
      }

    });
  }
});
 final total_value = price_list.reduce((sum, element){
    return sum + element;
  }) + price; 
  total = total_value?.toString() ?? '';
  print("total ${total}");
  notifyListeners();
}
}
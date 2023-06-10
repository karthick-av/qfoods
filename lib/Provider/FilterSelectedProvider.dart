
import 'package:flutter/cupertino.dart';
import 'package:qfoods/constants/filter_list.dart';
import 'package:qfoods/model/FilterModel.dart';

class FilterSelectedProvider extends ChangeNotifier{

List<FilterModel> RestaurantFilter = filter_list;
bool isSelected = false;


Future<void> SelectRestaurantHandler(int listIndex,  String? value) async{
print(value);
  RestaurantFilter[listIndex].selected  = value;
  print(RestaurantFilter[listIndex].selected);
  
  notifyListeners();

}
void ClearRestaurantFilterHandler(){
 
 for(int i = 0; i < RestaurantFilter.length; i++){
  RestaurantFilter[i].selected = "";
 }

  notifyListeners();
}

void ApplyFilter(){
  print("object");
    isSelected = true;
  notifyListeners();
}

}
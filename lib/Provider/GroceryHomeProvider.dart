
import 'package:flutter/cupertino.dart';
import 'package:qfoods/helpers/grocery_home_helpers.dart';
import 'package:qfoods/model/GroceryHomeCarousel.dart';
import 'package:qfoods/model/GroceryHomeCategoriesModel.dart';
import 'package:qfoods/model/GroceryHomeTagsModel.dart';

class GroceryHomeProvider extends ChangeNotifier{

final _service = GroceryHomeServices();
bool carouselLoading = true;
bool categoriesLoding =  true;
bool tagsLoading = true;

  List<GroceryHomeCarousel> carousel = [];
List<GroceryHomeCategories> homeCategories = [];
  List<GroceryHomeTagsModel> homeTags = [];


  Future<void> getCarousel() async{
   carouselLoading = true;
    notifyListeners();

 try{
     List<GroceryHomeCarousel> response = await _service.groceryHomeCarouselHandler();
   
   carousel = response;
    carouselLoading = false;
    notifyListeners();
 }
 catch(e){
    print(e);
 }
  } 



  Future<void> getHomeCategories() async{
   categoriesLoding = true;
    notifyListeners();

 try{
     List<GroceryHomeCategories> response = await _service.groceryHomeCategoriesAPIHandler();
   
   homeCategories = response;
    carouselLoading = false;
    notifyListeners();
 }
 catch(e){
    print(e);
 }
  } 


  Future<void> getHomeTags() async{
   tagsLoading = true;
    notifyListeners();

 try{
     List<GroceryHomeTagsModel> response = await _service.groceryHomeTagsAPIHandler();
   
   homeTags = response;
    tagsLoading = false;
    notifyListeners();
 }
 catch(e){
    print(e);
 }
  } 

}


import 'package:flutter/cupertino.dart';
import 'package:qfoods/helpers/home_helpers.dart';
import 'package:qfoods/model/DishesHomeCategoriesModel.dart';
import 'package:qfoods/model/DishesHomeTagsModel.dart';
import 'package:qfoods/model/RestaurantHomeCarousel.dart';
import 'package:qfoods/model/TopRestaurantsModel.dart';

class HomeProvider extends ChangeNotifier{
 final _service = HomeServices();


  bool carouselLoading = true;
bool CatgoryLoading = true;
bool tagLoading = true;
bool TopRestaurantLoading  = true;


List<RestaurantHomeCarousel> home_carousel = [];
List<DishesHomeCategoriesModel> DishesHomeCategories = [];

  List<DishesHomeTagsModel> DishesHomeTags = [];
List<TopRestaurantsModel> topRestaurants = [];

  Future<void> getCarousel() async{
   carouselLoading = true;
    notifyListeners();

 try{
     List<RestaurantHomeCarousel> response = await _service.HomeCarouselHandler();
   
   home_carousel = response;
    carouselLoading = false;
    notifyListeners();
 }
 catch(e){
    print(e);
 }

  }
  Future<void> getHomeCategories() async{
   CatgoryLoading = true;
    notifyListeners();

 try{
     List<DishesHomeCategoriesModel> response = await _service.HomeCategoriesAPIHandler();
   
   DishesHomeCategories = response;
    CatgoryLoading = false;
    notifyListeners();
 }
 catch(e){
    print(e);
 }
  } 

  Future<void> getHomeTags() async{
   tagLoading = true;
    notifyListeners();

 try{
     List<DishesHomeTagsModel> response = await _service.DishesHomeTagsAPIHandler();
   
   DishesHomeTags = response;
    tagLoading = false;
    notifyListeners();
 }
 catch(e){
    print(e);
 }
  } 

  

 Future<void> getTopRestaurants() async{
   TopRestaurantLoading = true;
    notifyListeners();

 try{
     List<TopRestaurantsModel> response = await _service.TopRestaurantsAPIHandler();
   
   topRestaurants = response;
    TopRestaurantLoading = false;
    notifyListeners();
 }
 catch(e){
    print(e);
 }
  } 

}
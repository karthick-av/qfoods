import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/model/DishesHomeCategoriesModel.dart';
import 'package:qfoods/model/DishesHomeTagsModel.dart';
import 'package:qfoods/model/RestaurantHomeCarousel.dart';
import 'package:qfoods/model/TopRestaurantsModel.dart';
class HomeServices{

  Future<List<RestaurantHomeCarousel>>HomeCarouselHandler() async{
  List<RestaurantHomeCarousel> _HomeCarousel = [];
  
    var response = await http.get(Uri.parse("${ApiServices.restaurant_home_carousel}"));
    print(response.statusCode);
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      _HomeCarousel.add(RestaurantHomeCarousel.fromJson(json));
       }
       
    }
  return _HomeCarousel;
  }


 Future<List<DishesHomeCategoriesModel>> HomeCategoriesAPIHandler()async {
  
 List<DishesHomeCategoriesModel> _DishesHomeCategories= [];
    var response = await http.get(Uri.parse("${ApiServices.dish_home_categories}"));
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       print(response_body);
       for(var json in response_body){
     
      _DishesHomeCategories.add(DishesHomeCategoriesModel.fromJson(json));
       }
    }
return _DishesHomeCategories;
  }


  Future<List<DishesHomeTagsModel>> DishesHomeTagsAPIHandler()async {
  List<DishesHomeTagsModel> _DishesHomeTags = [];
 

    var response = await http.get(Uri.parse("${ApiServices.dishes_home_tags}"));
    print(response.statusCode);
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       
       for(var json in response_body){
     
      _DishesHomeTags.add(DishesHomeTagsModel.fromJson(json));
       }
    }
 return _DishesHomeTags;
}


 Future<List<TopRestaurantsModel>> TopRestaurantsAPIHandler()async {
  List<TopRestaurantsModel> _topRestaurants = [];
 

   var response = await http.get(Uri.parse("${ApiServices.top_restaurants}"));
    print(response.statusCode);
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      _topRestaurants.add(TopRestaurantsModel.fromJson(json));
      print(json);
       }
    }
  return _topRestaurants;
}

}
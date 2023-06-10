import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/model/GroceryHomeCarousel.dart';
import 'package:qfoods/model/GroceryHomeCategoriesModel.dart';
import 'package:qfoods/model/GroceryHomeTagsModel.dart';

class GroceryHomeServices{

Future<List<GroceryHomeCarousel>>groceryHomeCarouselHandler() async{
  List<GroceryHomeCarousel> groceryHomeCarousel = [];
 
    var response = await http.get(Uri.parse("${ApiServices.grocery_home_carousel}"));
    print(response.statusCode);
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      groceryHomeCarousel.add(GroceryHomeCarousel.fromJson(json));
       }
       
    }
  return groceryHomeCarousel;
  }

 Future<List<GroceryHomeCategories>> groceryHomeCategoriesAPIHandler()async {
  
 List<GroceryHomeCategories> groceryHomeCategories = [];

    var response = await http.get(Uri.parse("${ApiServices.grocery_home_categories}"));
    print(response.body);
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      groceryHomeCategories.add(GroceryHomeCategories.fromJson(json));
       }
      
}
 return groceryHomeCategories;

 }


  Future<List<GroceryHomeTagsModel>> groceryHomeTagsAPIHandler()async {
  
 List<GroceryHomeTagsModel> groceryHomeTagsModel = [];

    var response = await http.get(Uri.parse("${ApiServices.grocery_home_tags}"));
    print(response.statusCode);
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      groceryHomeTagsModel.add(GroceryHomeTagsModel.fromJson(json));
       }
      
    }
  return groceryHomeTagsModel;
}

}

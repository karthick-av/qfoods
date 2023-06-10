

import 'package:qfoods/constants/CustomSnackBar.dart';
import 'package:qfoods/constants/Messages.dart';
import 'package:qfoods/constants/api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qfoods/model/GroceryCartModel.dart';
class GroceryCartServices{
  Future<GroceryCartModel> getCart() async{
    GroceryCartModel groceryCartModel = GroceryCartModel();
    String userid = "1";
    print(ApiServices.grocery_get_cart + userid);
    final uri = Uri.parse(ApiServices.grocery_get_cart + userid);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      print(responseJson);
       final responseData =  GroceryCartModel.fromJson(responseJson);
       if(responseData.items != null){
        groceryCartModel = responseData;
       }
    }
    return groceryCartModel;
  }

 Future<GroceryCartModel> addCart(dynamic data) async{
    GroceryCartModel groceryCartModel = GroceryCartModel();
    String userid = "1";
    final uri = Uri.parse(ApiServices.grocery_add_cart);
    var jsonString = json.encode(data);
     var header ={
  'Content-type': 'application/json'
 };
    final response = await http.post(uri, body: jsonString, headers: header);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
       if(responseJson!["total"] == 0){
      groceryCartModel.total = "0";
      groceryCartModel.items = [];
      return groceryCartModel;
     }
       final responseData =  GroceryCartModel.fromJson(responseJson);
       if(responseData.items != null){
        groceryCartModel = responseData;
       }
    }
    return groceryCartModel;
  }


Future<GroceryCartModel> VariantUpdateQuantity(String cart_id, String type) async{
    GroceryCartModel groceryCartModel = GroceryCartModel();
    String userid = "1";
    print("${ApiServices.grocery_variant_update_quantity}${userid}/${cart_id}?type=${type}");
    final uri = Uri.parse("${ApiServices.grocery_variant_update_quantity}${userid}/${cart_id}?type=${type}");
   
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
       if(responseJson!["total"] == 0){
      groceryCartModel.total = "0";
      groceryCartModel.items = [];
      return groceryCartModel;
     }
       final responseData =  GroceryCartModel.fromJson(responseJson);
      if(responseData.items != null){
         groceryCartModel = responseData;
       }
    }
    return groceryCartModel;
  }

Future<GroceryCartModel> UpdateQuantity(String cart_id, String type) async{
    GroceryCartModel groceryCartModel = GroceryCartModel();
    String userid = "1";
    final uri = Uri.parse("${ApiServices.grocery_update_quantity}${userid}/${cart_id}?type=${type}");
   
    final response = await http.get(uri);
   if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
       if(responseJson?["message"] == Messages.Maximum_quantity){
         CustomSnackBar().MaximumQuantitySnackBar();
      }
     if(responseJson!["total"] == 0){
      groceryCartModel.total = "0";
      groceryCartModel.items = [];
      return groceryCartModel;
     }
       final responseData =  GroceryCartModel.fromJson(responseJson);
       if(responseData.items != null){
        groceryCartModel = responseData;
       }
    }
    return groceryCartModel;
  }


  Future<GroceryCartModel> deleteProduct(dynamic data) async{
    GroceryCartModel groceryCartModel = GroceryCartModel();
    final uri = Uri.parse(ApiServices.grocery_delete_product);
    var jsonString = json.encode(data);
     var header ={
  'Content-type': 'application/json'
 };
    final response = await http.delete(uri, body: jsonString, headers: header);
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
       if(responseJson!["total"] == 0){
      groceryCartModel.total = "0";
      groceryCartModel.items = [];
      return groceryCartModel;
     }
       final responseData =  GroceryCartModel.fromJson(responseJson);
       if(responseData.items != null){
        groceryCartModel = responseData;
       }
    }
    return groceryCartModel;
  }
}





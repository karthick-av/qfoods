import 'package:flutter/cupertino.dart';
import 'package:qfoods/helpers/cart_helpers.dart';
import 'package:qfoods/helpers/grocery_cart_helpers.dart';
import 'package:qfoods/model/GroceryCartModel.dart';

class GroceryCartProvider extends ChangeNotifier {
  final _service = GroceryCartServices();
 bool isLoading = false;
 var loadingId = "";

 GroceryCartModel _groceryCartModel = GroceryCartModel();

  GroceryCartModel get CartData => _groceryCartModel;


  Future<void> getCart() async{
    isLoading = true;
    notifyListeners();

 try{
     GroceryCartModel response = await _service.getCart();
  
  if(response.items != null){
     _groceryCartModel = response;
  }
   
    isLoading = false;
    notifyListeners();
 }
 catch(e){
    isLoading = false;
    notifyListeners();
 }
  } 


  Future<void> addCart(dynamic data) async{

    if(data["variant_id"] != null){
        loadingId ="v${data!["variant_id"]!.toString()}";
    notifyListeners();
    }else{
    loadingId =data!["product_id"]!.toString();
    notifyListeners();
    
    }
    
   try{
      GroceryCartModel response = await _service.addCart(data);
    loadingId = "";
    notifyListeners();

 if(response.items != null){
      _groceryCartModel = response;
    notifyListeners();
  }
   }
   catch(e){
     loadingId = "";
    notifyListeners();
   }
  }
  
  Future<void> updateVariantQuantity(String cart_id, String type,String loadingid) async{
    print(cart_id + "  " +type + "  "+ loadingid);
     loadingId = loadingid;
    notifyListeners();
   

    try{
       GroceryCartModel response = await _service.VariantUpdateQuantity(cart_id, type);
  loadingId = "";
    notifyListeners();
 
  if(response.items != null){
     _groceryCartModel = response;
    notifyListeners();
  }
  
    }
    catch(e){
       loadingId = "";
    notifyListeners();
    }
     
  }

  Future<void> updateQuantity(String cart_id, String type,String loadingid) async{
     loadingId = loadingid;
    notifyListeners();
   
print(cart_id);
    try{
       GroceryCartModel response = await _service.UpdateQuantity(cart_id, type);
  print(response.items);
  loadingId = "";
    notifyListeners();
 
  if(response.items != null){
     _groceryCartModel = response;
    notifyListeners();
  }
  
    }
    catch(e){
       loadingId = "";
    notifyListeners();
    }
     
  }
  

  Future<void> deleteProduct(dynamic data) async{

  
    
   try{
      GroceryCartModel response = await _service.deleteProduct(data);
    loadingId = "";
    notifyListeners();

 if(response.items != null){
      _groceryCartModel = response;
    notifyListeners();
  }
   }
   catch(e){
     loadingId = "";
    notifyListeners();
   }
  }


  Future<void> AddLoadingid(String id) async{
    loadingId = id;
    notifyListeners();
  }

  
  Future<void> AddCartData(GroceryCartModel cartData) async{
   if(cartData.items != null){
      _groceryCartModel = cartData;
    notifyListeners();
  }
  }
  
}
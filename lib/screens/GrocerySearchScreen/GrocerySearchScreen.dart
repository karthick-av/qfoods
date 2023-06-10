import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GrocerySearchModel.dart';
import 'dart:core';

import 'package:qfoods/widgets/GroceryCard.dart';

class GrocerySearchScreen extends StatefulWidget {
  const GrocerySearchScreen({super.key});

  @override
  State<GrocerySearchScreen> createState() => _GrocerySearchScreenState();
}

class _GrocerySearchScreenState extends State<GrocerySearchScreen> {

List<GrocerySearchModel> grocerysearchData = [];





Future<void> SearchAPIHandler(String searchText)async {
 List<GrocerySearchModel> grocerysearchresponse = [];

  try{
    var response = await http.get(Uri.parse("${ApiServices.grocery_search}?search=${searchText}"));
    print(response.statusCode);
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      grocerysearchresponse.add(GrocerySearchModel.fromJson(json));
       }

       setState(() {
         grocerysearchData = grocerysearchresponse;
       });
    }
  }
  catch(err){

  }
}




  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
             SizedBox(height: 20.0,),
                   Center(
                    child: SizedBox(
                      width: width * 0.90,
                      child: TextField(
                        
                        controller: textEditingController,
                        onChanged: ((value) {
                        textEditingController.text = value;
textEditingController.selection =
          TextSelection.collapsed(offset: textEditingController.text.length);
          SearchAPIHandler(value);
                        }),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:    Color(0xffF0F1F5),
                                       
                prefixIcon: IconButton(icon: Icon(Icons.arrow_back_ios, color: AppColors.lightgreycolor,size: ScreenUtil().setHeight(20.0),), onPressed: (){
                  Navigator.of(context).pop();
                },),          
             suffixIcon: IconButton(icon: Icon(Icons.search, color: AppColors.lightgreycolor,size: ScreenUtil().setHeight(20.0),), onPressed: (){},),
              
            enabledBorder: OutlineInputBorder(
                
                 borderRadius: BorderRadius.circular(9.0),
          borderSide:  BorderSide(color: Color(0xffF0F1F5)),
           
            ),
            focusedBorder:  OutlineInputBorder(
           borderRadius: BorderRadius.circular(9.0),
            borderSide:  BorderSide(color: Color(0xffF0F1F5)),
           
            ),
             hintText: "Search grocery or items",
             hintStyle: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0)),
            ),
          cursorColor: AppColors.primaryColor,
                        style: TextStyle(fontSize: ScreenUtil().setHeight(14.0),  fontFamily: FONT_FAMILY,color: AppColors.blackcolor),
                      ),
                    )
                   ),
           SizedBox(height: 20.0,),
               
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              itemCount: grocerysearchData.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 13.0,
                crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.3),
              
            ), itemBuilder: ((context, index) {
              return GroceryCard(grocerysearchData: grocerysearchData[index]);
            })
            
            ))
            ],
          ),
        ),
      ),
    );
  }
}
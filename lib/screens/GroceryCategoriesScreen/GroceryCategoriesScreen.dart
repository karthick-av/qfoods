// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qfoods/constants/api_services.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryHomeCategoriesModel.dart';
import 'package:qfoods/model/GrocerySearchModel.dart';
import 'package:qfoods/screens/Widget/TopRestaurants.dart';
import 'package:http/http.dart' as http;
import 'package:qfoods/widgets/GroceryCard.dart';
import 'package:qfoods/widgets/GroceryProductCard.dart';
import 'package:qfoods/widgets/GroceryProductLoading.dart';
import 'package:qfoods/widgets/GroceryfilterBottomSheet.dart';
import 'package:qfoods/widgets/ShimmerContainer.dart';


class GroceryCategoriesScreen extends StatefulWidget {
  const GroceryCategoriesScreen({super.key, required this.groceryHomeCategories});

  final GroceryHomeCategories groceryHomeCategories;

  @override
  State<GroceryCategoriesScreen> createState() => _GroceryCategoriesScreenState();
}

class _GroceryCategoriesScreenState extends State<GroceryCategoriesScreen> {
 ScrollController scrollController = ScrollController();

List<GrocerySearchModel> groceryProducts = [];

bool ApiCallDone = false;
int current_page = 1;
bool CompleteAPI = false;
int per_page = 10;
bool loading = false;
bool footer_loading = false;
bool header_loading = false;
GroceryHomeCategories? category;
String order = "price";
String order_type = "";

  
  var opacityValue = 0.0;


  @override
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      category = widget.groceryHomeCategories;
      setState(() { });
       groceryCategoryDetailHandler();
    });
    groceryProductBycatIdHandler();
    scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
        BottomgroceryProductBycatIdHandler();
       }
    }

    double val = double.parse((scrollController.offset.toInt() / ScreenUtil().setHeight(60.0).toInt()).toStringAsFixed(1));
    if(val <= 1.0){
      print("trigger ${val}" );
    setState(() {
       
       opacityValue = val;
     });
   
    }
  
    });
    
    super.initState();
  }

  String URL(){
    String url = "${ApiServices.get_product_by_category_Id}${widget.groceryHomeCategories.categoryId}?page=${current_page}&per_page=${per_page}";

category?.selected?.forEach((e) {
  if((e?.selected?.length ?? 0) > 0){
    url  += "&${e.name}=${e.selected?.join(',')}";
  }
});

if(order_type != ""){
 url += "&order=${order}&orderby=${order_type}";
}
    return url;
  }

void ApplyFilterHandler(){
 ApiCallDone = false;
 current_page = 1;
 CompleteAPI = false;
 per_page = 10;
  loading = true;
 footer_loading = false;
setState(() { });

  groceryProductBycatIdHandler();
}



Future<void> groceryCategoryDetailHandler() async{
  GroceryHomeCategories _category;
  header_loading= true;
  setState(() { });
try{
  
    var response = await http.get(Uri.parse("${ApiServices.grocery_category_detail_by_id}${widget.groceryHomeCategories.categoryId}"));
     loading = false;
     header_loading = false;
     setState(() {
   
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       _category = GroceryHomeCategories.fromJson(response_body);
       category = _category;
       header_loading = false;
       setState(() { });
    
    }
  }
  catch(err){
    print(err);
  }

}

Future<void> groceryProductBycatIdHandler()async {
  List<GrocerySearchModel> groceryproductsCategoryId= [];
  setState(() {
    loading = true;
  });
try{
  
    var response = await http.get(Uri.parse(URL()));
     setState(() {
    loading = false;
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       
       for(var json in response_body){
     
      groceryproductsCategoryId.add(GrocerySearchModel.fromJson(json));
       }

       setState(() {
         groceryProducts= groceryproductsCategoryId;
         current_page = current_page + 1;
         loading = false;


       });
    }
  }
  catch(err){
 setState(() {
    loading = false;
  });
  }
  
}

Future<void> BottomgroceryProductBycatIdHandler()async {
  if(CompleteAPI) return;

  List<GrocerySearchModel> groceryproductsCategoryId= [];
  setState(() {
    footer_loading = true;
    ApiCallDone = true;
  });
try{
  
    var response = await http.get(Uri.parse(URL()));
    
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);

       if(response_body!.length == 0){
        setState(() {
          CompleteAPI = true;
        });
       }
       
       for(var json in response_body){
     
      groceryproductsCategoryId.add(GrocerySearchModel.fromJson(json));
       }

       setState(() {
         footer_loading = false;
    current_page = current_page + 1;
    ApiCallDone = false;
 
         groceryProducts=  [...groceryProducts, ...groceryproductsCategoryId];
      


       });
    }else{
      setState(() {
    ApiCallDone = false;
  });
    }
  }
  catch(err){
 setState(() {
    ApiCallDone = false;
  });
  }
  
}

void dispose(){
  scrollController.dispose();
 
  super.dispose();
}


void addSelectedHandler(bool isSelected,String type, int id){
  print("${isSelected}  ${id} ${type}");

}


  @override
  Widget build(BuildContext context) {
int selectedCount = 0;
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      body: SafeArea(child: 
      Stack(
        alignment: Alignment.topCenter,
        children: [
       
          CustomScrollView(
        controller: scrollController,
        slivers: [
   if(header_loading)
     SliverToBoxAdapter(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
             IconButton(onPressed: (){
                Navigator.of(context).pop();
              }, icon: Icon(Icons.arrow_back, color: AppColors.blackcolor,)),
            
            Container(
              margin: const EdgeInsets.only(left: 18.0, top: 10),
              child: ShimmerContainer(ScreenUtil().setSp(20), ScreenUtil().setWidth(120), 5),
            ),
             Container(
              margin: const EdgeInsets.only(left: 18.0, top: 10),
              child: ShimmerContainer(ScreenUtil().setSp(20), ScreenUtil().setWidth(180), 5),
            )
      ],
     ),
       ),
     ),
 if(!header_loading)
(
     category?.thumbnailImage == ""
     ? 

SliverToBoxAdapter(
              child: Text(""),
)
      :    ( 
        category?.thumbnailImage != null  ?
        SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whitecolor,
           //pinned: true,
            elevation: 0.0,
            expandedHeight: ScreenUtil().setHeight(100.0),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.topLeft,
                children: [
      
                  Image.network(category?.thumbnailImage ?? '', width: double.infinity, fit: BoxFit.cover,),
        InkWell(
onTap: (){
  
              Navigator.of(context).pop();
},
          child: Container(
           padding: const EdgeInsets.all(5.0),
           margin: const EdgeInsets.all(10.0),
           decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blackcolor.withOpacity(0.3)
           ),
            child: Icon(Icons.arrow_back, color: AppColors.whitecolor, size: ScreenUtil().setSp(25.0),),
          ),
        ),
                ],
              )
            ),
        
          ): SliverToBoxAdapter())
),
 if(!header_loading)
(
 
 category?.thumbnailImage == "" ?
           SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whitecolor,
            pinned: true,
            elevation: 0.0,
           title: Container(
             child: Row(children: [
             IconButton(onPressed: (){
             Navigator.of(context).pop();
           }, icon: Icon(Icons.arrow_back, color: AppColors.blackcolor,)),

           Text("${category?.categoryName ?? ''}", 
           maxLines: 1,
           overflow: TextOverflow.ellipsis
           ,style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18.0), fontWeight: FontWeight.bold),)
        
             ],)
            ),
           ) :   SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whitecolor,
            pinned: true,
            elevation: 0.0,
           title: Container(
             child: Row(children: [
            Text("${category?.categoryName ?? ''}", 
           maxLines: 1,
           overflow: TextOverflow.ellipsis
           ,style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18.0), fontWeight: FontWeight.bold))
        
             ],)
            ),
           )
),
 SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whitecolor,
            pinned: true,
            elevation: 0.0,
           title: Container(
             child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
  InkWell(
                onTap: (){
                  GroceryFilterBottomSheet(context, category, ApplyFilterHandler);
                },
                 child: Container(
                  padding: EdgeInsets.symmetric(vertical:5.0, horizontal: 8),
                  //margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: selectedCount > 0 ? AppColors.lightgreycolor.withOpacity(0.2) : AppColors.whitecolor,
                    border: Border.all(
                      color:  AppColors.greycolor,
               
                    )
                  ),
                  child: Row(
                    children: [
                      if(selectedCount > 0)
                           Container(
                            padding: const EdgeInsets.all(6),
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor
                            ),
                            child: Text(selectedCount?.toString() ?? "0",
                            style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(10)),
                            ),
                           ),                  
              
             
                      Text("Filter", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), color: AppColors.greycolor),),
                    SizedBox(width: ScreenUtil().setSp(2.0),),
                   Icon(Icons.tune, color: AppColors.greycolor, size: ScreenUtil().setSp(17),)
                    ],
                  ),
                 ),
               ),


 InkWell(
                onTap: (){
             if(order_type == "desc"){
                  order_type = "";
                  setState(() { });
                  ApplyFilterHandler();
                }else{
                  order_type = "desc";
                  setState(() { });
                  ApplyFilterHandler();
                }
                },
                 child: Container(
                  padding: EdgeInsets.symmetric(vertical:5.0, horizontal: 8),
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: order_type == "desc" ? AppColors.lightgreycolor.withOpacity(0.2) :  AppColors.whitecolor,
                    border: Border.all(
                      color:  AppColors.greycolor,
               
                    )
                  ),
                  child: Row(
                    children: [
                     
                      Text("Cost: High to low", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), color: AppColors.greycolor),),
                    SizedBox(width: ScreenUtil().setSp(2.0),),

                    if(order_type == "desc")
                   Icon(Icons.close, color: AppColors.greycolor, size: ScreenUtil().setSp(17),)
                    ],
                  ),
                 ),
               ),
               
 InkWell(
                onTap: (){
                if(order_type == "asc"){
                  order_type = "";
                  setState(() { });
                  ApplyFilterHandler();
                }else{
                  order_type = "asc";
                  setState(() { });
                  ApplyFilterHandler();
                }
                  
                },
                 child: Container(
                  padding: EdgeInsets.symmetric(vertical:5.0, horizontal: 8),
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: order_type == "asc" ? AppColors.lightgreycolor.withOpacity(0.2) :  AppColors.whitecolor,
                    border: Border.all(
                      color:  AppColors.greycolor,
               
                    )
                  ),
                  child: Row(
                    children: [
                     
                      Text("Cost: Low to High", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), color: AppColors.greycolor),),
                    SizedBox(width: ScreenUtil().setSp(2.0),),

                    if(order_type == "asc")
                   Icon(Icons.close, color: AppColors.greycolor, size: ScreenUtil().setSp(17),)
                    ],
                  ),
                 ),
               )



                ],
              ),
             )
            ),
           ),



       SliverToBoxAdapter(child: SizedBox(height: 20.0,),),
         //
    if(loading)
          SliverPadding(
             padding: EdgeInsets.symmetric(horizontal: 14.0),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisSpacing: 15.0,
                  mainAxisSpacing: 20.0,
                  crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.8),
          
          ),
          delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return  GroceryProductLoading();
                  },
            childCount: 6
          )
        ),
      ),
      SliverPadding(
             padding: EdgeInsets.symmetric(horizontal: 14.0),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisSpacing: 15.0,
                  mainAxisSpacing: 20.0,
                  crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.8),
          
          ),
          delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return  GroceryProductCard(grocerysearchData: groceryProducts[index]);
                  },
            childCount: groceryProducts.length
          )
        ),
      ),
      if(footer_loading)
      SliverToBoxAdapter(
        child: Center(child: Container(
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: SizedBox(
                    height: ScreenUtil().setHeight(20.0),
                    width: ScreenUtil().setWidth(20.0),
                    child:  CircularProgressIndicator(
                    color: AppColors.primaryColor

                  ),
                  ),
          ),)
      )
          // SliverToBoxAdapter(
            
          //   child: GridView.builder(
          //     controller: _controller,
          //     padding: EdgeInsets.symmetric(horizontal: 14.0),
          //     itemCount: groceryProducts.length,
          //     shrinkWrap: true,
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisSpacing: 15.0,
          //       mainAxisSpacing: 13.0,
          //       crossAxisCount: 2,
          //   childAspectRatio: MediaQuery.of(context).size.width /
          //     (MediaQuery.of(context).size.height / 1.3),
              
          //   ), itemBuilder: ((context, index) {
          //     return GroceryCard(grocerysearchData: groceryProducts[index]);
          //   })
            
          //   ),
          // )
        ],
      ),
     if(category?.thumbnailImage != "")
     AnimatedOpacity(opacity: opacityValue, duration: Duration(milliseconds: 900),
    child:  Container(
        width: double.infinity,
       padding: const EdgeInsets.only(top:5.0, left: 3.0),
        color: AppColors.whitecolor,
        child: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(Icons.arrow_back, color: AppColors.blackcolor,)),

            Text(category?.categoryName ?? '', style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setHeight(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    ),
   
        ],
      )
      ),
    );
  }


  
}
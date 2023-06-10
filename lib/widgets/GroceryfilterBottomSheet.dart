import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryHomeCategoriesModel.dart';
import 'package:qfoods/model/GroceryTag.dart';



Future<void> GroceryFilterBottomSheet(BuildContext context, GroceryHomeCategories? category, Function ApiHandler){
  
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  int listIndex = 0;
  bool ClearFilter = false;
 return  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
     shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0)
     ),
  ),
    builder: (context) {
   

     

          return StatefulBuilder(
                              builder: (BuildContext ctx, StateSetter mystate) {

                final anySelected = category?.selected?.where((element) => element.selected!.length > 0) ?? [];
            return DraggableScrollableSheet(
                initialChildSize: 0.8,
                maxChildSize: 0.8,
                expand: false,
                builder: (context, controller) {
                      return Container(
                        height: height * 0.80,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                 Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Filter", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                               
                                  ,
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                    child: Icon(Icons.close, color: AppColors.blackcolor, size: ScreenUtil().setSp(20),),
                                      ),
                                  ),
                                  

                                  
                                ],
                               ),
                             ),
                             Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              height: 1,
                              color: Color(0XFFe9e9eb),
                             ),

                           Container(
                            height: height * 0.62,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  width: width * 0.38,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(right: BorderSide(color: Color(0XFFe9e9eb), width: 1.0))
                                  ),
                                  child:  ListView.builder(
                                shrinkWrap: true,
                                itemCount: category?.filters?.length ?? 0,
                                itemBuilder: ((context, index)  {
                                  return InkWell(
                                    onTap: (){
                                      listIndex = index;
                                      mystate(() {
                                        
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                                      child: Row(
                                        children: [
                                          FadeInLeft(
                                            animate: listIndex == index,
                                            child: Container(
                                              height: ScreenUtil().setSp(40),
                                              width: 5,
                                             decoration: BoxDecoration(
                                             borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(40),
                                                  bottomRight: Radius.circular(40)
                                                ),
                                                
                                                color: AppColors.primaryColor
                                             ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                    width: width * 0.34,
                                            child: Text(category?.filters?[index]?.name.toString() ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: AppColors.blackcolor.withOpacity(0.7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16.0), fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                                ),
                                 Container(
                                  width: width * 0.54,
                                  height: double.infinity,
                                  child:  ListView.builder(
                                shrinkWrap: true,
                                itemCount: category?.filters?[listIndex]?.items?.length ?? 0,
                                itemBuilder: ((context, index)  {
                                        int item_id = category?.filters?[listIndex]?.items?[index]?.id ?? 0;
                                              String item_type = category?.filters?[listIndex]?.name?.toString() ?? '';
                                           
                                      List<int> selected_list = category?.selected?.firstWhere((e) => e?.name == category?.filters?[listIndex]?.name)?.selected ?? [];

                              bool isSelected = selected_list?.length == 0 ? false :  selected_list.contains(item_id);
                               
                               
                                      return Container(
                                        padding: const EdgeInsets.symmetric( vertical: 5),
                                        child: Row(
                                          children: [
                                           Checkbox(
                                              activeColor: AppColors.primaryColor,
                  hoverColor: AppColors.primaryColor,
                                            value: isSelected, onChanged: (value){
                                             print("${item_id}  ${item_type} ${isSelected} ${value}");
                                        
                                          if(value! == false){
 final index1  = category?.selected?.indexWhere((e) => e?.name == item_type) ?? -1;
 print(index1);
     if(index1 != -1){
      category?.selected?[index1]?.selected?.removeWhere((e) => e == item_id);

      mystate(() {});
     }
}else{
     final index1  = category?.selected?.indexWhere((e) => e?.name == item_type) ?? -1;
print(index1);
     if(index1 != -1){
      print(category?.selected?[index1]?.selected);
      List <int> SelectedList = [...category?.selected?[index1]?.selected ?? [], item_id];
      category?.selected?[index1]?.selected = SelectedList;

      mystate(() {});
     }
      
}
                                          
                                           }),
                                            Container(
                                      width: width * 0.45,
                                              child: Row(
                                                children: [
                                                  Text(category?.filters?[listIndex]?.items?[index]?.name?.toString() ?? '',
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 10,
                                                  style: TextStyle(color: AppColors.pricecolor.withOpacity(0.7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.normal),
                                                  ),

                                                  Text(" (${category?.filters?[listIndex]?.items?[index]?.count?.toString() ?? '0'})",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 10,
                                                  style: TextStyle(color: AppColors.pricecolor.withOpacity(0.7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.normal),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                }),
                              )
                                   
                                 )
                              ],
                            ),
                           )
                              ],
                            ),
                             Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              height: 1,
                              color: Color(0XFFe9e9eb),
                             ),
                            Container(
                              padding: EdgeInsets.all(8),
                            width: double.infinity,
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                
                                onTap: (){
                                    ClearFilter = true;
                              mystate((){});
                                },
                                child: Text("Clear Filters", style: TextStyle(color: AppColors.greycolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),))
                           ,
                        ClearFilter
                        ? InkWell(
                            onTap: (){
                              ClearFilter = false;
                              mystate((){});
                          Navigator.of(context).pop();
                          ApiHandler();
                         // SelectedFilter.ApplyFilter();
                       //   ApiHandler();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color:  AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text("Apply", style: TextStyle(color: AppColors.whitecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),))
                           ,
                           )
                        :

                           InkWell(
                            onTap: (){
                          Navigator.of(context).pop();
                        ApiHandler();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color: (anySelected?.length ?? 0) > 0 ? AppColors.primaryColor : AppColors.greycolor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text("Apply", style: TextStyle(color: (anySelected?.length ?? 0) > 0 ? AppColors.whitecolor :  AppColors.pricecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),))
                           ,
                           )
                              
                            ],
                           ),
                            )
                          ],
                        ),
                      );
                    
                }
         
      );
            }
          );
    }
 );
}




Future<void> GroceryTagFilterBottomSheet(BuildContext context, GroceryTagDetailModel? tag, Function ApiHandler){
  
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;
  int listIndex = 0;
  bool ClearFilter = false;
 return  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
     shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0)
     ),
  ),
    builder: (context) {
   

     

          return StatefulBuilder(
                              builder: (BuildContext ctx, StateSetter mystate) {

                final anySelected = tag?.selected?.where((element) => element.selected!.length > 0) ?? [];
            return DraggableScrollableSheet(
                initialChildSize: 0.8,
                maxChildSize: 0.8,
                expand: false,
                builder: (context, controller) {
                      return Container(
                        height: height * 0.80,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                 Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Filter", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                               
                                  ,
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(1),
                                    child: Icon(Icons.close, color: AppColors.blackcolor, size: ScreenUtil().setSp(20),),
                                      ),
                                  ),
                                  

                                  
                                ],
                               ),
                             ),
                             Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              height: 1,
                              color: Color(0XFFe9e9eb),
                             ),

                           Container(
                            height: height * 0.62,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  width: width * 0.38,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(right: BorderSide(color: Color(0XFFe9e9eb), width: 1.0))
                                  ),
                                  child:  ListView.builder(
                                shrinkWrap: true,
                                itemCount: tag?.filters?.length ?? 0,
                                itemBuilder: ((context, index)  {
                                  return InkWell(
                                    onTap: (){
                                      listIndex = index;
                                      mystate(() {
                                        
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                                      child: Row(
                                        children: [
                                          FadeInLeft(
                                            animate: listIndex == index,
                                            child: Container(
                                              height: ScreenUtil().setSp(40),
                                              width: 5,
                                             decoration: BoxDecoration(
                                             borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(40),
                                                  bottomRight: Radius.circular(40)
                                                ),
                                                
                                                color: AppColors.primaryColor
                                             ),
                                            ),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                    width: width * 0.34,
                                            child: Text(tag?.filters?[index]?.name.toString() ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: AppColors.blackcolor.withOpacity(0.7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16.0), fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                                ),
                                 Container(
                                  width: width * 0.54,
                                  height: double.infinity,
                                  child:  ListView.builder(
                                shrinkWrap: true,
                                itemCount: tag?.filters?[listIndex]?.items?.length ?? 0,
                                itemBuilder: ((context, index)  {
                                        int item_id = tag?.filters?[listIndex]?.items?[index]?.id ?? 0;
                                              String item_type = tag?.filters?[listIndex]?.name?.toString() ?? '';
                                           
                                      List<int> selected_list = tag?.selected?.firstWhere((e) => e?.name == tag?.filters?[listIndex]?.name)?.selected ?? [];

                              bool isSelected = selected_list?.length == 0 ? false :  selected_list.contains(item_id);
                               
                               
                                      return Container(
                                        padding: const EdgeInsets.symmetric( vertical: 5),
                                        child: Row(
                                          children: [
                                           Checkbox(
                                              activeColor: AppColors.primaryColor,
                  hoverColor: AppColors.primaryColor,
                                            value: isSelected, onChanged: (value){
                                             print("${item_id}  ${item_type} ${isSelected} ${value}");
                                        
                                          if(value! == false){
 final index1  = tag?.selected?.indexWhere((e) => e?.name == item_type) ?? -1;
 print(index1);
     if(index1 != -1){
      tag?.selected?[index1]?.selected?.removeWhere((e) => e == item_id);

      mystate(() {});
     }
}else{
     final index1  = tag?.selected?.indexWhere((e) => e?.name == item_type) ?? -1;
print(index1);
     if(index1 != -1){
      List <int> SelectedList = [...tag?.selected?[index1]?.selected ?? [], item_id];
      tag?.selected?[index1]?.selected = SelectedList;

      mystate(() {});
     }
      
}
                                          
                                           }),
                                            Container(
                                      width: width * 0.45,
                                              child: Row(
                                                children: [
                                                  Text(tag?.filters?[listIndex]?.items?[index]?.name?.toString() ?? '',
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 10,
                                                  style: TextStyle(color: AppColors.pricecolor.withOpacity(0.7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.normal),
                                                  ),

                                                  Text(" (${tag?.filters?[listIndex]?.items?[index]?.count?.toString() ?? '0'})",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 10,
                                                  style: TextStyle(color: AppColors.pricecolor.withOpacity(0.7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.normal),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                }),
                              )
                                   
                                 )
                              ],
                            ),
                           )
                              ],
                            ),
                             Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              height: 1,
                              color: Color(0XFFe9e9eb),
                             ),
                            Container(
                              padding: EdgeInsets.all(8),
                            width: double.infinity,
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                
                                onTap: (){
                                    ClearFilter = true;
                              mystate((){});
                                },
                                child: Text("Clear Filters", style: TextStyle(color: AppColors.greycolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),))
                           ,
                        ClearFilter
                        ? InkWell(
                            onTap: (){
                              ClearFilter = false;
                              mystate((){});
                          Navigator.of(context).pop();
                          ApiHandler();
                         // SelectedFilter.ApplyFilter();
                       //   ApiHandler();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color:  AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text("Apply", style: TextStyle(color: AppColors.whitecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),))
                           ,
                           )
                        :

                           InkWell(
                            onTap: (){
                          Navigator.of(context).pop();
                        ApiHandler();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                color: (anySelected?.length ?? 0) > 0 ? AppColors.primaryColor : AppColors.greycolor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text("Apply", style: TextStyle(color: (anySelected?.length ?? 0) > 0 ? AppColors.whitecolor :  AppColors.pricecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),))
                           ,
                           )
                              
                            ],
                           ),
                            )
                          ],
                        ),
                      );
                    
                }
         
      );
            }
          );
    }
 );
}
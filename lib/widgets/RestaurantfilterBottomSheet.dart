import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/FilterSelectedProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/filter_list.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/FilterModel.dart';


Future<void> RestauarntFilterBottomSheet(BuildContext context, Function ApiHandler){
  
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
    builder: (_) {
   

      return StatefulBuilder(
        builder: (BuildContext ctx, StateSetter setState) {
            final SelectedFilter = Provider.of<FilterSelectedProvider>(ctx, listen: true);

            bool? any_Selected = SelectedFilter.RestaurantFilter?.every((element) => element?.selected =="");
             bool anySelected = (any_Selected ?? false) ? false: true; 
        
      

          return DraggableScrollableSheet(
            initialChildSize: 0.8,
            maxChildSize: 0.8,
            expand: false,
            builder: (_, controller) {
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
                            itemCount: filter_list.length,
                            itemBuilder: ((context, index)  {
                              return InkWell(
                                onTap: (){
                                  listIndex = index;
                                  setState(() {
                                    
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
                                        child: Text(filter_list[index].title?.toString() ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: AppColors.blackcolor.withOpacity(0.7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16.0), fontWeight: FontWeight.w600),
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
                              child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filter_list[listIndex]?.options?.length ?? 0,
                            itemBuilder: ((context, index)  {
                           bool isSelected =  SelectedFilter.RestaurantFilter[listIndex]?.selected == filter_list[listIndex]?.options?[index]?.attribute_id?.toString();
                              return Container(
                                padding: const EdgeInsets.symmetric( vertical: 12),
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: AppColors.primaryColor,
  
                                      value:  filter_list[listIndex]?.options?[index]?.attribute_id?.toString(), 
                                      groupValue: isSelected ?  filter_list[listIndex]?.options![index]?.attribute_id?.toString() : "",
                                       onChanged: (value){
                                     SelectedFilter.SelectRestaurantHandler(listIndex, filter_list[listIndex]?.options?[index]?.attribute_id?.toString());
                                    }),
                                    Container(
                              width: width * 0.45,
                                      child: Text(filter_list[listIndex]?.options?[index]?.attributeName?.toString() ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                      style: TextStyle(color: AppColors.pricecolor.withOpacity(0.7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
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
                              SelectedFilter.ClearRestaurantFilterHandler();
                              ClearFilter = true;
                              setState((){});
                            },
                            child: Text("Clear Filters", style: TextStyle(color: AppColors.greycolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),))
                       ,
                    ClearFilter
                    ? InkWell(
                        onTap: (){
                          ClearFilter = false;
                          setState((){});
                      Navigator.of(context).pop();
                      SelectedFilter.ApplyFilter();
                      ApiHandler();
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
                    if(anySelected){
                      Navigator.of(context).pop();
                      SelectedFilter.ApplyFilter();
                      ApiHandler();
                    }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: (anySelected ?? false) ? AppColors.primaryColor : AppColors.greycolor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text("Apply", style: TextStyle(color: (anySelected ?? false) ? AppColors.whitecolor : AppColors.pricecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),))
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
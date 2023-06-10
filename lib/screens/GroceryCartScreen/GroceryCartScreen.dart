import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/GroceryCartModel.dart';
import 'package:qfoods/screens/MapsScreen/GroceryMapsScreen.dart';
import 'package:qfoods/widgets/GroceryCartCard.dart';
import 'package:qfoods/widgets/RestaurantCardLoading.dart';

class GroceryCartScreen extends StatefulWidget {
  const GroceryCartScreen({super.key});

  @override
  State<GroceryCartScreen> createState() => _GroceryCartScreenState();
}

class _GroceryCartScreenState extends State<GroceryCartScreen> {

  @override
  Widget build(BuildContext context) {
     double width = MediaQuery.of(context).size.width;
  final cartProvider = Provider.of<GroceryCartProvider>(context, listen: true);
     int unavailable = cartProvider?.CartData?.items?.where((e) => e?.status == 0)?.length ?? 0;

  
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
         bottomNavigationBar: unavailable > 0 ? unavailableContainer(width) :  CheckoutBtn(cartProvider?.CartData, width),  
    
      appBar: AppBar(
iconTheme: IconThemeData(
    color: Colors.black, // <-- SEE HERE
  ),
        backgroundColor: AppColors.whitecolor,
        elevation: 0.5,
        title: Text("My Cart", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16.0), fontWeight: FontWeight.bold,color: AppColors.blackcolor),),
      ),
      body: SafeArea(
        
        child: cartProvider.isLoading
        ? SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: RestaurantLoadingCard(context, 8), physics: AlwaysScrollableScrollPhysics(),)
        : RefreshIndicator(
            color: Color.fromRGBO(245, 71, 73, 1),
        onRefresh: () async{
        print("object");
        await  cartProvider.getCart();
        },
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cartProvider?.CartData?.items?.length ?? 0,
                itemBuilder: ((context, index) {
                  return GroceryCartCard(index: index);
                                 })),
          
                                 SizedBox(height: MediaQuery.of(context).size.height ,)
              ],
            ),
          ),
        )),
    );
  }


  Widget CheckoutBtn(GroceryCartModel? cart, double width){
    return (cart?.items?.length ?? 0) > 0 ?   Container(
      height: ScreenUtil().setHeight(55.0),
      width: width,
      decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: const Color(0xFFB0CCE1).withOpacity(0.60),
                      ),
                    ],
                  ),
      
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${cart?.items?.length?.toString() ?? ""} items", style: TextStyle(color: AppColors.greycolor, fontWeight:  FontWeight.w500,fontFamily: FONT_FAMILY),),
                              SizedBox(height: 3.0,),
                                Text("Rs ${cart?.total ?? ""}", style: TextStyle(color: AppColors.blackcolor, fontWeight:  FontWeight.bold,fontFamily: FONT_FAMILY),)
                            
                            
                            ],
                          ),
                        ),
                        Padding(
                       padding: const EdgeInsets.only(right: 18.0),
                       child: InkWell(
                          onTap: (){
                           Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GroceryMapsScreen()),
            );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 15.0),
                          decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Text("Check out", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w400),),
                        ),
                       ),
                           )
                    ],
                  ),
    ) : SizedBox();
  }

  
Widget unavailableContainer(double width){
  return Container(
      height: ScreenUtil().setHeight(58.0),
      width: width,
      padding:  const EdgeInsets.all(10),
      decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 20,
                        color: const Color(0xFFB0CCE1).withOpacity(0.60),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning, color: AppColors.primaryColor, size: ScreenUtil().setSp(25),),
                      SizedBox(width: 10,),
                      Column(
                        children: [
                          Container(
                            width: width * 0.80,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
  maxLines: 3,
                              "Some Items Currently are not available", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.bold),))
                       
                       ,
                       SizedBox(height: 5,),
                        Container(
                            width: width * 0.80,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
  maxLines: 3,
                              "Please remove items from Cart", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11), fontWeight: FontWeight.normal),))
                       
                        ],
                      )
                    ],
                  ),
  );
}
}
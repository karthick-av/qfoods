
import 'dart:async';
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:qfoods/constants/bubbleArrow.dart';
import 'package:qfoods/constants/colors.dart';
import 'package:qfoods/constants/font_family.dart';
import 'package:qfoods/model/CheckOutModel.dart';
import 'package:qfoods/screens/CheckOutScreen/GroceryCheckOutScreen.dart';
import 'package:qfoods/widgets/ShimmerContainer.dart';

class GroceryMapsScreen extends StatefulWidget {
  const GroceryMapsScreen({super.key});

  @override
  State<GroceryMapsScreen> createState() => _GroceryMapsScreenState();
}

class _GroceryMapsScreenState extends State<GroceryMapsScreen>  with TickerProviderStateMixin {
  double? _currentlat = 0;
  double? _currentlong = 0;
  String locality = '';
  String address = "";
  bool btnLoading = false;
 
    bool additionalToggle = false;
     late final MapController mapController;
  Timer? timer;
  final formGlobalKey = GlobalKey < FormState > ();
 final Map<String, TextEditingController> addressController = {
      'completeAddress': TextEditingController(),
      'area': TextEditingController(),
      'landMark': TextEditingController(),
      "alternate_phone_number": TextEditingController(),
      "instructions": TextEditingController()
    };
 


void initState(){
 mapController = MapController();
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
 bottomSheet();
    });
  super.initState();
}

void dispose(){
mapController.dispose();
timer?.cancel();
addressController["completeAddress"]!.dispose();
addressController["area"]!.dispose();
addressController["landMark"]!.dispose();
addressController["alternate_phone_number"]!.dispose();
addressController["instructions"]!.dispose();
  super.dispose();
}

void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

 void _getLocation() {
  setState(() {
    btnLoading = true;
  });
    _getLocationData().then((value) {
      LocationData? location = value;
      print(location?.latitude);
      print(location?.longitude);
      LatLng? currentLatLong = LatLng(location?.latitude ?? 0, location!.longitude ?? 0);
        _currentlat = location?.latitude;
        _currentlong = location?.longitude;
        btnLoading = false;
      
      setState(() {});
         _animatedMapMove(currentLatLong, 18.0);

         _getAddress(_currentlat, _currentlong);
 
      
    });
  }



Future<LocationData?> _getLocationData() async {
  Location location = new Location();
  LocationData _locationData;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();

  return _locationData;
}

Future<String> _getAddress(double? lat, double? lang) async {
  if (lat == null || lang == null) return "";
  setState(() {
    btnLoading = true;
  });
  List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(lat, lang);
  if(placemarks.length > 0){
    print(placemarks[0]?.toString());
     geocoding.Placemark place = placemarks[0];

     
   address = '${place.street},${place.thoroughfare}, ${place.subThoroughfare}, ${place.locality}, ${place.subLocality},${place.administrativeArea},${place.postalCode}';
       locality = place.locality ?? '';
     btnLoading = false;

     setState(() {    });
  }
  return '';
}


Future<void> completeAddressHandler(BuildContext context) async{
  Navigator.of(context).pop();
              try{
 
 if(_currentlat == 0 && _currentlong == 0){
//   List<geocoding.Location> addr = await geocoding.locationFromAddress(addressController["completeAddress"]?.value.text ?? '');
//  if((addr?.length ?? 0) > 0){
//    _currentlat = addr[0]?.latitude ?? 0;
//    _currentlong = addr[0]?.longitude ?? 0;
//  }
 }
                 final data = addressController;
            
                CheckOutModel _checkout = CheckOutModel(address1: address, address2: addressController["completeAddress"]?.value.text, AreaAndFloor: addressController["area"]?.value.text, landMark: addressController["landMark"]?.value.text, latitude: _currentlat, longitude: _currentlong,
                alternate_phone_number: addressController["alternate_phone_number"]?.value.text, instructions: addressController["instructions"]?.value.text
                );
                   Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => 
              GroceryCheckOutScreen(checkOut: _checkout)),
            );
              
              }catch(e){
              final data = addressController;
            
                CheckOutModel _checkout = CheckOutModel(address1: address, address2: addressController["completeAddress"]?.value.text, AreaAndFloor: addressController["area"]?.value.text, landMark: addressController["landMark"]?.value.text, latitude: _currentlat, longitude: _currentlong,
                alternate_phone_number: addressController["alternate_phone_number"]?.value.text, instructions: addressController["instructions"]?.value.text
                );
                   Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => 
              GroceryCheckOutScreen(checkOut: _checkout)),
            );
              
              }
              
}


void bottomSheet(){
      showModalBottomSheet(context: context, 
      isScrollControlled: true,
  builder: ((context) {
    return Container(
      height: ScreenUtil().setHeight(150),
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: Column(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
       alignment: Alignment.centerRight,
            child: InkWell(onTap: (){
              Navigator.of(context).pop();
            },child: Icon(Icons.cancel, color: Colors.black, size: ScreenUtil().setSp(27.0),),)
       ,
          ),
          SizedBox(height: ScreenUtil().setHeight(5),),

      Container(
        child: Column(
          children: [
                InkWell(
                  onTap: (() {
                    _getLocation();
                    Navigator.of(context).pop();
                  }),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8.0)),
                child: Text("Current Location", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.normal),),
              ),
              
            ),
            SizedBox(height: ScreenUtil().setHeight(10.0),),
            InkWell(
              onTap: (){
                 _currentlat = 0;
                                  _currentlong =0;
                                  address = "";
                                  
                                  setState(() { });
                                  addressController["completeAddress"]?.clear();
                                  addressController["area"]?.clear();
                                  addressController["landMark"]?.clear();
                                  addressController["alternate_phone_number"]?.clear();
                                  addressController["instructions"]?.clear();
                                    ManualAddressBottomSheet();
                               
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.90,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8.0)),
                child: Text("Enter Location Manually", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.normal),),
              ),
              
            ),
        
          ],
        ),
      )    
        ],
      ),
    );
  }));
}



void CompleteAddressBottomSheet(){
  showModalBottomSheet(context: context, 
      isScrollControlled: true,
  shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
        ),
      ),
      constraints: BoxConstraints(maxHeight: 
           MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top),
            builder: ((context) {
    //double bottom = MediaQuery.of(context).viewInsets.bottom -100.0;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
           onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
        },
          child: SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
                                      child: Container(
                padding: const EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height * 0.88,
                width: double.infinity,
                child: Form(
                      key: formGlobalKey,
                    
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          children: [
                         
                         Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Text("Enter Complete Address", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0),fontWeight: FontWeight.bold),),
                           InkWell(onTap: (){
                          Navigator.of(context).pop();
                        },child: Icon(Icons.cancel, color: Colors.black, size: ScreenUtil().setSp(27.0),),)
                         
                        ],
                         ),
                                SizedBox(height: ScreenUtil().setHeight(5),),
                        
                                 TextFormField(
                                  controller: addressController["completeAddress"],
                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                 maxLines: 5, // <-- SEE HERE
                        minLines: 1,
                        validator: ((value){
                          if(value == "") return "Address is required";
                          return null;
                        }),
                         cursorColor: AppColors.greycolor,
                               
                                 decoration:  InputDecoration(
                        labelText: 'Complete Address *',
                        errorStyle: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(8.0)),
                        border: OutlineInputBorder(
                        )
                        ,
                           focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                // TODO: add errorHint
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(14),),
                          TextFormField(
                            
                                  controller: addressController["area"],
                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                 cursorColor: AppColors.greycolor,
                               
                                 decoration:  InputDecoration(
                        labelText: 'Floor, Area (optional)',
                        border: OutlineInputBorder(
                        )
                        ,
                         focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                // TODO: add errorHint
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(14),),
                                TextFormField(
                                  controller: addressController["landMark"],
                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                cursorColor: AppColors.greycolor,
                                 decoration:  InputDecoration(
                        labelText: 'Nearby Landmark (optional)',
                        border: OutlineInputBorder(
                        )
                        ,
                           focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                // TODO: add errorHint
                                ),
                              ),
          
          
                               SizedBox(height: ScreenUtil().setHeight(14),),
                                InkWell(
                                  onTap: (){
                                      additionalToggle = !additionalToggle;
                                
                                    setState(() {
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text("Additional Details", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w700,fontSize: ScreenUtil().setSp(14)),),
                                   
                                      Icon(Icons.add_circle_rounded, size: ScreenUtil().setSp(20), color: AppColors.primaryColor,)
                                    ],
                                  ),
                                ),
                          SizedBox(height: ScreenUtil().setHeight(20),),
                                FadeInUp(
                                animate: additionalToggle,
                                child:
                                Column(
                                  children: [
          
                              TextFormField(
                                
                                      controller: addressController["alternate_phone_number"],
                                     style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                     cursorColor: AppColors.greycolor,
                                   
                                     decoration:  InputDecoration(
                            labelText: 'Alternate phone Number (optional)',
                            border: OutlineInputBorder(
                            )
                            ,
                             focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(4)),
                               borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                             ),
                             enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(4)),
                               borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                             ),
                            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                    // TODO: add errorHint
                                    ),
                                  ),
                            
                                            SizedBox(height: ScreenUtil().setHeight(5),),
                            
                                     TextFormField(
                                      controller: addressController["instructions"],
                                     style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                     maxLines: 5, // <-- SEE HERE
                            minLines: 1,
                           
                             cursorColor: AppColors.greycolor,
                                   
                                     decoration:  InputDecoration(
                            labelText: 'Direction Instructions ',
                            errorStyle: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(8.0)),
                            border: OutlineInputBorder(
                            )
                            ,
                               focusedBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(4)),
                               borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                             ),
                             enabledBorder: OutlineInputBorder(
                               borderRadius: BorderRadius.all(Radius.circular(4)),
                               borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                             ),
                            labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                    // TODO: add errorHint
                                    ),
                                  ),
                             
                                  ],
                                ),
          
                                )   
                              
                          ],
                        ),
                      ),
            
                   
                      InkWell(
                        onTap: (){
                           if (!formGlobalKey.currentState!.validate()) {
                          return;
                        }
                  
                      completeAddressHandler(context);
                        },
                        child: Container(
                        decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8.0)),
                          width: MediaQuery.of(context).size.width * 0.95,
                          padding: const EdgeInsets.all(15.0),
                          alignment: Alignment.center,
                          child: 
                          btnLoading 
                          ? SizedBox(height: ScreenUtil().setHeight(14.0), width: ScreenUtil().setWidth(14.0),
                          child: CircularProgressIndicator(color: AppColors.whitecolor, strokeWidth: 2),
                          )
                          : Text("Enter complete address",
                          style: TextStyle(color: AppColors.whitecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  })
  );


  }


  void ManualAddressBottomSheet(){
  showModalBottomSheet(context: context, 
      isScrollControlled: true,
     shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
        ),
      ),
      constraints: BoxConstraints(maxHeight: 
           MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top),
  builder: ((context) {
    //double bottom = MediaQuery.of(context).viewInsets.bottom -100.0;
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return GestureDetector(
           onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
        },
          child: SingleChildScrollView(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
                                      child: Container(
                padding: const EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height * 0.90,
                width: double.infinity,
                child: Form(
                      key: formGlobalKey,
                    
                  child: Column(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  
                          children: [
                         
                         Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         Text("Enter Complete Address", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0),fontWeight: FontWeight.bold),),
                           InkWell(onTap: (){
                          Navigator.of(context).pop();
                        },child: Icon(Icons.cancel, color: Colors.black, size: ScreenUtil().setSp(27.0),),)
                         
                        ],
                         ),
                                SizedBox(height: ScreenUtil().setHeight(5),),
                        
                                 TextFormField(
                                  controller: addressController["completeAddress"],
                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                 maxLines: 5, // <-- SEE HERE
                        minLines: 1,
                        validator: ((value){
                          if(value == "") return "Address is required";
                          return null;
                        }),
                         cursorColor: AppColors.greycolor,
                               
                                 decoration:  InputDecoration(
                        labelText: 'Complete Address *',
                        errorStyle: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(8.0)),
                        border: OutlineInputBorder(
                        )
                        ,
                           focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                // TODO: add errorHint
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(14),),
                          TextFormField(
                            
                                  controller: addressController["area"],
                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                 cursorColor: AppColors.greycolor,
                               
                                 decoration:  InputDecoration(
                        labelText: 'Floor, Area (optional)',
                        border: OutlineInputBorder(
                        )
                        ,
                         focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                // TODO: add errorHint
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(14),),
                                TextFormField(
                                    validator: ((value){
                          if(value == "") return "LandMark is required";
                          return null;
                        }),
                                  controller: addressController["landMark"],
                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                cursorColor: AppColors.greycolor,
                                 decoration:  InputDecoration(
                        labelText: 'Nearby Landmark *',
                        border: OutlineInputBorder(
                        )
                        ,
                           focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                // TODO: add errorHint
                                ),
                              ),
          
                           SizedBox(height: ScreenUtil().setHeight(14),),
                            InkWell(
                              onTap: (){
                                  additionalToggle = !additionalToggle;
                            
                                setState(() {
                                });
                              },
                              child: Row(
                                children: [
                                  Text("Additional Details", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w700,fontSize: ScreenUtil().setSp(14)),),
                               
                                  Icon(Icons.add_circle_rounded, size: ScreenUtil().setSp(20), color: AppColors.primaryColor,)
                                ],
                              ),
                            ),
          SizedBox(height: ScreenUtil().setHeight(20),),
                            FadeInUp(
                            animate: additionalToggle,
                            child:
                            Column(
                              children: [
          
                          TextFormField(
                            
                                  controller: addressController["alternate_phone_number"],
                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                 cursorColor: AppColors.greycolor,
                               
                                 decoration:  InputDecoration(
                        labelText: 'Alternate phone Number (optional)',
                        border: OutlineInputBorder(
                        )
                        ,
                         focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                // TODO: add errorHint
                                ),
                              ),
                        
                                        SizedBox(height: ScreenUtil().setHeight(5),),
                        
                                 TextFormField(
                                  controller: addressController["instructions"],
                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                 maxLines: 5, // <-- SEE HERE
                        minLines: 1,
                       
                         cursorColor: AppColors.greycolor,
                               
                                 decoration:  InputDecoration(
                        labelText: 'Direction Instructions ',
                        errorStyle: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(8.0)),
                        border: OutlineInputBorder(
                        )
                        ,
                           focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.all(Radius.circular(4)),
                           borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                         ),
                        labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                // TODO: add errorHint
                                ),
                              ),
                         
                              ],
                            ),
          
                            )   
                              
                          ],
                        ),
                      ),
            
                   
                      InkWell(
                        onTap: (){
                        print(formGlobalKey.currentState!.validate());
                           if (!formGlobalKey.currentState!.validate()) {
                          return;
                        }
        
                  
                      completeAddressHandler(context);
                        },
                        child: Container(
                        decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(8.0)),
                          width: MediaQuery.of(context).size.width * 0.95,
                          padding: const EdgeInsets.all(15.0),
                          alignment: Alignment.center,
                          child: 
                          btnLoading 
                          ? SizedBox(height: ScreenUtil().setHeight(14.0), width: ScreenUtil().setWidth(14.0),
                          child: CircularProgressIndicator(color: AppColors.whitecolor, strokeWidth: 2),
                          )
                          : Text("Enter complete address",
                          style: TextStyle(color: AppColors.whitecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  })
  );


  }

  @override
  Widget build(BuildContext context) {



     LatLng currentLatLng;



    if (_currentlat != null && _currentlong != null) {
      currentLatLng =
          LatLng(_currentlat ?? 0, _currentlong ?? 0);
    } else {
      currentLatLng = LatLng(0, 0);
    }

  final markers = <Marker>[
      Marker(
        width: ScreenUtil().setWidth(200.0),
       height: ScreenUtil().setHeight(40.0),
        point: currentLatLng,
        builder: (ctx){
          return SizedBox();
        },
      ),
     ];

double itemWidth = MediaQuery.of(context).size.width * 0.80;
double width = MediaQuery.of(context).size.width * 0.90;

    return Scaffold(
       body: SafeArea(
        child: Stack(
         // alignment: Alignment.center,
          children: [
           
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: LatLng(10.7870,79.1378),
                onPositionChanged: ((position, hasGesture) {
                     timer?.cancel();
      
        timer = Timer(Duration(milliseconds: 1000), () {
_getAddress(position.center?.latitude ?? null,position.center?.longitude ?? null);
        
        });
                }),
                zoom: 5,
              ),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                  onSourceTapped: () {},
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          Center(child:CustomPaint(
            painter: customStyleArrow(),
          child: Container(
            decoration: BoxDecoration(
               color: AppColors.blackcolor,
           
              borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(10.0),
            child: Text("Order will be delivered here",
            style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.normal),
            ),
          ),
          )),
      
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
               Container(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_circle_left, size: ScreenUtil().setSp(29),color: AppColors.blackcolor,),
                ),
               ),
               
                    Column(
                      children: [
                        Container(
                          width: ScreenUtil().setWidth(120),
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(color: Color(0xFFFDD4D7), borderRadius: BorderRadius.circular(5.0)),
                              child: InkWell(
                              onTap: (){
                                _getLocation();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Locate Me", style: TextStyle(fontFamily: FONT_FAMILY,fontWeight: FontWeight.w500,color: AppColors.primaryColor, fontSize: ScreenUtil().setSp(14.0))),
                                SizedBox(width: 7.0,),
                                 Icon(Icons.gps_fixed, color: AppColors.primaryColor, size: ScreenUtil().setSp(20.0),)
                                ],
                              ),
                             )),
                             SizedBox(height: 10,),
                        Container(
              width: double.infinity,
              
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: AppColors.whitecolor),
            child: Column(
              children: [
                // LinearProgressIndicator(
                //   backgroundColor: AppColors.whitecolor,
                //   valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                //   minHeight: ScreenUtil().setSp(2.0),
                
                // ),
                
                SizedBox(height: 4,),
                Row(
            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Icon(Icons.pin_drop, color: AppColors.primaryColor, size: ScreenUtil().setSp(28.0),),
                        SizedBox(width: 10.0,),
                       btnLoading
                       ? loading()

                       :
                      
                         Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         
                          children: [
                             Container(
                              width: itemWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                 Container(child: Text(locality, maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), color: AppColors.blackcolor),),),
                                 Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(color: Color(0xFFFDD4D7), borderRadius: BorderRadius.circular(5.0)),
                                  child: InkWell(
                                  onTap: (){
                                  _currentlat = 0;
                                  _currentlong =0;
                                  address = "";
                                  
                                  setState(() { });
                                  addressController["completeAddress"]?.clear();
                                  addressController["area"]?.clear();
                                  addressController["landMark"]?.clear();
                                  addressController["alternate_phone_number"]?.clear();
                                  addressController["instructions"]?.clear();
                                    ManualAddressBottomSheet();
                                  },
                                  child: Text("Custom", style: TextStyle(fontFamily: FONT_FAMILY,color: AppColors.primaryColor, fontSize: ScreenUtil().setSp(10.0))),
                                 ))
                                ],
                              ),
                             ),
                         Container(
                          margin: const EdgeInsets.only(top: 4.0),
                        width: itemWidth,
                          child:   Text(address, maxLines: 3, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), color: AppColors.blackcolor),)
                 ,
                         )
                          ],
                         )
                   ],
                ),
                Center(
                  child: InkWell(
                        onTap: (){
                          if(!btnLoading){
                   CompleteAddressBottomSheet();
                          }
                        },
                        child: Container(
                         width: width,
                         margin: const EdgeInsets.only(top: 10.0),
                         alignment: Alignment.center,
                         
                         decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(btnLoading ? 0.4 : 1), borderRadius: BorderRadius.circular(8.0)),
                         padding: const EdgeInsets.all(15.0),
                         child: Text("Enter Complete Address", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.bold),),
                        ),
                  ),
                )
              ],
            ),
            ),
                      ],
                    )
              ],
            )
                  ],
        ),
      ),
    );
  }


  Widget loading(){
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(ScreenUtil().setHeight(14), ScreenUtil().setWidth(80), 5),
        SizedBox(height: 10,),
        ShimmerContainer(ScreenUtil().setHeight(14), ScreenUtil().setWidth(200), 5),
        
      ],
    );
  }
}


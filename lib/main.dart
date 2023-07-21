import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qfoods/Navigation/BottomNavigation.dart';
import 'package:qfoods/Provider/CartProvider.dart';
import 'package:qfoods/Provider/FilterSelectedProvider.dart';
import 'package:qfoods/Provider/GroceryCartProvider.dart';
import 'package:qfoods/Provider/GroceryHomeProvider.dart';
import 'package:qfoods/Provider/HomeProvider.dart';
import 'package:qfoods/Provider/SelectedVariantProvider.dart';
import 'package:qfoods/helpers/Notification_services.dart';
import 'package:qfoods/screens/LoginScreen/LoginScreen.dart';
import 'package:qfoods/screens/SignUpScreen/SignUpScreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message?.notification?.title}');
  if(message.notification != null){
  NotificationService.createNotification(message, "background");
}
}

void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
NotificationService.initalize();

final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = ((prefs.getBool('isLogged') == null) ? false : prefs.getBool('isLogged')) ?? false;
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home:  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => CartProvider())),
         ChangeNotifierProvider(create: ((context) => GroceryCartProvider())),
         ChangeNotifierProvider(create: ((context) => SelectedVariantProvider())),
          ChangeNotifierProvider(create: ((context) => HomeProvider())),
          ChangeNotifierProvider(create: ((context) => GroceryHomeProvider())),
           ChangeNotifierProvider(create: ((context) => FilterSelectedProvider()))
      ],
      child: MaterialApp(
        title: 'Qfoods',
        debugShowCheckedModeBanner: false,
           home: ScreenUtilInit(
         designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
            builder: ((context, child) {
              return SafeArea(child: isLoggedIn ? BottomNavigation() : LoginScreen());
            }),
           )
      ),
    )));
   
}



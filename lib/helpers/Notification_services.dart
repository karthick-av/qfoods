
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void TapBackgroundReponse(NotificationResponse notificationResponse){
  print(notificationResponse?.toString());
}


class NotificationService{
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();


static  void initalize() async{


   const InitializationSettings  initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
   );

 await  notificationsPlugin.initialize(initializationSettings,
   onDidReceiveBackgroundNotificationResponse: TapBackgroundReponse,
   onDidReceiveNotificationResponse:(details) {
     
   },
   );
   
   FirebaseMessaging.onMessage.listen((message) {
  print(message.notification?.title);
if(message.notification != null){
  createNotification(message, "foreground");
}
});

   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
        print("onMessageOpenedApp: $message");
   });
  }





  static void createNotification(RemoteMessage remoteMessage,String type) async{
    final id =DateTime.now().millisecondsSinceEpoch ~/ 1000;

  try{
  NotificationDetails notificationDetails;
   if(type == "background"){
 notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails("default_notification_channel_id", "default_notification_channel",
      importance: Importance.max,
      priority: Priority.high,
      timeoutAfter: 7000
      )
    );
   }else{
 notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails("default_notification_channel_id", "default_notification_channel",
      importance: Importance.max,
      priority: Priority.high,
      timeoutAfter: 7000
      )
    );
   }


    await notificationsPlugin.show(
      id, 
      remoteMessage.notification?.title, 
      remoteMessage.notification?.body, 
      notificationDetails);
  }
  on Exception catch(e){
    print(e);
  }
  }
}
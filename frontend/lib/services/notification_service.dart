import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService{

  static void initialize(){
    //for ios et web
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((event) {
      print('A new onMessage event was published');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }
  
}
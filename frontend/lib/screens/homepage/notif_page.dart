import 'package:adawati/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FlutterLocalNotificationsPlugin localNotification=FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    var androidInitialize = new AndroidInitializationSettings('launcher_icon');
   // var iOSIntialize = new InitializationSettings();
    var initialzationSettings = new InitializationSettings(android: androidInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzationSettings);
  }
  Future _showNotification()async{
    var androidDetails = new AndroidNotificationDetails("channelId", "Local Notification",importance: Importance.high);
    var generalNotificationDetails =  new NotificationDetails(android: androidDetails);
    await localNotification.show(0, "Adawati Notification", "Ceci est une notification de Adawati app",generalNotificationDetails);
    


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
    
        title:  Text(
          "Mes notifications",
          style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor:kontColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), onPressed: () {  Navigator.of(context).pop();},
        ),actions: <Widget>[
         
        ],
      
      ),
      
      body: listView(),
      
      floatingActionButton: FloatingActionButton(onPressed: _showNotification,
      child: Icon(Icons.notifications),
      ),
    );
  }
  Widget listView(){

    return ListView.separated(
      itemBuilder: (context,index){
        return listViewItem(index);
      }, 
      separatorBuilder: (context,index){
        return Divider(height: 0,);
      }, 
      itemCount: 7);
  }
  Widget listViewItem(int index){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13,vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(),
          Expanded(
            child: Container(
                    margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  message(index),
                  timeAndDate(index),
                ],
              ),
            ),
          ),
        ],
      ),
    );
}
Widget prefixIcon(){
  return Container(
    height: 50,
    width: 50,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.grey.shade300,
    ),
    child: Icon(Icons.notifications,size: 25,color: Colors.grey.shade700,),
  );
}
Widget message(int index){
  double textSize = 14;
  return Container(
    child: RichText(
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
 text: 'Message',
 style: TextStyle(fontSize: textSize,color: Colors.black,fontWeight: FontWeight.bold),
 children: [
  TextSpan(
    text: 'Description du message',
    style: TextStyle(fontWeight: FontWeight.w400),
  )
 ]
      ),
      ),

  );
}
Widget timeAndDate(int index){
  return Container(
    margin: EdgeInsets.only(top: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('22-05-2023',
        style: TextStyle(
          fontSize: 10,
        ),),
          Text('10:00 am',
        style: TextStyle(
          fontSize: 10,
        ),),

    ]),
  );
}
}
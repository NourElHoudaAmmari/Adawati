import 'package:flutter/material.dart';

class MyDateUtil{
  static String getFormattedTime(
    {required BuildContext context , required String time}){
      final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime({required BuildContext context, required String time}){
 final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
 final DateTime now = DateTime.now();
 if(now.day == sent.day && now.month == sent.month && now.year == sent.year){
  return TimeOfDay.fromDateTime(sent).format(context);
 }
 return '${sent.day} ${_getMonth(sent)}';
  }
 static String getLastActiveTime(
    { required BuildContext context , required String lastActive}){
      final int i = int.tryParse(lastActive)?? -1;
      if( i == -1)return 'vu pour la dernière fois non disponible';
      DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
      DateTime now = DateTime.now();
      String formattedTime = TimeOfDay.fromDateTime(time).format(context);
      if(time.day == now.day &&
      time.month == now.month &&
      time.year == now.year){
        return "vu la dernière fois aujourd'hui à $formattedTime";
      }
      if((now.difference(time).inHours /24).round() == 1){
        return 'vu la dernière fois hier à $formattedTime';
      }
      String month = _getMonth(time);
      return 'vu pour la dernière fois le ${time.day} $month le $formattedTime';
    }
   static String _getMonth(DateTime date){
    switch(date.month){
      case 1:
      return 'Jan';
      case 2:
      return 'Fev';
    case 3:
    return 'Mars';
    case 4:
    return 'Avril';
    case 5:
    return 'Mai';
    case 6:
    return 'Jun';
    case 7:
    return 'Juil';
    case 8:
    return 'Aout';
    case 9:
    return 'Sep';
    case 10:
    return 'Oct';
    case 11:
    return 'Nov';
    case 12:
    return 'Dec';
    }
    return 'NA';
    }


    static String getMessageTime({required BuildContext context,required String time }){
      final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
      final DateTime now = DateTime.now();

      final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
      if(now.day == sent.day &&
      now.month == sent.month &&
      now.year == sent.year){
        return formattedTime;
    }
    return now.year == sent.year
    ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
    : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';

  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonProvider with ChangeNotifier{
  late DocumentSnapshot donData;

  getDonDetails(details){
    this.donData =details;
    notifyListeners();
  }
}
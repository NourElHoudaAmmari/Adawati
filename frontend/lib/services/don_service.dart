import 'dart:convert';

import 'package:adawati/models/don_model.dart';
import 'package:http/http.dart' as http;

import '../Config/config.dart';

class APIService{
  static var client =http.Client();
  static Future<List<DonModel>?> getDons()async{
    Map<String, String> requestHeaders={'Content-Type':'application/json'};
    var url =Uri.http(Config.apiURL, Config.donURL);
    var response = await client.get(url, headers:requestHeaders);
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return donsFromJson(data["data"]);
    }else{
      return null;
    }

  }
  static Future<bool> saveDon(
    DonModel model,
    bool isEditMode,
    bool isFileSelected,
  )async{
    var donURL = Config.donURL;
    if(isEditMode){
      donURL = donURL + "/"+model.id.toString();
    }
    var url = Uri.http(Config.apiURL,Config.donURL);
    var requestMethod = isEditMode? "PUT":"POST";
    var request = http.MultipartRequest(requestMethod,url);
    request.fields["donName"]=model.donTitre!;
    request.fields["donDescription"]= model.donDescription!;
    if(model.donImage !=null && isFileSelected){
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'donImage',
        model.donImage!,
      );
      request.files.add(multipartFile);
    }
    var response = await request.send();
   if(response.statusCode == 200){

   return true;
    }else{
      return false;
    }
  }
  static Future<bool> deleteDon(donId)async{
    Map<String, String> requestHeaders = {'Content-Type':'application/json'};
    var url=Uri.http(Config.apiURL,Config.donURL+"/"+donId);
    var response = await client.delete(url,headers: requestHeaders);
    if(response.statusCode ==200){
      var data = jsonDecode(response.body);
      return true;
    }else{
      return false;
    }
  }
}
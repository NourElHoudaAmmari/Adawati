List<DonModel> donsFromJson(dynamic str)=>
List<DonModel>.from((str).map((x)=>DonModel.fromJson(x)));
class DonModel{
  late String? id;
  late String? donTitre;
  late String? donDescription;
   late String? donImage;
   late String? donUserID;
   late String? donUserName;
   late bool? isMyFavouritedon;
   late int? donFavoriteCount;

  DonModel({
    this.id,
    this.donTitre,
    this.donDescription,
    this.donImage,
    this.donUserID,
    this.donUserName,
    this.isMyFavouritedon,
    this.donFavoriteCount,
   });

   DonModel.fromJson(Map<String, dynamic>json){
    id=json["_id"];
    donTitre=json["donTitre"];
     donDescription=json["donDescription"];
     donImage=json["donImage"];
     donUserID=json["donUserID"];
      donUserName=json["donUserName"];
     donFavoriteCount=json["donFavoriteCount"];
     isMyFavouritedon=json[" isMyFavouritedon"];

   }
   Map<String, dynamic> toJson(){
    final _data = <String, dynamic>{};
    _data["_id"]=id;
    _data["donTitre"]=donTitre;
    _data["donDescription"]=donDescription;
    _data["donImage"]=donImage;
     _data["donUserName"]=donUserID;
      _data["donUserName"]=donUserName;
        _data["donFavoriteCount"]=donFavoriteCount;
          _data["isMyFavouritedon"]=isMyFavouritedon;

    return _data;

   }
}
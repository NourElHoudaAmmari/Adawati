List<DonModel> donsFromJson(dynamic str)=>
List<DonModel>.from((str).map((x)=>DonModel.fromJson(x)));
class DonModel{
  late String? id;
  late String? donTitre;
  late String? donDescription;
   late String? donImage;

  DonModel({
    this.id,
    this.donTitre,
    this.donDescription,
    this.donImage,
   });

   DonModel.fromJson(Map<String, dynamic>json){
    id=json["_id"];
    donTitre=json["donTitre"];
     donDescription=json["donDescription"];
     donImage=json["donImage"];

   }
   Map<String, dynamic> toJson(){
    final _data = <String, dynamic>{};
    _data["_id"]=id;
    _data["donTitre"]=donTitre;
    _data["donDescription"]=donDescription;
    _data["donImage"]=donImage;

    return _data;

   }
}
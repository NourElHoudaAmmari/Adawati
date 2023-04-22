class DemandeModel {
  final id,description,userId,userName;

  DemandeModel({this.id,  this.description,this.userId,this.userName} );

Map<String, dynamic>add_data(){
  return { 
    "id":id,
  "description":description,
  "userId":userId,
  "userName":userName,
  };
 
}
Map<String, dynamic> toMap() {
    return {

      'description': description,
      'userId': userId,
      'userName': userName,
      'id': id,
    };
  }
}

class DemandeModel {
  final id,description;

  DemandeModel({this.id,  this.description} );

Map<String, dynamic>add_data(){
  return { 
    "id":id,
  "description":description
  };
 
}
}

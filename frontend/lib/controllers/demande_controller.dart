
import 'package:adawati/models/demande_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference _demande = FirebaseFirestore.instance.collection("demande");
class DemandeController {
  Future add_demande(DemandeModel demande) async {
    await _demande.doc().set(demande.add_data());
  }
  Future update_demande(DemandeModel demande) async
{
  await _demande.doc(demande.id).update(demande.add_data()); 
}   Future delete_demande(DemandeModel demande) async{
    await _demande.doc(demande.id).delete();

   }
}
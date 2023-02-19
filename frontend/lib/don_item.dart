import 'package:adawati/models/don_model.dart';
import 'package:flutter/material.dart';

class DonItem extends StatelessWidget {
  const DonItem({Key? key, this.model, required this.onDelete}):super(key: key);
final DonModel? model;
final Function onDelete;
  @override
  Widget build(BuildContext context) {
    return Card(
elevation: 0,
margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
child:Container(
  width: 200,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(50),
    ),
    child: donWidget(context),
)
    );
  }
   Widget donWidget(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10),
          child: Image.network(
            (model!.donImage == null || model!.donImage =="")
            ?"https://images.epagine.fr/189/9782803458189_1_75.jpg"
:model!.donImage!,
height: 70,
fit: BoxFit.scaleDown, 
         ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model!.donTitre!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("${model!.donDescription}",style: const TextStyle(color: Colors.black
              ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width -180,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.edit),
                      onTap: (){
                        Navigator.of(context).pushNamed(
                          '/edit-don',
                          arguments: {'model':model},
                        );
                      },
                    ),
                      GestureDetector(
                      child: const Icon(Icons.delete,
                      color: Colors.red,
                      ),
                      onTap: (){
                        onDelete!(model);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ]);
   }
}
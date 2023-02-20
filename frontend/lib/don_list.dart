

import 'package:adawati/don_item.dart';
import 'package:adawati/models/don_model.dart';
import 'package:flutter/material.dart';

class DonList extends StatefulWidget {
  const DonList({super.key});

  @override
  State<DonList> createState() => _DonListState();
}

class _DonListState extends State<DonList> {
  List<DonModel> dons=List<DonModel>.empty(growable: true);
  @override

  @override
  void initState(){
  super.initState();
  dons.add(
DonModel(
id: "1",
donTitre: "livre",
donDescription: "livre de mathematique",
donImage: "https://images.epagine.fr/189/9782803458189_1_75.jpg",
),
  );
   dons.add(
DonModel(
id: "2",
donTitre: "livre",
donDescription: "livre de lecture",
donImage: "https://images.epagine.fr/189/9782803458189_1_75.jpg",
),
  );
   dons.add(
DonModel(
id: "3",
donTitre: "livre",
donDescription: "livre de exercice",
donImage: "https://images.epagine.fr/189/9782803458189_1_75.jpg",
),
  );
  }
  Widget donList(dons){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Colors.green,
                  minimumSize: const Size(88, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: const RoundedRectangleBorder(
borderRadius: BorderRadius.all(
  Radius.circular(10)
)
                  )
                ),
                onPressed: (){
                  Navigator.pushNamed(context, "/add-don");
                },
                child: const Text("Add Don"),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: dons.length,
                itemBuilder: (context, index) {
                  return DonItem(
                    model: dons[index],
                    onDelete: (DonModel model){},
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("  Gestion des dons"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: donList(dons),
    );
  }
}
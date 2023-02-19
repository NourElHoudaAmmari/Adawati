// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, avoid_returning_null_for_void, must_be_immutable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
 
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:(){},
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
       // elevation: 0,
       // shape: BeveledRectangleBorder(
         // borderRadius: BorderRadius.circular(20.0),
        //  side:BorderSide(color: Colors.blue,width: 2.0,style: BorderStyle.solid),
     // ),
    // mini: true,
      ),
      key: _key,
      
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          "Adawati",
          style: TextStyle(color: Colors.deepOrange[800], fontSize: 17,fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,

        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color.fromARGB(255, 103, 103, 103),
          ),
          onPressed: () {
            _key.currentState?.openDrawer();
          },
        ),
        // backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Color.fromARGB(255, 103, 103, 103),
              ),
              onPressed: () {}),
          IconButton(
              icon: Icon(
                Icons.search,
                color: Color.fromARGB(255, 103, 103, 103),
              ),
              onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: Column(
          children: [
            Container(
  
              height: 150,
              decoration: BoxDecoration(
                
                image: DecorationImage(
                  
                  fit:BoxFit.cover,
                  
                  image: NetworkImage('https://i0.wp.com/scolaire.ma/wp-content/uploads/2022/08/Fourniture-Scolaire-a-bas-prix-.png?resize=820%2C520&ssl=1'),
                  ),
                   color: Color.fromARGB(255, 226, 224, 223),
                   
                borderRadius: BorderRadius.circular(10)),
        child: Row(
          
          children:[
            
TextButton(onPressed: ()=>null, child: Text('Don'),

style: ButtonStyle(
  
foregroundColor: MaterialStateProperty.all(Colors.white),
backgroundColor: MaterialStateProperty.all(Colors.red),

shape: MaterialStateProperty.all<RoundedRectangleBorder>(
RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20),
  side: BorderSide(color: Colors.red)
)
),
),),
SizedBox(width: 5,),
TextButton(onPressed: ()=>null, child: Text('Demande'),
style: ButtonStyle(
foregroundColor: MaterialStateProperty.all(Colors.red),
backgroundColor: MaterialStateProperty.all(Colors.white),
shape: MaterialStateProperty.all<RoundedRectangleBorder>(
RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(20),
  side: BorderSide(color: Colors.red)
)
),
),),
          ],
        ),
     
            ),
            Row(
              children: [
                Container(
                  height: 230,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Color(0xffd9dad9),
                    borderRadius: BorderRadius.circular(10),
                  ),
   child: Column(
    children: [
      Expanded(
        flex: 2,
        child: Image.network('https://images.epagine.fr/is/5449/6192202607737_1_m.jpg'),
        ),
        Expanded(child: Container(
          child: Column(
            children: [
              Text(
                'Livre de lecture',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ))
    ],
   ),
                )
              ],
            )
          ],
          
        ),
      
      ),
      
    );
  }
}

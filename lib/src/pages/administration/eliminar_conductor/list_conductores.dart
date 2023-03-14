import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/widgets/button_app.dart';
class ListDriverPage extends StatefulWidget {
  @override
_ListDriverPageState createState() => _ListDriverPageState();
  }

  class _ListDriverPageState extends State<ListDriverPage>{
String id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //_con.init(context);
    });
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black,),
        backgroundColor: Colors.black,
          body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Drivers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data.docs;

                  return ListView(
                      children: documents
                          .map((doc) => GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, 'admin/delete/driver', arguments: {
                            'id': doc['id'],
                            'usernamee': doc['username'].toString(),
                          });
                        }
                          ,
                        child: Card(
                          child: ListTile(
                            tileColor: blackColors,
                            title: Text(doc['username'], style: TextStyle(color: Colors.white),),
                            subtitle: Text(doc['cellnumber'], style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      )
                      )
                          .toList());/* GestureDetector(
                    onTap: () {
                      documents.map((doc)=>
                          Navigator.pushNamed(context, 'Menu', arguments: {
                            'id': doc['id'],
                          })
                      ).toList();

                    },*/
                  //  child:

                 // );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                } else {
                  return Center(
                    child: Text("Loading"),
                  );
                }
              }));
    }
  }

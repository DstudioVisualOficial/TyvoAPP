import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:uber/src/homes/utils/color.dart';

  class ListAdminPage extends StatefulWidget {
  @override
_ListAdminPageState createState() => _ListAdminPageState();
  }

  class _ListAdminPageState extends State<ListAdminPage>{
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
              stream: FirebaseFirestore.instance.collection('Admins').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data.docs;

                  return ListView(
                      children: documents
                          .map((doc) => GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, 'admin/delete/admin', arguments: {
                            'id': doc['id'],
                            'usernamee': doc['username'].toString(),
                          });
                        }
                          ,
                        child: Card(
                          child: ListTile(
                            tileColor: blackColors,
                            title: Text(doc['username'], style: TextStyle(color: Colors.white),),
                            subtitle: Text(doc['email'], style: TextStyle(color: Colors.white),),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber/src//utils/colors.dart' as utils;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/pages/driver/HistoryAgenda/registrar_saldo_controller.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/utils/relative_time_util.dart';
import 'package:uber/src/widgets/button_app.dart';
class HistorialAgendaPage extends StatefulWidget {
  @override
_HistorialAgendaPageState createState() => _HistorialAgendaPageState();
  }

  class _HistorialAgendaPageState extends State<HistorialAgendaPage>{
String id;
CollectionReference _ref;
AuthProvider _authProvider;
    RegistrarSaldoController _con = new RegistrarSaldoController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT');
    _authProvider = new AuthProvider();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //_con.init(context);
    });
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.grey,),
          body: StreamBuilder<QuerySnapshot>(
              stream:  FirebaseFirestore.instance.collection('Agenda').where("iddriver", isEqualTo: _authProvider.getUser().uid).orderBy("timestamp", descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> documents = snapshot.data.docs;
                  return ListView(
                      children: documents
                          .map((doc) => GestureDetector(

                        onTap: (){
                          Navigator.pushNamed(context, 'HistorialAgendaDetail', arguments: {
                            'from': doc['from'],
                            'to': doc['to'],
                            'nameClient': doc['nameClient'],
                            'nameDriver':doc['nameDriver'],
                            'timestamp':doc['timestamp'].toString(),
                            'price': doc['price'].toString(),
                            'comentario': doc['comentariodes'],
                            'km': doc['km'],
                            'min': doc['min'],
                            'status': doc['status'],
                            'fecha': doc['fecha']

                          });
                        }
                          ,
                        child: Card(
                          child: ListTile(
                            title: Text(doc['from'],style: TextStyle(
                              fontSize: 12
                            ),maxLines: 1),
                            subtitle: Text(doc['to'],style: TextStyle(
                                fontSize: 12),maxLines: 1),
                            autofocus: true,
                            trailing: Text("\$"+doc['price'].toString()+"  "+ RelativeTimeUtil.getRelativeTime( doc['timestamp'].hashCode ?? 0 ),maxLines: 1, style: TextStyle(fontSize: 12,)) ,
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

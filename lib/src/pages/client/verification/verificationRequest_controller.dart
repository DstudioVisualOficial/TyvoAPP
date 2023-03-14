
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/pages/client/map/client_map_page.dart';
import 'package:uber/src/pages/home/home_page.dart';
import 'package:uber/src/utils/shared_pref.dart';
class verificationRequestController {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  BuildContext context;
  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future init(BuildContext context)async{
    this.context = context;
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void regSolicitud(){
    Navigator.pushNamed(context, 'client/travel/request', arguments: {
      'from': from,
      'to' : to,
      'fromLatLng': fromLatLng,
      'toLatLng': toLatLng,
    });
  }

  void regCancelarSolicitud() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => ClientMapPage()));
  }
  }

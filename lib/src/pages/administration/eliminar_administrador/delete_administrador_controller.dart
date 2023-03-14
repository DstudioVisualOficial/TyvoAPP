import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/utils/relative_time_util.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
class DeleteAdminController {
  BuildContext context;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  String id;
  String username;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController saldoController = new TextEditingController();

  DriverProvider driverProvider;
  Future init(BuildContext context, Function refresh )async {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    username = arguments['usernamee'];
    id = arguments['id'];
    refresh();
    this.context = context;
    driverProvider = new DriverProvider();
    print(id);
    print(username);

  }



  displaySnackBar(text) {

  }


  void EliminarConductor()async{
    try{
    utils.Snackbar.showSnacbar(context, key, ' Eliminando Administrador...');
    await FirebaseFirestore.instance.collection("Admins").doc(id.toString()).delete().whenComplete(
          () {
        print('=======================ACHIVO ELIMINADO===================');
        utils.Snackbar.showSnacbar(context, key, 'Administrador Eliminado');
        menu();
      },
    );}
    catch(error){
      utils.Snackbar.showSnacbar(context, key, 'DeleteAdmin Ocurrio un error: $error');
    }
}

  void menu() {
    utils.Snackbar.showSnacbar(context, key, 'Redireccionando...');
    Future.delayed(Duration(milliseconds: 1000),()
    {
      Navigator.pushNamedAndRemoveUntil(context, 'Menu', (route) => false);
    });

  }
  }


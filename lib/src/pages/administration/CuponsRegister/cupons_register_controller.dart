import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uber/src/models/cupons.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/cupons_provider.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uuid/uuid.dart';
class CuponsRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController ciudadController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
  TextEditingController descuentoController = new TextEditingController();
  TextEditingController viajesController = new TextEditingController();
  TextEditingController diasController = new TextEditingController();
  CuponsProvider cuponsProvider;
  AuthProvider authProvider;
  var uuid = Uuid();
  Future init(BuildContext context, Function refresh )async {
    refresh();
    this.context = context;
    authProvider = new AuthProvider();
    cuponsProvider = new CuponsProvider();
  }
  void RegistrerCupon()async{
    utils.Snackbar.showSnacbar(context, key, "Codigo Registrado");
    String txtciudad = ciudadController.text.trim();
    String txtcode = codeController.text.trim();
    String txtdescuento = descuentoController.text.trim();
    String txtviajes = viajesController.text.trim();
    String dias = diasController.text.trim();
         Cupons cupons = new Cupons(
        id:txtcode,
        idAdmin: authProvider.getUser().uid,
        code: txtcode,
        descuento: txtdescuento,
        viajes: txtviajes,
        ciudad: txtciudad,
             dias:dias
      );
      await cuponsProvider.create(cupons);
      Navigator.pushNamedAndRemoveUntil(context, 'Menu', (route) => false);
  }

}


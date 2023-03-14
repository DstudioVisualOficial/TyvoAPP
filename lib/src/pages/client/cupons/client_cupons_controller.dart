
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';
import 'package:uber/src/models/cupons.dart';
import 'package:uber/src/pages/client/map/client_map_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/cupons_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/models/cuponsHistory.dart';
import 'package:uber/src/providers/history_cupons_provider.dart';
import 'dart:async';
import 'package:progress_dialog/progress_dialog.dart';


import 'package:uuid/uuid.dart';
class ClientCuponsController {
  static final DateTime now = DateTime.now();
  static final DateFormat formatter =DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  var hoy = DateTime.now();
  var nuevafecha;
  BuildContext context;
  Function refresh;
  var uuid = Uuid();
  CuponsProvider _cuponsProvider;
  Cupons _cupons;
  Client _client;
  AuthProvider _authProvider;
  ClientProvider _clientProvider;
  HistoryCuponsProvider _historyCuponsProvider;
  StreamSubscription<DocumentSnapshot> _streamSubscription1;
  StreamSubscription<DocumentSnapshot> _streamSubscription2;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  TextEditingController cuponController = new TextEditingController();
  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    print(formatted);
    this.context = context;
    this.refresh = refresh;
    _cuponsProvider = new CuponsProvider();
    _cupons = new Cupons();
    _client = new Client();
    _clientProvider = new ClientProvider();
  //  _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    _historyCuponsProvider = new HistoryCuponsProvider();
  _authProvider  = new AuthProvider();
  }

  void salircupon () {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ClientMapPage(),
      ),
          (route) => false,
    );
  }
  void checkcupon() async{
   // _progressDialog.show();
    String cupon = cuponController.text.trim();
     Stream<DocumentSnapshot> admintype =  _cuponsProvider.getByIdStream(cupon);
    _streamSubscription1 = admintype.listen((DocumentSnapshot document) async {
      try {
        Cupons CuponsType = Cupons.fromJson(document.data());
        print(CuponsType.code);
        print(CuponsType.viajes);
        if (CuponsType.code.toString() == cupon)  {
          print('=======================SI ES EL CODIGO===================');
          _streamSubscription1?.cancel();
          Stream<DocumentSnapshot> clientcheck =  _clientProvider.getByIdStream(_authProvider.getUser().uid);
          _streamSubscription2 = clientcheck.listen((DocumentSnapshot document) async {
              ClientPhone clientPhone = ClientPhone.fromJson(document.data());
              if(clientPhone.code == cupon) {
               // checkfecha(clientPhone.fechavencimiento);
             //   _progressDialog.hide();
                print('=========================YA UTILIZADO ESTE CUPON==============================');
                utils.Snackbar.showSnacbar(context, key, "Este codigo ya fue registrado.");
                //salircupon();
                _streamSubscription2?.cancel();

              }
              else{
                _streamSubscription2?.cancel();
                await FirebaseFirestore.instance.collection('CuponsHistory').where('idclient', isEqualTo: _authProvider.getUser().uid).where("code", isEqualTo: cupon).get()
                 .then((result){
                if(result.docs.length>0) {
                //  _progressDialog.hide();
                  utils.Snackbar.showSnacbar(context, key, "Ya no puedes usar este codigo.");
                  print("YA TIENE REGISTRADO SU CODIGO");
                }
                 else{
                //  _progressDialog.hide();
                  registrardatos(cupon, CuponsType.descuento, CuponsType.viajes, CuponsType.ciudad, CuponsType.dias);
                }
                });
                    // print("YA TIENE REGISTRADO SU CODIGO"),
                // onError: (e) =>print("YA TIENE REGISTRADO SU CODIGO"));// registrardatos(cupon, CuponsType.descuento, CuponsType.viajes, CuponsType.ciudad));





              }

       });
        }
        else {
          _streamSubscription1?.cancel();
          _streamSubscription2?.cancel();
         // _progressDialog.hide();
          print('=======================NO ES EL CODIGO====================');
          utils.Snackbar.showSnacbar(context, key, "Este codigo no existe.");

        }
      }
      catch(e){
       // _progressDialog.hide();
        _streamSubscription1?.cancel();
      _streamSubscription2?.cancel();
        print('=======================NO ES EL CODIGO====================');
        utils.Snackbar.showSnacbar(context, key, "Este codigo no existe.");


      }

    });


  }

  registrardatos(String cupon, String descuento, String viajes, String ciudad, String dias) async {
    print('==========================NO ENCONTRADO===========================');
    print('=================================================================== ');
    print('ID : '+uuid.v4());
    print('IDCLIENT :'+ _authProvider.getUser().uid);
    print('CODE: '+cupon);
    print('DESCUENTO: ' + descuento);
    print('VIAJES: '+ viajes);
    print('CIUDAD: '+ ciudad);
    print('DIAS: '+ dias);
    print('=================================================================== ');
    print('=================================================================== ');
    print('Se ha ingresado Correctamente');
    print('=================================================================== ');
    print('=================================================================== ');
    int diascheck = int.parse(dias.toString().trim());
    nuevafecha = hoy.add(Duration(days: diascheck));

    await utils.Snackbar.showSnacbar(context, key, "Se ha ingresado Correctamente");
    Map<String, dynamic> date = {
      'code': cupon.toString(),
      'viajes': viajes.toString(),
      'fechavencimiento': nuevafecha,
      'descuento': descuento.toString()
    };
    await _clientProvider.update(date, _authProvider
        .getUser()
        .uid);
    CuponsHistory hsty = new CuponsHistory(
      id: uuid.v4(),
      idclient:_authProvider.getUser().uid,
      code: cupon.toString(),
      viajes: viajes.toString(),
      descuento: descuento.toString(),
      ciudad: ciudad.toString(),
    );;
    await _historyCuponsProvider.create(hsty);
    //_progressDialog.hide();
    utils.Snackbar.showSnacbar(context, key, "El codigo fue activado exitosamente");
    salircupon();
  }



  /*void register()async{
    nameClient = nameClientController.text;
    print("Destino: $from");
    print("inicio: $to");
    try{
      TravelHistoryAgenda client = new TravelHistoryAgenda(
        id: uuid.v4(),
        iddriver:_provider.getUser().uid,
        nameDriver: username,
        nameClient: nameClient,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        to: to,
        from: from,
        price:priceDecimal,
      );
      await _authProvider.create(client);
      print('El usuario registro la cotizacion correctamente ');
      await utils.Snackbar.showSnacbar(context, key, "Registrado Correctamente");
      await Future.delayed(Duration(milliseconds: 3000),(){
        Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
      });

    }
    catch(error){
      print(error);
      print('El usuario no se pudo registrar');
      utils.Snackbar.showSnacbar(context, key, "Error no se puede registrar");
      TravelHistoryAgenda client = new TravelHistoryAgenda(
        id: uuid.v4(),
        iddriver:_provider.getUser().uid,
        nameDriver: username,
        nameClient: nameClient,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        to: to,
        from: from,
        price:priceDecimal,
      );
      await _authProvider.create(client);
      print('El usuario registro la cotizacion correctamente ');
      await utils.Snackbar.showSnacbar(context, key, "Registrado Correctamente");
      await Future.delayed(Duration(milliseconds: 3000),(){
        Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
      });
    }
  }*/
}
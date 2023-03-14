import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';
import 'package:uber/src/models/travel_info.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/geofire_provider.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/providers/travel_info_provider.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:url_launcher/url_launcher.dart';
class DriverTravelRequestController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey();
  Function refresh;
  SharedPref _sharedPref;

  String from;
  String to;
  String idClient;
  ClientPhone client;
  StreamSubscription<DocumentSnapshot> _streamStatusSubscription;
  ClientProvider _clientProvider;
  TravelInfoProvider _travelInfoProvider;
  AuthProvider _authProvider;
  GeofireProvider _geofireProvider;


  Timer _timer;
  int seconds = 25;

  Future init (BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _sharedPref.remove('isNotification');
    _sharedPref.save('isNotification', 'false');

    _clientProvider = new ClientProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _geofireProvider = new GeofireProvider();

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    print('Arguments: $arguments');

    from = arguments['origin'];
    to = arguments['destination'];
    idClient = arguments['idClient'];
    //verificstatus();
    getClientInfo();
    startTimer();
   // _checkClientResponse();
    check();
  }

  void dispose () {
    _streamStatusSubscription?.cancel();
    _timer?.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = seconds - 1;
      refresh();
      if (seconds == 0) {
        cancelTravel();
      }
    });
  }
  void check()async{
    DocumentSnapshot documento = await FirebaseFirestore.instance.collection('TravelInfo').doc(idClient).get();
    TravelInfo travelInfo;
    if(documento.exists) {
      travelInfo = TravelInfo.fromJson(documento.data());
      if(travelInfo.status == 'accepted') {

        saveStatusClient('Ultimo viaje: Otro Conductor Acepto el Viaje');
        print('Otro conductor acepto el viaje');
        //utils.Snackbar.showSnacbar(context, key, 'Otro conductor acepto el viaje');


        dispose();
        Navigator.pushNamedAndRemoveUntil(
            context, 'driver/map', (route) => false);
      }
      else
      {

        if(travelInfo.status == 'finished') {
          saveStatusClient('Ultimo viaje: Otro Conductor Finalizo el Viaje');

          print('Otro conductor ha finalizado el viaje');
          //utils.Snackbar.showSnacbar(context, key, 'Otro conductor ha finalizado el viaje');

          dispose();
          Navigator.pushNamedAndRemoveUntil(
              context, 'driver/map', (route) => false);

        }
        else
        {
          if (travelInfo.status == 'cancel_finished') {
            saveStatusClient('Ultimo viaje: Otro Conductor Cancelo');

            print('Otro conductor cancelo el viaje');
            // utils.Snackbar.showSnacbar(context, key, 'Otro conductor cancelo el viaje');
            dispose();

            Navigator.pushNamedAndRemoveUntil(
                context, 'driver/map', (route) => false);
          }
          else
          {
            if(travelInfo.clientstatus == 'no_accepted' ){
              saveStatusClient('Ultimo viaje: Cliente Cancelo');
              Map<String, dynamic> data = {


                'clientstatus': 'acc',
                'status': 'no_accepted',
              };

              _travelInfoProvider.update(data, idClient);
              print('El cliente cancelo el viaje');
              //     utils.Snackbar.showSnacbar(context, key, 'El cliente cancelo el viaje');

              dispose();

              Navigator.pushNamedAndRemoveUntil(
                  context, 'driver/map', (route) => false);


            }
            else
            {
              return ;
            }
          }
        }
      }
    }
  }

  void acceptTravel() async{
      verificstatus();
  }



  void cancelTravel(){
    /*final player = AudioCache();
    player.clear('alert.mp3');
    player.clearCache();*/
    // player.fixedPlayer.stop();
    dispose();
    saveStatusClient('Haz rechazado la llamada');

    /* Map<String, dynamic> data = {
      'status': 'no_accepted',
      'clientStatus':'acc',
    };*/
    _timer?.cancel();
    // _travelInfoProvider.update(data, idClient);

    Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
  }

  Future<void> verificstatus() async {
    //Verificacion si otro conductor agarro el viaje.
    DocumentSnapshot documento = await FirebaseFirestore.instance.collection('TravelInfo').doc(idClient).get();
    TravelInfo travelInfo;
    if(documento.exists) {
      travelInfo = TravelInfo.fromJson(documento.data());
      if(travelInfo.status == 'accepted') {

        saveStatusClient('Ultimo viaje: Otro Conductor Acepto el Viaje');
        print('Otro conductor acepto el viaje');
        //utils.Snackbar.showSnacbar(context, key, 'Otro conductor acepto el viaje');


          dispose();
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);


      }
      else
        {

      if(travelInfo.status == 'finished') {
        saveStatusClient('Ultimo viaje: Otro Conductor Finalizo el Viaje');

        print('Otro conductor ha finalizado el viaje');
        //utils.Snackbar.showSnacbar(context, key, 'Otro conductor ha finalizado el viaje');

          dispose();
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);

      }
      else
        {
        if (travelInfo.status == 'cancel_finished') {
          saveStatusClient('Ultimo viaje: Otro Conductor Cancelo');

          print('Otro conductor cancelo el viaje');
         // utils.Snackbar.showSnacbar(context, key, 'Otro conductor cancelo el viaje');
            dispose();
            Navigator.pushNamedAndRemoveUntil(
                context, 'driver/map', (route) => false);

        }
        else
          {
            if(travelInfo.clientstatus == 'no_accepted' ){
              saveStatusClient('Ultimo viaje: Cliente Cancelo');
              Map<String, dynamic> data = {


                'clientStatus': 'acc',
                'status': 'no_accepted',
              };

              _travelInfoProvider.update(data, idClient);
              print('El cliente cancelo el viaje');
         //     utils.Snackbar.showSnacbar(context, key, 'El cliente cancelo el viaje');

                dispose();
                Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);


            }
            else
              {
                saveStatusClient('Viaje Realizado');
                saveTravel('accepted');
                saveidClient(idClient);
               // utils.Snackbar.showSnacbar(context, key, 'Viaje Aceptado');
                Map<String, dynamic> data = await {
                  'idDriver': _authProvider.getUser().uid,
                  'status': 'accepted'
                  };
                await _travelInfoProvider.update(data, idClient);
                await _geofireProvider.delete(_authProvider.getUser().uid);
                await Navigator.pushNamedAndRemoveUntil(context, 'driver/travel/map', (route) => false, arguments: idClient);
                _timer?.cancel();

              }
        }
      }
    }}
  }
  void saveidClient(String idClient)async {
    _sharedPref.remove('idClient');
     _sharedPref.save("idClient", idClient);
  }
  void saveTravel(String typeUser)async{
    _sharedPref.remove('status');
    _sharedPref.save("status", typeUser);
  }
  void saveStatusClient(String typeUser)async{
    _sharedPref.remove('statusclient');
     _sharedPref.save("statusclient", typeUser);
  }
  void getClientInfo() async {
    client = await _clientProvider.getById(idClient);
    print('Client: ${client.toJson()}');
    refresh();
  }

/*
        if(from.isEmpty || to.isEmpty )
        {
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
        }*/

}
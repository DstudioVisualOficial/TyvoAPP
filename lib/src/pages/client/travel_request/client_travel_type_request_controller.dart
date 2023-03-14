import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
class ClientTravelTypeRequestController {

  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;
  double total;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  BuildContext context;
  Function refresh;
  final nameController = TextEditingController();

  bool Pasajero = false, Mascota = false, Paqueteria = false;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];
    total = arguments['price'];
  }
  void cancel(){
    Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
  }

  void goToRequest(){
    if (Pasajero == true) {
      Navigator.pushNamed(context, 'client/travel/request', arguments: {
        'from': from,
        'to': to,
        'fromLatLng': fromLatLng,
        'toLatLng': toLatLng,
        'price': total,
        'type': 'pasajero'
      });
    }
    else
      {
        if (Mascota == true ){
          Navigator.pushNamed(context, 'client/travel/request', arguments: {
            'from': from,
            'to': to,
            'fromLatLng': fromLatLng,
            'toLatLng': toLatLng,
            'price': total,
            'type': 'mascota',
            'nameanimals' :  nameController.text
          });
        }
        else{
          if (Paqueteria == true){
            Navigator.pushNamed(context, 'client/travel/request', arguments: {
              'from': from,
              'to': to,
              'fromLatLng': fromLatLng,
              'toLatLng': toLatLng,
              'price': total,
              'type': 'paqueteria'
            });
          }
        }
      }

  }





}
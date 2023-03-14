
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uber/src/models/code.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/code_provider.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber/src/providers/admin_provider.dart';
import 'package:uber/src/models/admin.dart';

class HomeController{
  BuildContext context;
  SharedPref _sharedPref, notificationsharepref;
  String _isNotification, pisNotification;
  String _typeUser, ptypeUser, notifiationuser, _idclient, _status;
  AuthProvider _authProvider;
  Function refresh;
  PickedFile pickedFile;
  File imageFile;
  CodeProvider _codeProvider;
  Code code;
  String image;
  StreamSubscription<DocumentSnapshot> _streamStatusSubscription;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();


  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _authProvider = new AuthProvider();
    notificationsharepref = new SharedPref();
    _codeProvider = new CodeProvider();
    notifiationuser = await _sharedPref.read('notificationtypeUser');
    _status = await _sharedPref.read('status');
    _idclient = await _sharedPref.read('idClient');
    _typeUser = await _sharedPref.read('typeUser');
    _isNotification = await _sharedPref.read('isNotification');
    checkIfUserIsAuth();
    getCode();
  }
  Future<void> checkIfUserIsAuth() async {
    bool isSigned = _authProvider.isSignedIn();
    if (isSigned) {

      if (_isNotification != 'true') {

        if(_typeUser == 'admin')
        {
              Navigator.pushNamedAndRemoveUntil(context, 'Menu', (route) => false);
          // Navigator.pushNamedAndRemoveUntil(context, 'Menu', (route) => false);
        }

          if (_typeUser == 'client') {
            if(_status == 'accepted' || _status == 'started'){
              await Navigator.pushNamedAndRemoveUntil(context, 'client/travel/map', (route) => false);
            }
            else {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'client/map', (route) => false);
              // Navigator.pushNamed(context, 'client/map');
            }
          }





            if (_typeUser == 'driver') {
              if (_status == 'accepted' || _status == 'started'){
                print(_idclient);
                await Navigator.pushNamedAndRemoveUntil(context, 'driver/travel/map', (route) => false, arguments: _idclient);
              }
              else {
                if(_status == 'startedcot' || _status == 'acceptedcot'){
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'driver/map/cotizacion/travel', (route) => false);
                }
                else
                  {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'driver/map', (route) => false);
                  }

                // Navigator.pushNamed(context, 'driver/map');
              }
            }


        }
    }
    else {
      print('NO ESTA LOGEADO');
      await Future.delayed(Duration(milliseconds: 7000),(){
        Navigator.pushNamedAndRemoveUntil(context, 'loginClient', (route) => false);
      });

    }
  }
  void gotologinpage(String typeUser){
    Navigator.pushNamed(context, "login_driver");

    saveTypeUser(typeUser);
  }

  void gotologinpageClient(String typeUser){
    Navigator.pushNamed(context, "loginClient");
    saveTypeUser(typeUser);
  }

  void getCode() async {
    code = await _codeProvider.getAll();
    image = code.image;
    refresh();
  }

  void saveTypeUser(String typeUser)async{
    _sharedPref.remove('typeUser');
    _sharedPref.save("typeUser", typeUser);
  }

}
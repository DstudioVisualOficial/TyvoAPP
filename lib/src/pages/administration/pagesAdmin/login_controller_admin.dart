
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/admin.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/pages/administration/menu/menu_admin.dart';
import 'package:uber/src/providers/admin_provider.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'dart:async';
class LoginControllerAdmin {
  Function refresh;
  StreamSubscription<DocumentSnapshot> _streamStatusSubscription;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController= new TextEditingController();
  AuthProvider _authProvider;
  SharedPref _sharedPref;
  BuildContext context;
  String _typeUser;
  String _typeNotification;
  ProgressDialog _progressDialog;
  Admin _admin;
  AdminProvider _adminProvider;
  ClientProvider _clientProvider;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Future init(BuildContext context)async{
    this.context = context;
    _authProvider = new AuthProvider();
    _sharedPref = new SharedPref();
    _adminProvider = new AdminProvider();
    _clientProvider = new ClientProvider();
    _admin  = new Admin();
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento...");

    _typeUser = await _sharedPref.read("typeUser");
    _typeNotification = await _sharedPref.read("isNotification");
    print('===================Tipo de usuario =======================');
    print(_typeUser);
    print(_typeNotification);
  }


      
  void login()async{
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    /*_progressDialog.show();*/
    print("Email: $email");
    print("Password: $password");
    try{
      bool isLogin = await _authProvider.login(email, password);

      if(isLogin){

        utils.Snackbar.showSnacbar(context, key, "Verificando...");
        _progressDialog.hide();
        print('El usuario esta logueado');
           if (_typeUser == 'admin')
          {
           Admin admin = await _adminProvider.getById(_authProvider.getUser().uid);

            if(admin != null ){
              saveTypeUser('admin');

            }
            else
            {

              utils.Snackbar.showSnacbar(context, key, "El usuario no es valido");
              await _authProvider.signOut();
            }
          }
      //  Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
      }
      else{

        utils.Snackbar.showSnacbar(context, key, "No se pudo iniciar sesion");
        _progressDialog.hide();
        print('El usuario no de pudo autenticar');

      }
    }
catch(error){
  utils.Snackbar.showSnacbar(context, key, error);
      print(error);
      _progressDialog.hide();

}
  }


  void saveTypeUser(String typeUser)async{
    _sharedPref.remove('typeUser');
     _sharedPref.save("typeUser", typeUser);
    _sharedPref.remove('isNotification');
     _sharedPref.save("isNotification", 'false');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext
            context) =>
                MenuAdmin(),
          ),
              (route) => false,
        );
      refresh();
  }

}
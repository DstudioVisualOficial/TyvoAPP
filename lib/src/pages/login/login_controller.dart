

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/utils/my_progress_dialog.dart';

class LoginController {


  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController= new TextEditingController();
  AuthProvider _authProvider;
  SharedPref _sharedPref;
  BuildContext context;
  String _typeUser;
  ProgressDialog _progressDialog;
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Future init(BuildContext context)async{
    this.context = context;
    _authProvider = new AuthProvider();
    _sharedPref = new SharedPref();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento...");

    _typeUser = await _sharedPref.read("typeUser");
    print('===================Tipo de usuario =======================');
    print(_typeUser);
  }

  
  void goToRegisterPage(){
    if(_typeUser == 'client'){
      Navigator.pushNamed(context, 'client_register');
    }
    else
      {
        Navigator.pushNamed(context, 'driver_register');
      }
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

        utils.Snackbar.showSnacbar(context, key, "Ya iniciaste sesion");
        _progressDialog.hide();
        print('El usuario esta logueado');
        if(_typeUser == 'client'){
          ClientPhone client = await _clientProvider.getById(_authProvider.getUser().uid);

          if(client != null ){
            Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
          }
          else
            {

              utils.Snackbar.showSnacbar(context, key, "El usuario no es valido");
              await _authProvider.signOut();
            }
        }
        else if (_typeUser == 'driver')
          {
           Driver driver = await _driverProvider.getById(_authProvider.getUser().uid);

            if(driver != null ){
              Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
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

}
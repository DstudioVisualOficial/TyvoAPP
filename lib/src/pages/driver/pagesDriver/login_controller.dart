

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/code.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/code_provider.dart';
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
  CodeProvider _codeProvider;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Future init(BuildContext context)async{
    this.context = context;
    _codeProvider = new CodeProvider();
    _authProvider = new AuthProvider();
    _sharedPref = new SharedPref();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento...");

    _typeUser = await _sharedPref.read("typeUser");
    print('===================Tipo de usuario =======================');
    print(_typeUser);
  }

  void saveNotification(String typeUser)async{
    _sharedPref.remove('isNotification');
    await _sharedPref.save("isNotification", typeUser);
  }
  void saveTypeUser(String typeUser)async{
    _sharedPref.remove('typeUser');
     _sharedPref.save("typeUser", typeUser);
  }
  void saveTypeUserDriver(String typeUser)async{
    _sharedPref.remove('typeUser');
    _sharedPref.save("typeUser", typeUser);
    Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
  }


  void login()async{
    utils.Snackbar.showSnacbar(context, key, "Verificando...");

  String email = emailController.text.trim();
    String password = passwordController.text.trim();
    /*_progressDialog.show();*/
    print("Email: $email");
    print("Password: $password");
    Code code = await _codeProvider.getAll();
    if (code.user == email && code.password == password){

      saveNotification("false");
      saveTypeUser("admin");
      Navigator.pushNamed(
          context,'SplashAdmin'
      );
    }
    else
    {
      try{
        bool isLogin = await _authProvider.login(email.toString(), password.toString());

        if(isLogin){

          utils.Snackbar.showSnacbar(context, key, "Ya iniciaste sesion");
          _progressDialog.hide();
          print('El usuario esta logueado');

            Driver driver = await _driverProvider.getById(_authProvider.getUser().uid);

            if(driver != null ){
              saveTypeUserDriver('driver');
            }
            else
            {

              utils.Snackbar.showSnacbar(context, key, "El usuario no es valido");
              await _authProvider.signOut();
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
        utils.Snackbar.showSnacbar(context, key, "Lo sentimos, No se pudo iniciar sesion. Verifica tu internet.");
        print(error);
        _progressDialog.hide();

      }
    }


  }


}
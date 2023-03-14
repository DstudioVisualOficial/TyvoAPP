import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/code.dart';
import 'package:uber/src/models/prices.dart';
import 'package:uber/src/pages/administration/menu/menu_admin.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/code_provider.dart';
import 'package:uber/src/providers/prices_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;

class CodeAdminController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CodeProvider _codeProvider;
  Function refresh;
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  AuthProvider _authProvider;
  BuildContext context;
  ProgressDialog _progressDialog;
  String user = '';
  String password = '';
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Future init(BuildContext context, Function refresh){
    _codeProvider = new CodeProvider();
    this.refresh = refresh;
    this.context = context;
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento...");
    _authProvider = new AuthProvider();
    Obtenerdatos();
  }


  void Obtenerdatos()async{
    Code code = await _codeProvider.getAll();
    user = code.user.toString();
    password = code.password.toString();
    refresh();
  }
  void register()async{
    print("BASE DE DATOS");

    Code code = await _codeProvider.getAll();
    print(code.user);
    print(code.password);
    user = code.user.toString();
    password = code.password.toString();
    // ignore: non_constant_identifier_names
    String USER = userController.text.trim();
    // ignore: non_constant_identifier_names
    String PASSWORD = passwordController.text.trim();

    if(USER.isEmpty && PASSWORD.isEmpty)
    {
      print("debes ingresar al menos un dato");
      utils.Snackbar.showSnacbar(context, key, "Debes ingresar al menos un dato para actualizar");
      return;
    }
    if(USER.isEmpty)
    {
      print('USUARIO ESTA VACIO');
      _progressDialog.show();
      Map<String, dynamic> data = {
          'user':user.toString(),
          'password':PASSWORD
      };
      await _codeProvider.update(data);
      _progressDialog.hide();
      signOut();
    }
    if(PASSWORD.isEmpty)
    {
      print('PASSWORD ESTA VACIO');

      _progressDialog.show();
      Map<String, dynamic> data = {
        'password': password.toString(),
        'user': USER
      };
      await _codeProvider.update(data);
      _progressDialog.hide();
      signOut();
    }
    _progressDialog.show();
    Map<String, dynamic> data = {

      'user': USER,
      'password': PASSWORD

    };
        await _codeProvider.update(data);
        _progressDialog.hide();

        signOut();
  }
  void signOut() async {
    Navigator.pushNamedAndRemoveUntil(context, 'Menu', (route) => false);
  }

}
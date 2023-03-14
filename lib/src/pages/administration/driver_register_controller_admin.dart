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
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;

class DriverRegisterControllerAdmin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController= new TextEditingController();



  TextEditingController confirmpasswordController= new TextEditingController();
  AuthProvider _authProvider;
  AdminProvider _adminProvider;
  BuildContext context;
  ProgressDialog _progressDialog;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Future init(BuildContext context){
    this.context = context;
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento...");
    _authProvider = new AuthProvider();
    _adminProvider = new AdminProvider();
  }


  void register()async{
    String email = emailController.text.trim();
    String username = usernameController.text;
    String confirmpassword = confirmpasswordController.text.trim();
    String password = passwordController.text.trim();
    print("Email: $email");
    print("Password: $password");

    if(username.isEmpty && email.isEmpty && password.isEmpty && confirmpassword.isEmpty )
    {
      print("debes ingresar todos los datos");
      utils.Snackbar.showSnacbar(context, key, "debes ingresar todos los datos");
      return;
    }
    if(confirmpassword != password){
      print("Las contraseñas no coinciden");
      utils.Snackbar.showSnacbar(context, key, "Las contraseñas no coinciden");
      return;
    }

    if(password.length < 6 ){
      print("El password debe tener al menos 6 caracteres");
      utils.Snackbar.showSnacbar(context, key, "El password debe tener al menos 6 caracteres");
      return;
    }
    _progressDialog.show();
    try{
      bool isRegister = await _authProvider.register(email, password);
      if(isRegister){
        Admin admin = new Admin(
          id:_authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
          password: password,
        );
        await _adminProvider.create(admin);
        _progressDialog.hide();
        signOut();
        print('El usuario se registro correctamente ');
        utils.Snackbar.showSnacbar(context, key, "Registrado Correctamente");
      }
      else{
        print('El usuario no se pudo registrar');
        utils.Snackbar.showSnacbar(context, key, "Error no se puede registrar");
      }
    }
catch(error){
      _progressDialog.hide();
      print(error);
}
  }
  void signOut() async {
    _auth.signOut().then((value) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MenuAdmin())));
  }

}
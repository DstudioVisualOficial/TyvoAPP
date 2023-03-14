import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/pages/administration/edit/driver_edit_page.dart';
import 'package:uber/src/pages/driver/edit/driver_edit_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/providers/storage_provider.dart';
import 'dart:io';
class DriverRegisterController {

  TextEditingController usernameController = new TextEditingController();
  TextEditingController Colorymodelo = new TextEditingController();
  TextEditingController Cellnumber = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController= new TextEditingController();
  TextEditingController confirmpasswordController= new TextEditingController();
  TextEditingController pin1Controller= new TextEditingController();
  TextEditingController pin2Controller= new TextEditingController();
  TextEditingController pin3Controller= new TextEditingController();
  TextEditingController pin4Controller= new TextEditingController();
  TextEditingController pin5Controller= new TextEditingController();
  TextEditingController pin6Controller= new TextEditingController();
  TextEditingController pin7Controller= new TextEditingController();
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  BuildContext context;
  StorageProvider _storageProvider;
  PickedFile pickedFile;
  File imageFile;
  Driver driver;
  Function refresh;

  ProgressDialog _progressDialog;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Future init(BuildContext context, Function refresh){
    this.context = context;
    this.refresh = refresh;
    _driverProvider = new DriverProvider();
    _storageProvider = new StorageProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento...");
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
  }

  void register()async{
    String email = emailController.text.trim();
    String username = usernameController.text;
    String cellnumber = Cellnumber.text.trim();
    String colorymodelo = Colorymodelo.text;
    String confirmpassword = confirmpasswordController.text.trim();
    String password = passwordController.text.trim();
    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();
    String pin7 = pin7Controller.text.trim();
    String plate = '$pin1$pin2$pin3$pin4$pin5$pin6$pin7';
    print("Email: $email");
    print("Password: $password");

    if(username.isEmpty && email.isEmpty && password.isEmpty && confirmpassword.isEmpty && cellnumber.isEmpty && colorymodelo.isEmpty && pickedFile == null)
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
        Driver driver = new Driver(
          id:_authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
          cellnumber: cellnumber,
          modeloycolor: colorymodelo,
          password: password,
          plate: plate
        );
        await _driverProvider.create(driver);
        _progressDialog.hide();
       // Navigator.pushNamed(context, "SplashAdmin");
        print('El usuario se registro correctamente ');
        utils.Snackbar.showSnacbar(context, key, "Registrado Correctamente");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DriverEditAdminPage(),
          ),
              (route) => false,
        );
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

}
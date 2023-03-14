import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/pages/administration/pagesAdmin/splash_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/storage_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:firebase_storage/firebase_storage.dart';


class DriverEditAdminController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController usernameController = new TextEditingController();

  TextEditingController plateController = new TextEditingController();

  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  StorageProvider _storageProvider;
  ProgressDialog _progressDialog;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PickedFile pickedFile;
  File imageFile;

  Driver driver;

  Function refresh;

  Future init (BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _storageProvider = new StorageProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    getUserInfo();
  }

  void getUserInfo() async {
    driver = await _driverProvider.getById(_authProvider.getUser().uid);
    usernameController.text = driver.username;
    plateController.text = driver.plate;
    refresh();
  }

  void showAlertDialog() {

    Widget galleryButton = FlatButton(
        onPressed: () {
          getImageFromGallery(ImageSource.gallery);
        },
        child: Text('GALERIA')
    );

    Widget cameraButton = FlatButton(
        onPressed: () {
          getImageFromGallery(ImageSource.camera);
        },
        child: Text('CAMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );

  }

  Future getImageFromGallery(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    else {
      print('No selecciono ninguna imagen');
    }
    Navigator.pop(context);
    refresh();
  }

  void update() async {
    String username = usernameController.text;

    String platedato= plateController.text.trim();
    String plate = '$platedato';


    if (username.isEmpty) {
      print('debes ingresar todos los campos');
      utils.Snackbar.showSnacbar(context, key, 'Debes ingresar todos los campos');
      return;
    }
    _progressDialog.show();

    if (pickedFile == null) {
      Map<String, dynamic> data = {
        'image': driver?.image ?? null,
        'username': username,
        'plate': plate,
      };

      await _driverProvider.update(data, _authProvider.getUser().uid);
      _progressDialog.hide();
    }
    else {
      TaskSnapshot snapshot = await _storageProvider.uploadFile(pickedFile);
      String imageUrl = await snapshot.ref.getDownloadURL();

      Map<String, dynamic> data = {
        'image': imageUrl,
        'username': username,
        'plate': plate,
      };

      await _driverProvider.update(data, _authProvider.getUser().uid);
    }

    _progressDialog.hide();
    signOut();
    utils.Snackbar.showSnacbar(context, key, 'Los datos se actualizaron');

  }
  void signOut() async {
    _auth.signOut().then((value) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => SplashPageAdmin())));
  }

}
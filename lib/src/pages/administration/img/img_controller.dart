import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/code.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/pages/administration/pagesAdmin/splash_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/code_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/storage_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;

class ImgController {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController usernameController = new TextEditingController();

  TextEditingController plateController = new TextEditingController();

  AuthProvider _authProvider;
  CodeProvider _codeProvider;
  StorageProvider _storageProvider;
  ProgressDialog _progressDialog;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PickedFile pickedFile;
  File imageFile;

  Code code;

  Function refresh;

  Future init (BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    _authProvider = new AuthProvider();
    _codeProvider = new CodeProvider();
    _storageProvider = new StorageProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    getCodeInfo();
  }

  void getCodeInfo() async {
    code = await _codeProvider.getAll();
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

    _progressDialog.show();

    if (pickedFile == null) {
      Map<String, dynamic> data = {
        'image': code?.image ?? null,
      };

      await _codeProvider.update(data);
      _progressDialog.hide();
    }
    else {
      TaskSnapshot snapshot = await _storageProvider.uploadFile(pickedFile);
      String imageUrl = await snapshot.ref.getDownloadURL();

      Map<String, dynamic> data = {
        'image': imageUrl,
      };

      await _codeProvider.update(data);
    }

    _progressDialog.hide();


  }


}


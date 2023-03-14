import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/prices.dart';
import 'package:uber/src/pages/administration/menu/menu_admin.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/prices_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;

class TarifaAdminController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PricesProvider pricesProvider;
  Function refresh;
  TextEditingController BaseController = new TextEditingController();
  TextEditingController KMController = new TextEditingController();
  TextEditingController MINController= new TextEditingController();
  AuthProvider _authProvider;
  PricesProvider _TarifaProvider;
  BuildContext context;
  ProgressDialog _progressDialog;
  String BASEG = '';
  String KMG = '';
  String MING = '';
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Future init(BuildContext context, Function refresh){
    pricesProvider = new PricesProvider();
    this.refresh = refresh;
    this.context = context;
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento...");
    _authProvider = new AuthProvider();
    _TarifaProvider= new PricesProvider();
    Obtenerdatos();
  }


  void Obtenerdatos()async{
    Prices prices = await pricesProvider.getAll();
    BASEG = prices.base.toString();
    KMG = prices.km.toString();
    MING = prices.min.toString();
    refresh();
  }
  void register()async{
    String KM = KMController.text.trim();
    String BASE = BaseController.text;
    String MIN = MINController.text.trim();

    if(KM.isEmpty && BASE.isEmpty && MIN.isEmpty)
    {
      print("debes ingresar al menos un dato");
      utils.Snackbar.showSnacbar(context, key, "Debes ingresar al menos un dato para actualizar");
      return;
    }

    if(KM.isEmpty && MIN.isEmpty)
    {
      _progressDialog.show();
      Map<String, dynamic> data = {
        'base': double.parse(BASE),
      };
      await _TarifaProvider.update(data);
      _progressDialog.hide();
      signOut();
    }
    if(BASE.isEmpty && MIN.isEmpty)
    {
      _progressDialog.show();
      Map<String, dynamic> data = {
        'km': double.parse(KM),
      };
      await _TarifaProvider.update(data);
      _progressDialog.hide();
      signOut();
    }
    if(BASE.isEmpty && KM.isEmpty)
    {
      _progressDialog.show();
      Map<String, dynamic> data = {
        'min': double.parse(MIN),
      };
      await _TarifaProvider.update(data);
      _progressDialog.hide();
      signOut();
    }
    if(KM.isEmpty)
    {
      _progressDialog.show();
      Map<String, dynamic> data = {
        'base': double.parse(BASE),
        'min': double.parse(MIN)
      };
      await _TarifaProvider.update(data);
      _progressDialog.hide();
      signOut();
    }
    if(MIN.isEmpty)
    {
      _progressDialog.show();
      Map<String, dynamic> data = {
        'base': double.parse(BASE),
        'km': double.parse(KM)
      };
      await _TarifaProvider.update(data);
      _progressDialog.hide();
      signOut();
    }
    if(BASE.isEmpty)
    {
      _progressDialog.show();
      Map<String, dynamic> data = {
        'km': double.parse(KM),
        'min': double.parse(MIN)
      };
      await _TarifaProvider.update(data);
      _progressDialog.hide();
      signOut();
    }
    _progressDialog.show();
    Map<String, dynamic> data = {

      'km': double.parse(KM),
      'base': double.parse(BASE),
      'min': double.parse(MIN)

    };
        await _TarifaProvider.update(data);
        _progressDialog.hide();

        signOut();
  }
  void signOut() async {
    _auth.signOut().then((value) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MenuAdmin())));
  }

}
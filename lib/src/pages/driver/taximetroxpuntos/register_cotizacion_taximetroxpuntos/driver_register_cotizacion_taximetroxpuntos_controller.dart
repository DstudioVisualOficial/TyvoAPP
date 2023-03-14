import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/TravelHistoryAgenda.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/models/history.dart';
import 'package:uber/src/models/taximetro.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/history_agenda_provider.dart';
import 'package:uber/src/providers/history_agenda_taximetro_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uuid/uuid.dart';


class DriverRegisterCotizacionTaximetroXPuntosController {


  var nowTime = DateTime.now (); // Obtiene la hora actual
  TextEditingController usernameController = new TextEditingController();
  TextEditingController clienteController = new TextEditingController();
  TextEditingController CellController = new TextEditingController();
  TextEditingController inicioController= new TextEditingController();
  TextEditingController precioController= new TextEditingController();
  TextEditingController txtcomentariocontroller= new TextEditingController();

  HistoryAgendaTaximetroProvider _authProvider;
  DriverProvider _clientProvider;
  AuthProvider _provider;
  BuildContext context;
  ProgressDialog _progressDialog;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  var uuid = Uuid();
  double price;
  String km;
  String min;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter =DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  var hoy = DateTime.now();
  String username;
  String pricedecimal;
  double priceDecimal;
  Driver driver;
  Future init(BuildContext context){
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    this.context = context;
    price = arguments['price'];
    km = arguments['km'];
    min = arguments['min'];
    //to = arguments['to'];
    //from = arguments['from'];
    pricedecimal = price.toStringAsFixed(2);
    priceDecimal = double.parse(pricedecimal);
    username = arguments['username'];
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento...");
    _authProvider = new HistoryAgendaTaximetroProvider();
    _clientProvider = new DriverProvider();
    _provider =  new  AuthProvider();
    driver = new Driver();

  }



  void register()async{
   String NombreCliente= clienteController.text;
   print(username);

    try{
        TravelHistoryAgenda client = new TravelHistoryAgenda(
          fecha: hoy.toString(),
          status: 'Viaje Finalizado',
          min: '${min} Ultimo Trayecto',
          km: '${km} Ultimo Trayecto' ,
          id: uuid.v4(),
          iddriver:_provider.getUser().uid,
          from:"TaximetroXPuntos",
          to:"TaximetroXPuntos",
          timestamp: DateTime.now().millisecondsSinceEpoch,
          nameDriver: username,
          cellclient: CellController.text,
          nameClient: NombreCliente,
          price: priceDecimal,
          comentariodes: txtcomentariocontroller.text
        );
        await _authProvider.create(client);
        print('El usuario registro la cotizacion correctamente ');
        utils.Snackbar.showSnacbar(context, key, "Registrado Correctamente");
        Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);

    }
catch(error){
      print(error);
    print('El usuario no se pudo registrar');
    utils.Snackbar.showSnacbar(context, key, "Ha ocurrido un error: $error");
}
  }

}
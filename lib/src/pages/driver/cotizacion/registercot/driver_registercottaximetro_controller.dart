import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/main.dart';
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


class DriverRegisterCotTaximetroController {


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
  String from;
  String to;
  double price;

  String username;
  String pricedecimal;
  String km;
  String min;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter =DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(now);
  var hoy = DateTime.now();
  double priceDecimal;
  Driver driver;
  Future init(BuildContext context){
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    this.context = context;
    price = arguments['price'];
    to = arguments['to'];
    from = arguments['from'];
    km = arguments['km'].toString();
    min = arguments['min'].toString();
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
    print("Destino: $from");
    print("inicio: $to");
   print(username);
    try{
        TravelHistoryAgenda client = new TravelHistoryAgenda(
          status: 'Viaje Terminado',
          km: km,
          min: min,
          fecha: hoy.toString(),
          id: uuid.v4(),
          iddriver:_provider.getUser().uid,
          from: from?? "Error al capturar datos",
          to: to?? "Error al capturar datos",
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
        await Future.delayed(Duration(milliseconds: 3000),(){
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
        });
    }
catch(error){
      print(error);
      utils.Snackbar.showSnacbar(context, key, 'Ha ocurrido un error: $error');
}
  }

}
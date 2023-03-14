import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber/src/utils/relative_time_util.dart';

class HistorialAgendaDetailController{
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
String from;
String to;
String price;
String nameClient;
String nameDriver;
String timestamp;
String timestampt;
String comentario;
String status;
String km;
String min;
String fecha;
int timestamptt;
  Future init(BuildContext context, Function refresh )async {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    this.context = context;
    from = arguments['from'];
    to = arguments['to'];
    comentario = arguments['comentario'];
    price = arguments['price'];
    nameClient = arguments['nameClient'];
    nameDriver = arguments['nameDriver'];
    timestamp = arguments['timestamp'];
    status = arguments['status'];
    km = arguments['km'];
    min= arguments['min'];
    fecha = arguments['fecha'];
    timestampt = RelativeTimeUtil.getRelativeTime(timestamptt.hashCode??0);
    timestamptt = int.parse(timestamp);
    print(from);
    print(to);
    print(price);
    print(nameClient);
    print(nameDriver);
    print(timestamp);

  }
  }


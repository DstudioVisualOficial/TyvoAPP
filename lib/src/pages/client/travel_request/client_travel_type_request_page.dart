import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/client/travel_request/client_travel_type_request_controller.dart';

// ignore: must_be_immutable
class ClientTravelTypeRequestPage extends StatefulWidget {
  @override
  _ClientTravelTypeRequestPageState createState() => _ClientTravelTypeRequestPageState();
}

class _ClientTravelTypeRequestPageState extends State<ClientTravelTypeRequestPage> {


  ClientTravelTypeRequestController _con = ClientTravelTypeRequestController();

  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Image.asset(
              'assets/img/logo.png',
              height: 100.0,
              width: 100.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              'Selecciona el tipo de viaje',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonWidget(
                    onClick: () {
                      _con.Pasajero = true;
                      refresh();
                      _con.goToRequest();

                    },
                    btnText:'Viaje pasajero',
                  ),
                  ButtonWidget(
                    onClick: () {
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {

                  return  AlertDialog(
                        title: Text('Informacion Adicional'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('¿Cómo se llama la mascota?*'),
                            TextField(
                              controller: _con.nameController,
                              decoration: InputDecoration(
                                hintText: 'Nombre de la mascota',
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[

                          ElevatedButton(
                            onPressed: () {
                              // Aquí puedes hacer lo que necesites con el valor ingresado en el campo de texto.
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Aquí puedes hacer lo que necesites con el valor ingresado en el campo de texto.
                              Navigator.of(context).pop(_con.nameController.text);
                              _con.Mascota = true;
                              refresh();
                              _con.goToRequest();
                            },
                            child: Text('Solicitar'),
                          ),
                        ],
                      );});
                    },
                      btnText:'Transporte para mascotas',
                  ),
                  ButtonWidget(
                    onClick: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {

                            return  AlertDialog(
                              title: Text('Reglamentaria Paqueteria'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('¿Cómo se llama la mascota?*'),
                                  TextField(
                                    controller: _con.nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Nombre de la mascota',
                                    ),
                                  ),
                                ],
                              ),
                              actions: <Widget>[

                                ElevatedButton(
                                  onPressed: () {
                                    // Aquí puedes hacer lo que necesites con el valor ingresado en el campo de texto.
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Aquí puedes hacer lo que necesites con el valor ingresado en el campo de texto.
                                    _con.Paqueteria = true;
                                    refresh();
                                    _con.goToRequest();
                                  },
                                  child: Text('Solicitar'),
                                ),
                              ],
                            );});

                    },
                    btnText:'Paquetería',
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _con.cancel();
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void refresh(){
    setState(() {
    });
  }
}

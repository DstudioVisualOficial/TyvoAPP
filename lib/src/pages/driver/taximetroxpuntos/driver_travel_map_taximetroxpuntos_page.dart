import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/driver/map/driver_map_page.dart';
import 'package:uber/src/pages/driver/travel_map/driver_travel_map_controller.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';

import 'driver_travel_map_taximetroxpuntos_controller.dart';


class DriverTravelMapTaximetroXPuntosPage extends StatefulWidget {
  @override
  _DriverTravelMapTaximetroXPuntosPageState createState() => _DriverTravelMapTaximetroXPuntosPageState();
}

class _DriverTravelMapTaximetroXPuntosPageState extends State<DriverTravelMapTaximetroXPuntosPage> {

  DriverTravelMapTaximetroXPuntosController _con = new DriverTravelMapTaximetroXPuntosController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: _onBackPressed,
        child:  Scaffold(
      key: _con.key,
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //_buttonUserInfo(),
                    _buttonCancel(),
                    Column(

                      children: [
                       // _cardKmInfo(_con.km?.toStringAsFixed(1)),
                        _cardMinInfo()
                      ],
                    ),

                    _buttonCenterPosition(),

                  ],
                ),
                Expanded(child: Container()),
                _buttonPunto(),
                _buttonStatus(),
              /*  Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.width * 0.11,
                  child: Column(
                    children: [
                      Text('ALERTA', style: TextStyle(color: Colors.white, backgroundColor: Colors.red, fontSize: 15),),
                      Text('Debera estar activo todo el viaje. Al contrario perdera el trayecto.',  style: TextStyle(color: Colors.white, backgroundColor: Colors.red, fontSize: 13),),
                    ],
                  ),
                ),*/
                const WarningWidgetChangeNotifier(),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Future<bool> _onBackPressed() async {
    // Your back press code here...
    displaySnackBar("Lo sentimos no puede salirse del viaje");
  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _con.key.currentState.showSnackBar(snackBar);
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: blackColors,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '${km ?? ''} km',
            style: TextStyle(color: Colors.white),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }
  Widget _buttonCancel() {
    return GestureDetector(
      onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Decea cancelar el viaje?'),
          content: const Text('Se perdera el progreso, no se guardaran los datos del viaje.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => {

                Navigator.pop(context, 'Cancel')

              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: ()  =>  {
                _con.returnprice(),
                _con.saveTravel('finished'),
              _con.dispose(),
      Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => DriverMapPage(),
      ),
          (route) => false,
    ),
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 1),
        child: Card(
          shape: CircleBorder(),
          color: blackColors,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.backspace_outlined,
              color: Colors.red,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardMinInfo() {
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '\$  ${_con.driver?.pricepoint?.toString() ?? '0'} km',
            maxLines: 1,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )
    );
  }

  Widget _buttonUserInfo() {
    return GestureDetector(
      onTap: _con.openBottomSheet,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.person,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: blackColors,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buttonPunto() {
    if (_con.bandera == false && _con.isStatus == true){
    return GestureDetector(
      onTap: _con.getGoogleMapsDirectionsPricesPoint,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: blackColors,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.send_and_archive,
              color: Colors.yellow,
              size: 20,
            ),
          ),
        ),
      ),
    );}
    else
      {
        return Container();
      }
  }
  Widget _buttonStatus() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonWidget(
        onClick: _con.updateStatus,
        btnText: _con.currentStatus,
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      trafficEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,

      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    setState(() {});
  }
}

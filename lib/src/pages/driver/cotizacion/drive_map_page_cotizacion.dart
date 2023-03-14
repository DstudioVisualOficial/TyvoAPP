import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/driver/map/driver_map_page.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';

import 'drive_map_controller_cotizacion.dart';

class DriveMapPageCotizacion extends StatefulWidget {
  @override
  _DriveMapPageCotizacionState createState() => _DriveMapPageCotizacionState();
}

class _DriveMapPageCotizacionState extends State<DriveMapPageCotizacion> {

  DriverMapControllerCotizacion _con = new  DriverMapControllerCotizacion();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('SE EJECUTO EL DISPOSE');
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return    WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
      key: _con.key,
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                _cardGooglePlaces(),
               _buttonChangeTo(),
                _buttonCenterPosition(),

                Expanded(child: Container()),
                _buttonRequest(),
                const WarningWidgetChangeNotifier(),

              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          )
        ],
      ),
    ));
  }
  Future<bool> _onBackPressed() async {

    await  utils.Snackbar.showSnacbar(context, _con.key, "Saliendo...");
    await Future.delayed(Duration(milliseconds: 2000),(){
      _con.dispose();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => DriverMapPage()));
    });

    // Your back press code here...
    // displaySnackBar("--");
  }
  Widget  _iconMyLocation() {
    if(_con.isFromSelected == true ){
      return Image.asset('assets/img/my_location.png',
        width: 65,
        height: 65,
      );
    }
    else
    {
      return Image.asset('assets/img/my_destino.png',
        width: 65,
        height: 65,
      );
    }
  }

  
  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 18),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonChangeTo() {
    return GestureDetector(
      onTap: _con.changeFromTO,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 18),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.refresh,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonDrawer() {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _con.openDrawer,
        icon: Icon(Icons.menu, color: Colors.white,),
      ),
    );
  }

  Widget _buttonRequest() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonWidget(
        onClick: _con.requestDriver,
        btnText: 'SOLICITAR',
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: true,
      trafficEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      onCameraMove: (position)  {
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  Widget _cardGooglePlaces() {
    return Container(

      width: MediaQuery.of(context).size.width * 0.9,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoCardLocation(
                  'Desde',
                  _con.from ?? 'Lugar de recogida',
                      () async {
                    await _con.showGoogleAutoComplete(true);
                  },
              ),
             SizedBox(height: 10),
             Container(
                // width: double.infinity,
                  child: Divider(color: Colors.grey, height: 10)
              ),
              SizedBox(height: 10),
              _infoCardLocation(
                  'Hasta',
                  _con.to ?? 'Lugar de destino',
                      () async {
                    await _con.showGoogleAutoComplete(false);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCardLocation(String title, String value, Function function) {
    return GestureDetector(
      onTap: function,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 10
            ),
            textAlign: TextAlign.start,
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

}


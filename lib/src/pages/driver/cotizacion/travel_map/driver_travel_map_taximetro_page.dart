import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/driver/travel_map/driver_travel_map_controller.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';

import 'driver_travel_map_taximetro_controller.dart';


class DriverTravelMapTaximetroPage extends StatefulWidget {
  @override
  _DriverTravelMapTaximetroPageState createState() => _DriverTravelMapTaximetroPageState();
}

class _DriverTravelMapTaximetroPageState extends State<DriverTravelMapTaximetroPage> {

  DriverTravelMapTaximetroController _con = new DriverTravelMapTaximetroController();

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
                    _buttonGoogleMaps(),
                    Column(
                      children: [

                      ],
                    ),

                    _buttonCenterPosition(),

                  ],
                ),
                Expanded(child: Container()),
                _buttonStatus(),
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


  Widget _cardMinInfo(String min) {
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '${min ?? ''} seg',
            style: TextStyle(color: Colors.white),

            maxLines: 1,
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
  Widget _buttonGoogleMaps() {
    return GestureDetector(
      onTap: _con.openMap,
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
              Icons.gps_fixed,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
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
      myLocationEnabled: false,
      trafficEnabled: true,
      zoomControlsEnabled: true,
      mapToolbarEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    setState(() {});
  }
}

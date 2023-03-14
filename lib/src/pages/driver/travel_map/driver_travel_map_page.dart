import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/pages/driver/travel_map/driver_travel_map_controller.dart';
import 'package:flutter/scheduler.dart';
import 'package:uber/src/widgets/button_app.dart';


class DriverTravelMapPage extends StatefulWidget {
  @override
  _DriverTravelMapPageState createState() => _DriverTravelMapPageState();
}

class _DriverTravelMapPageState extends State<DriverTravelMapPage> {

  DriverTravelMapController _con = new DriverTravelMapController();

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

    return Scaffold(
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


                    _buttonEmergency(),
                    _buttoncancel(),
                    _buttonUserInfo(),
                    _buttonCenterPosition(),
                    _buttonCall()
                  ],
                ),
                Expanded(child: Container()),
                _buttonStatus()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardKmInfo() {
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: blackColors,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '${_con.travelInfo?.hora?? '0'} hr', style: TextStyle(color: Colors.white),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }


  Widget _cardMinInfo() {
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '${_con.travelInfo?.min ?? '0'} min',
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
        margin: EdgeInsets.symmetric(horizontal: 1),
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
  Widget _buttonEmergency() {
    return GestureDetector(
      onDoubleTap: _con.ButtonEmergency,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 1),
        child: Card(
          shape: CircleBorder(),
          color: Colors.red,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.wifi_tethering_sharp,
              color: Colors.white,
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
        margin: EdgeInsets.symmetric(horizontal: 1),
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

  Widget _buttonCall() {
    return GestureDetector(
      onTap: _con.ButtonCallPhone,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 1),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.phone,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
  Widget _buttoncancel() {
    return GestureDetector(
      onTap: _con.ButtonCancel,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 1),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.cancel,
              color: Colors.red,
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
      child: ButtonApp(
        onPressed: _con.updateStatus,
        texto: _con.currentStatus,
        color: _con.colorStatus,
        textColor: Colors.white,
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
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

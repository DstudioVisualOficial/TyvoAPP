import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/client/travel_info/client_travel_info_controller.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';

import 'driver_travel_info_controller.dart';
class DriverTravelInfoPage extends StatefulWidget {
  @override
  _DriverTravelInfoPageState createState() => _DriverTravelInfoPageState();
}


class _DriverTravelInfoPageState extends State<DriverTravelInfoPage> {


  DriverTravelInfoController _con = new DriverTravelInfoController();
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
          Align(
            child: _googleMapsWidget(),
            alignment: Alignment.topCenter,
          ),
          Align(
            child: _cardTravelInfo(),
            alignment: Alignment.center,

          ),
          Align(
            child:      Container(
              child:           const WarningWidgetChangeNotifier(),
              decoration: BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50), bottomRight: Radius.circular(50), bottomLeft: Radius.circular(50)),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
          Align(
            child: _buttonBack(),
            alignment: Alignment.topLeft,
          ),

          Align(
            child: _cardKmInfo(_con.km),
            alignment: Alignment.topRight,
          ),
          Align(
            child: _cardMinInfo(_con.min),
            alignment: Alignment.topRight,
          ),
        ],
      ),

    );
  }

  Widget _cardTravelInfo(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      margin: EdgeInsets.only(top: 400),
      decoration: BoxDecoration(
        color: blackColors,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50), bottomRight: Radius.circular(50), bottomLeft: Radius.circular(50)
        ),
      ),
      child: Column(

        children: [
          SizedBox(height: 5,),

          ListTile(


            title: Text(
              'Desde',
              style: TextStyle(
                  fontSize: 15
                      ,color:Colors.white
              ),
            ),
            subtitle: Text(

              _con.from ?? '',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 13
                  ,color:Colors.white
              ),
            ),
            leading: Icon(Icons.my_location, color: Colors.white,),
          ),
          ListTile(
            title: Text(
              'Hasta',
              style: TextStyle(
                  fontSize: 15
                  ,color:Colors.white

              ),
            ),
            subtitle: Text(

              _con.to ??'',
              maxLines: 1,
              style: TextStyle(

                  fontSize: 13
                  ,color:Colors.white
              ),
            ),
            leading: Icon(Icons.location_on, color: Colors.white,),
          ),
          ListTile(
            title: Text(
              'Precio',
              style: TextStyle(
                  fontSize: 15
                  ,color:Colors.white

              ),
            ),
            subtitle: Text(
              ' \$ ${_con.medTotal?.toStringAsFixed(2) ?? '  0.0'}  ',
              style: TextStyle(
                  fontSize: 13
                  ,color:Colors.white
              ),
              maxLines: 1,
            ),
            leading: Icon(Icons.attach_money,color: Colors.white),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: ButtonWidget(
              onClick: _con.goToRequest,
               btnText: 'Confirmar Cotizacion',
            ),
          ),

        ],
      ),
    );
  }

  Widget _cardKmInfo(String km){
    return SafeArea(
      child: Container(
        width: 130,
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.only(right: 10, top: 10),
        decoration: BoxDecoration(
            color: blackColors,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Text(km ?? '0 Km', maxLines: 2, style : TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _cardMinInfo(String min){
    return SafeArea(
      child: Container(
        width: 130,
        padding: EdgeInsets.symmetric(horizontal: 30),
        margin: EdgeInsets.only(right: 10, top: 40),
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Text(min?? '0 min' ,maxLines: 2,style : TextStyle(color: Colors.white)),
      ),
    );
  }
  Widget _buttonBack(){
    return GestureDetector(
      onTap: _con.backLayout,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 10),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back_ios, color: Colors.black,),
          ),
        ),
      ),
    );
  }


  Widget _googleMapsWidget() {
    return GoogleMap(

      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }


  void refresh() {
    setState(() {

    });
  }
}

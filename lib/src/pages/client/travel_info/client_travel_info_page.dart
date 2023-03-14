import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/client/travel_info/client_travel_info_controller.dart';
import 'package:uber/src/widgets/button_app.dart';
class ClientTravelInfoPage extends StatefulWidget {
  @override
  _ClientTravelInfoPageState createState() => _ClientTravelInfoPageState();
}


class _ClientTravelInfoPageState extends State<ClientTravelInfoPage> {


ClientTravelInfoController _con = new ClientTravelInfoController();
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
            alignment: Alignment.topCenter,
          ),
          Align(
            child: _buttonBack(),
            alignment: Alignment.centerLeft,
          ),

          Align(
            child: _cardKmInfo(_con.km),
            alignment: Alignment.centerRight,

          ),
          Align(
            child: _cardMinInfo(_con.min),
            alignment: Alignment.centerRight,
          ),
          Align(
            child: _ButtonConfirmar(),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),

    );
  }
  
  Widget _cardTravelInfo(){
  return Container(
    height: MediaQuery.of(context).size.height * 0.33,
    decoration: BoxDecoration(
      color: whiteColors,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)
      ),
    ),
    child: Column(

      children: [
        ListTile(

          title: Text(
            'Desde',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15
            ),
          ),
          subtitle: Text(
            _con.from ?? '',
            maxLines: 2,
            style: TextStyle(
                color: Colors.white,
              fontSize: 13
            ),
          ),
          leading: Icon(Icons.my_location, color: Colors.white,),
        ),
        ListTile(
          title: Text(
            'Hasta',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15
            ),
          ),
          subtitle: Text(
            _con.to ??'',
            maxLines: 2,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13
            ),
          ),
          leading: Icon(Icons.location_on, color: Colors.white,),
        ),
        ListTile(
          title: Text(
            'Precio',
            style: TextStyle(
                color: Colors.white,
                fontSize: 15

            ),
          ),
          subtitle: Text(
            ' \$ ${_con.totalprice?.toStringAsFixed(2) ?? '  0.0'} - \$ ${_con.maxTotal?? ' 0.0'}',
            style: TextStyle(
                color: Colors.white,
                fontSize: 13
            ),
            maxLines: 1,
          ),
          leading: Icon(Icons.attach_money, color: Colors.white,),
        ),
      ],
    ),
  );
  }
Widget _ButtonConfirmar(){

  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: ButtonWidget(
        btnText: "Confirmar",
        onClick: (){
          _con.goToRequest();
        },
      ),
  );
}
  Widget _cardKmInfo(String km){
  return SafeArea(

    child: Container(
      width: 110,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 10, bottom: 100),
      decoration: BoxDecoration(
        color: blackColors,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Text(km ?? '0 Km', maxLines: 1,style: TextStyle(color: Colors.white),),
    ),
  );
  }

Widget _cardMinInfo(String min){
  return SafeArea(
    child: Container(
      width: 110,
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(right: 10, top: 50, bottom: 100),
      decoration: BoxDecoration(
          color: blackColors,
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: Text(min?? '0 min', maxLines: 1,style: TextStyle(color: Colors.white),),
    ),
  );
}
  Widget _buttonBack(){
  return GestureDetector(
    onTap: _con.backLayout,
    child: SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10, bottom: 100),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black,
          child: Icon(Icons.arrow_back_ios, color: Colors.white,),
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

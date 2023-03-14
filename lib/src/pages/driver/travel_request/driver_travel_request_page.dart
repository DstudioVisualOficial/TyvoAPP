import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/pages/driver/travel_request/driver_travel_request_controller.dart';
import 'package:uber/src/utils/colors.dart' as utils;
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/widgets/button_app.dart';

import 'driver_travel_request_controller.dart';

class DriverTravelRequestPage extends StatefulWidget {
  @override
  _DriverTravelRequestPageState createState() => _DriverTravelRequestPageState();
}

class _DriverTravelRequestPageState extends State<DriverTravelRequestPage> {

  DriverTravelRequestController _con = new DriverTravelRequestController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _con.dispose();
  }

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
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _bannerClientInfo(),
          _textFromTo(_con.from ?? '', _con.to ?? ''),
          _textTimeLimit()
        ],
      ),
      bottomNavigationBar: _buttonsAction(),
    );
  }

  Widget _buttonsAction() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ButtonApp(
              onPressed: (){
                _con.cancelTravel();
              },
              texto: 'Cancelar',
              color: Colors.grey[400],
              textColor: Colors.red,
              icon: Icons.cancel_outlined,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ButtonApp(
              onPressed: (){
                _con.acceptTravel();
              },
              texto: 'Aceptar',
              color: Colors.grey[400],
              textColor: Colors.green,
              icon: Icons.check,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textTimeLimit() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Text(
        "Se cancela el viaje en : "+_con.seconds.toString(),
        style: TextStyle(
          color: Colors.white,
            fontSize: 20
        ),
      ),
    );
  }

  Widget _textFromTo(String from, String to) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Recoger en',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              from,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17
              ),
              maxLines: 2,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'LLevar a',
            style: TextStyle(
              color: Colors.white,
                fontSize: 20
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              to,
              style: TextStyle(
                  color: Colors.white, fontSize: 17
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerClientInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      color: blackColors,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:_con.client?.image != null
                ? NetworkImage(_con.client?.image)
                : AssetImage('assets/img/profile.png'),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              _con.client?.username?? 'Tu cliente',
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.white
              ),
            ),
          )
        ],
      ),

    );

  }

  void refresh() {
    setState(() {

    });
  }
}

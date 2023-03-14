import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/pages/client/history_detail/client_history_detail_controller.dart';
import 'package:uber/src/utils/colors.dart' as utils;

import 'driver_history_detail_controller.dart';

class DriverHistoryDetailPage extends StatefulWidget {
  @override
  _DriverHistoryDetailPageState createState() => _DriverHistoryDetailPageState();
}

class _DriverHistoryDetailPageState extends State<DriverHistoryDetailPage> {

  DriverHistoryDetailController _con = new DriverHistoryDetailController();

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
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('Detalle del historial'),backgroundColor: Colors.black,),
      body: SingleChildScrollView(
        child: Column(
         children: [
           _bannerInfoDriver(),
           _listTileInfo('Lugar de recogida', _con.travelHistory?.from, Icons.location_on),
           SizedBox(height: 10,),
           _listTileInfo('Destino', _con.travelHistory?.to, Icons.location_searching),
           SizedBox(height: 10,),
           _listTileInfo('Calificacion del cliente', _con.travelHistory?.calificationClient?.toString(), Icons.star_border),
           SizedBox(height: 10,),
           _listTileInfo('Mi Calificacion', _con.travelHistory?.calificationDriver?.toString(), Icons.star),
           SizedBox(height: 10,),
           _listTileInfo('Precio del viaje', '${_con.travelHistory?.price?.toString() ?? '0\$'} ', Icons.monetization_on_outlined),
         ],
        ),
      ),
    );
  }

  Widget _listTileInfo(String title, String value, IconData icon) {
    return ListTile(
      tileColor: blackColors,
      title: Text(
          title ?? '',
        style: TextStyle(color: Colors.white,),
      ),
      subtitle: Text(value ?? '',  style: TextStyle(color: Colors.white,),),
      leading: Icon(icon, color: Colors.white,),
    );
  }

  Widget _bannerInfoDriver() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.27,
        width: double.infinity,
        color: Colors.black,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            CircleAvatar(
              backgroundImage: _con.client?.image != null
                  ? NetworkImage(_con.client?.image)
                  : AssetImage('assets/img/profile.png'),
              radius: 50,
            ),
            SizedBox(height: 10),
            Text(
              _con.client?.username ?? '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17
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

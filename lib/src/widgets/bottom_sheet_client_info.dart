import 'package:flutter/material.dart';

class BottomSheetClientInfo extends StatefulWidget {

  String imageUrl;
  String username;
  String modeloycolor;
  String plate;

  BottomSheetClientInfo({
     @required this.imageUrl,
     @required this.username,
    @required this.modeloycolor,
     @required this.plate,
  });

  @override
  _BottomSheetClientInfoState createState() => _BottomSheetClientInfoState();
}

class _BottomSheetClientInfoState extends State<BottomSheetClientInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      margin: EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            'Tu Conductor',
            style: TextStyle(
              fontSize: 18
            ),
          ),
          SizedBox(height: 15),
          CircleAvatar(
            backgroundImage: widget.imageUrl != null
                ? NetworkImage(widget.imageUrl)
                : AssetImage('assets/img/profile.png'),
            radius: 50,
          ),
          ListTile(
            title: Text(
              'Nombre',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.username ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
              'Modelo y Color',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.modeloycolor ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.local_car_wash),
          ),
          ListTile(
            title: Text(
              'Placa del vehiculo',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.plate ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.directions_car_rounded),
          )
        ],
      ),
    );
  }
}

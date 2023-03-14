import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/pages/driver/map/driver_map_controller.dart';
import 'package:uber/src/widgets/button_app.dart';
import 'package:uber/src/widgets/warning_widget_change_notifier.dart';


class DriverMapPage extends StatefulWidget {
  @override
  _DriverMapPageState createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> with TickerProviderStateMixin {

  bool isChanged = false;
  AnimationController controller;
  DriverMapController _con = new DriverMapController();
  TickerProvider tickerProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
    );
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
  return Scaffold(
  key: _con.key,
  drawer: _drawer(),
  body: Stack(
  children: [
  _googleMapsWidget(),
  SafeArea(
  child: Column(
  children: [
    _status(),
    Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  _buttonDrawer(),
    _buttonCenterPosition(),
  ],
  ),
  Expanded(child: Container()),
  _buttonConnect(),
    const WarningWidgetChangeNotifier(),
  ],
  ),
  )
  ],
  ),
  );
  }
  Widget _status() {
    return SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.height*0.32,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10,left: 0),
          decoration: BoxDecoration(
              color: blackColors,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '${_con.status ?? 'Bienvienid@'} ',
            style: TextStyle(color: Colors.white),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }
  Widget _drawer() {
  return Drawer(
  child:    Container(
    color: blackColors,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              CircleAvatar(
                backgroundImage: _con.driver?.image != null
                    ? NetworkImage(_con.driver?.image)
                    : AssetImage('assets/img/profile.png'),
                radius: 40,
              ),
              Container(
                child: Text(
                  _con.driver?.username ?? 'Nombre de usuario',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                  maxLines: 1,
                ),
              ),
              Container(
                child: Text(
                  _con.driver?.email ?? 'Correo electronico' ,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                  maxLines: 1,
                ),
              ),

            ],
          ),
          decoration: BoxDecoration(
              color: Colors.black
          ),
        ),

        ListTile(
          title: Text('Cuenta',style: TextStyle(color: Colors.white,),),
          trailing: Icon(Icons.person, color: Colors.white,),
          // leading: Icon(Icons.cancel),
          onTap: _con.goToEditPage,
        ),
        ListTile(
        title: Text("Cotizacion", style: TextStyle(color: Colors.white,),),
        trailing: Icon(Icons.analytics_outlined, color: Colors.white,),
        // leading: Icon(Icons.cancel),
        onTap: _con.goToCotizacionPage,
        ),
       /*ListTile(
          title: Text("Taximetro X Puntos", style: TextStyle(color: Colors.white,),),
          trailing: Icon(Icons.watch_later_sharp, color: Colors.white,),
          // leading: Icon(Icons.cancel),
          onTap: _con.goToTaximetroPage,
        ),*/
        ListTile(
          title: Text('Historial', style: TextStyle(color: Colors.white,),),
          trailing: Icon(Icons.sticky_note_2, color: Colors.white,),
          // leading: Icon(Icons.cancel),
          onTap: _con.goToHistoryPage,
        ),
         ListTile(
       title: Text('Historial Cotizacion', style: TextStyle(color: Colors.white,),),
       trailing: Icon(Icons.waterfall_chart, color: Colors.white,),
       // leading: Icon(Icons.cancel),
       onTap: _con.goToHistoryTaximetroPage,
        ),
        ListTile(
          title: Text(''),
          //  trailing: Icon(Icons.account_tree_rounded),
          // leading: Icon(Icons.cancel),
          //onTap: _con.goToHistoryPage,
        ),
        ListTile(
          title: Text('Cerrar sesion', style: TextStyle(color: Colors.white,),),
          trailing: Icon(Icons.power_settings_new, color: Colors.white,),
          // leading: Icon(Icons.cancel),
          onTap: _con.signOut,
        ),
      ],
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

  Widget _buttonDrawer() {
  return Container(
  alignment: Alignment.centerLeft,
  child: IconButton(
  onPressed: trigger,
  icon: AnimatedIcon(
  icon: AnimatedIcons.menu_home,
  color: Colors.black,
  progress: controller,
  )
  ),
  );
  }

  Widget _buttonConnect() {
  return Container(
  height: 50,
  alignment: Alignment.bottomCenter,
  margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
  child: ButtonApp(
  onPressed: _con.connect,
  icon: _con.isConnect ? Icons.wifi_off_rounded : Icons.wifi_outlined,
  texto: _con.isConnect ? 'DESCONECTARSE' : 'CONECTARSE',
  color: _con.isConnect ? Colors.black : blackColors,
  textColor: _con.isConnect? Colors.red : Colors.white,
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
  );
  }
  void trigger(){
    _con.openDrawer();
    setState(() {
      isChanged = !isChanged;
      isChanged? controller.forward() : controller.reverse();
    });
  }
  void refresh() {
  setState(() {});
  }
  }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/homes/widgets/btn_widget.dart';
import 'package:uber/src/pages/client/map/client_map_controller.dart';
import 'package:uber/src/widgets/button_app.dart';


class ClientMapPage extends StatefulWidget {
  @override
  _ClientMapPageState createState() => _ClientMapPageState();
}

class _ClientMapPageState extends State<ClientMapPage> {

  ClientMapController _con = new ClientMapController();

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

    return Scaffold(
      key: _con.key,
      drawer: _drawer(),
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [

                _buttonDrawer(),

                _cardGooglePlaces(),
              //  _buttonChangeTo(),
                _buttonCenterPosition(),


                Expanded(child: Container()),
                _buttonRequest()
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          )
        ],
      ),
    );
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

  Widget _drawer() {
    return Drawer(
      child: Container(
        color: blackColors,
        child:  ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                CircleAvatar(
                  backgroundImage: _con.client?.image != null
                      ? NetworkImage(_con.client?.image)
                      : AssetImage('assets/img/profile.png'),
                  radius: 40,
                ),
                SizedBox(height: 10),
                Container(
                  child: Text(
                    _con.client?.username ?? 'Nombre de usuario',
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
                    _con.client?.email ?? 'Correo electronico' ,
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
            title: Text('Cuenta', style: TextStyle(color: Colors.white),),
            trailing: Icon(Icons.edit, color: Colors.white,),
            // leading: Icon(Icons.cancel),
            onTap: _con.goToEditPage,
          ),
          ListTile(
            title: Text('Historial de viajes', style: TextStyle(color: Colors.white),),
            trailing: Icon(Icons.timer, color: Colors.white,),
            // leading: Icon(Icons.cancel),
            onTap: _con.goToHistoryPage,
          ),
          ListTile(
            title: Text('Cupons', style: TextStyle(color: Colors.white),),
            trailing: Icon(Icons.qr_code, color: Colors.white,),
            // leading: Icon(Icons.cancel),
            onTap: _con.goToCupons,
          ),
          ListTile(
            title: Text('Cerrar sesion', style: TextStyle(color: Colors.white),),
            trailing: Icon(Icons.power_settings_new, color: Colors.white),
            // leading: Icon(Icons.cancel),
            onTap: _con.signOut,
          ),
        ],
      ),
    ));
  }

  Widget _buttonCenterPosition() {
    return  Container(
        height: MediaQuery.of(context).size.height * 0.1,
    width: double.infinity,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [ GestureDetector(

      onTap: _con.centerPosition,
      child: Container(
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
    ),

        GestureDetector(
          onTap: _con.changeFromTO,
          child: Container(
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsets.symmetric(horizontal: 18 ),
            child: Card(
              shape: CircleBorder(),
              color: Colors.white,
              elevation: 4.0,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.alt_route,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ),
            ),
          ),
        )
      ])]));
  }

  Widget _buttonChangeTo() {
    return GestureDetector(
      onTap: _con.changeFromTO,
      child: Container(
        alignment: AlignmentDirectional.topStart,
        margin: EdgeInsets.symmetric(horizontal: 18 ),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.alt_route,
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
        icon: Icon(Icons.menu, color: Colors.black,),
      ),
    );
  }

  Widget _buttonRequest(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 55, vertical: 35),
      child: Center(
        child: ButtonWidget(
          btnText: "Continuar",
          onClick: (){
            _con.requestDriver();
          },
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
      zoomControlsEnabled: false,
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
        color: direccionesColors,
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
                  }
              ),
              SizedBox(height: 5),
              Container(
                // width: double.infinity,
                  child: Divider(color: Colors.grey, height: 10)
              ),
              SizedBox(height: 5),
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
                color: blackColors,
                fontSize: 12
            ),
            textAlign: TextAlign.start,
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.white,
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


import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/api/environment.dart';
import 'package:uber/src/models/TravelHistory.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';
import 'package:uber/src/models/directions.dart';
import 'package:uber/src/models/travel_info.dart';
import 'package:uber/src/pages/driver/map/driver_map_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/geofire_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/google_provider.dart';
import 'package:uber/src/providers/push_notifications_provider.dart';
import 'package:uber/src/providers/travel_history_provider.dart';
import 'package:uber/src/providers/travel_info_provider.dart';
import 'package:uber/src/providers/prices_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/models/prices.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uber/src/widgets/bottom_sheet_driver_info.dart';
import 'package:uber/src/utils/shared_pref.dart';


class DriverTravelMapTaximetroXPuntosController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(28.190856, -105.4736305),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;
  PricesProvider _pricesProvider;
  ClientProvider _clientProvider;
  TravelHistoryProvider _travelHistoryProvider;
  double operacion;
  bool isConnect = false;
  ProgressDialog _progressDialog;
  bool isStatus = false;
  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSuscription;
  Direction _directions;
  GoogleProvider _googleProvider;
  bool bandera= false;
  Set<Polyline> polylines = {};
  List<LatLng> points = new List();

  Driver driver;
  ClientPhone _client;
  String _idTravel;
  TravelInfo travelInfo;


  SharedPref _sharedPref;
  String stylemapsave, status;

  String currentStatus = 'Iniciar Viaje';
  Color colorStatus = Colors.grey[600];
  String mins, kms;
  double _distanceBetween;
  Timer _timer;
  int seconds = 0;
  double mt = 0;
  double km = 0;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    Map<String, dynamic> arguments = ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;

    _idTravel = ModalRoute
        .of(context)
        .settings
        .arguments as String;
    _sharedPref = new SharedPref();
    stylemapsave = await _sharedPref.read('stylemap');
    status = await _sharedPref.read('status');
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _pricesProvider = new PricesProvider();
    _clientProvider = new ClientProvider();
    _travelHistoryProvider = new TravelHistoryProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    _googleProvider = new GoogleProvider();
    markerDriver = await createMarkerImageFromAsset('assets/img/taxi_icon.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');

    checkGPS();
    getDriverInfo();
    chekstatus();

  }

  void getClientInfo() async {
    _client = await _clientProvider.getById(_idTravel);
  }

  void getGoogleMapsDirections()async{
    _directions = await _googleProvider.getGoogleMapsDirections(
        driver.fromLatLnglatitude,
        driver.fromLatLnglongitude,
        _position.latitude,
        _position.longitude
    );
    mins = _directions.duration.text;
    kms = _directions.distance.text;

    calculatePrice();

    refresh();

  }
  Future<double> calculatehr() async
  {
    getDriverInfo();
    double hrdata = driver.hora.toDouble();
    print('=========================HORA SERVIDOR=================================');
    print(hrdata);
    double hractual = DateTime.now().hour.truncate().toDouble();
    print('=========================HORA ACTUAL=================================');
    print(hractual);
    double horasresta = hractual - hrdata;
    print('=========================HORA RESTA=================================');
    print(horasresta);

    if (horasresta < 0){
      print('=========================HORA < 0=================================');

      double horatt = horasresta + 24;
      double totalhrdata = horatt * 60;
      return totalhrdata;

    }
    else{
      print('=========================HORA NORMAL=================================');

      double totalhrdata = horasresta * 60;
      return totalhrdata;

    }

  }

  Future<double> calculatemin() async{
    getDriverInfo();
    double mindata = driver.min.toDouble();
    print('=========================MIN SERVIDOR=================================');
    print(mindata);
    double minactual = DateTime.now().minute.toDouble();
    print('=========================MIN ACTUAL=================================');
    print(minactual);
    double totalmindata = minactual - mindata;
    print('=========================MIN RESTA=================================');
    print(totalmindata);
    if (totalmindata < 0)
    {
      print('=========================MIN < 0 =================================');
      double mintt = totalmindata + 60;
      return mintt;
    }
    else {
      print('=========================MIN NORMAL =================================');
      return totalmindata;
    }
  }

  Future<double> calculatePrice() async {
    if (driver.pricepoint.toString() != null){
    try {
      getDriverInfo();
      Prices prices = await _pricesProvider.getAll();
      double  pricespoint = driver.pricepoint.toDouble();
      double base = prices.base;
      double kmValue = double.parse(kms.split(" ")[0]) * prices.km;
      double totalhr = await calculatehr();
      print('=========================HORA CAPTURADO=================================');
      print(totalhr);
      double totalmin= await calculatemin();
      print('=========================MIN CAPTURADO=================================');
      print(totalmin);
      double horas = (totalhr+ totalmin) * prices.min;
      double total = kmValue + pricespoint + base + horas;

      returnprice();
      saveTravel('finished');
      dispose();
      _timer?.cancel();
    Navigator.pushNamed(context, 'driver/register/cotizacion/taximetroxpuntos', arguments: {
      'username': driver.username,
      'price': total,
       'km': kms,
      'min': mins});
    print('=========== TOTAL ==============');
    print(total.toString());
    print(driver.username);

    return total;
    }
    catch (error) {
      utils.Snackbar.showSnacbar(context, key, 'TaximetroXPuntos: $error');
    }}
    else
      {
        try {
          getDriverInfo();
          Prices prices = await _pricesProvider.getAll();
          double  base = prices.base;
          double kmValue = double.parse(kms.split(" ")[0]) * prices.km;
          double totalhr = await calculatehr();
          print('=========================HORA CAPTURADO=================================');
          print(totalhr);
          double totalmin= await calculatemin();
          print('=========================MIN CAPTURADO=================================');
          print(totalmin);
          double horas = (totalhr + totalmin) * prices.min;
          double total = kmValue  + base + horas;

          returnprice();
          dispose();
          saveTravel('finished');
          dispose();
          _timer?.cancel();
          Navigator.pushNamed(context, 'driver/register/cotizacion/taximetroxpuntos', arguments: {
            'username': driver.username,
            'price': total.toInt(),
            'km': kms,
            'min': mins});
          print('=========== TOTAL ==============');
          print(total.toString());
          print(driver.username);

          return total;
        }
        catch (error) {
          utils.Snackbar.showSnacbar(context, key, 'TaximetroXPuntos: $error');
        }
      }
  }

  /*void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = timer.tick;
      refresh();
    });
  }
*/
  void isCloseToPickupPosition(LatLng from, LatLng to) {
    _distanceBetween = Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude
    );
    print('------ DISTANCE: $_distanceBetween--------');
  }

  void updateStatus() {
    if (isStatus == false) {
      currentStatus = 'Finalizar Viaje';
      startTravel();
      isStatus = true;
    }
    else {
      finishTravel();
    }
  }

  void startTravel() async {
    if (status == 'starteddirecto') {
      utils.Snackbar.showSnacbar(
          context, key, 'Calculando viaje, espere un momento.');
      finishTravel();
    }
    else {
      try {
        polylines = {};
        points = List();
        updatelocations();
        updatesaldo();
        //markers.remove(markers['from']);
        // markers.removeWhere((key, marker) => marker.markerId.value == 'from');
        /* addSimpleMarker(
          'to',
          driver.toLatLnglatitude,
          driver.toLatLnglongitude,
          'Destino',
          '',
          toMarker
      );
*/
        /*LatLng from = new LatLng(_position.latitude, _position.longitude);
        LatLng to = new LatLng(driver.toLatLnglatitude, driver.toLatLnglongitude);
*/
        //setPolylines(from, to);
        saveTravel('starteddirecto');
        //startTimer();
        currentStatus = 'Finalizar Viaje';
        refresh();
      }
      catch (error) {
        utils.Snackbar.showSnacbar(context, key, 'TaximetroXPuntos: $error');
      }
    }
  }

  void updatesaldo() async {
    String saldo;
    double saldoO;
    saldo = driver.saldo.toString();
    saldoO = double.parse(saldo);
    operacion = saldoO - 10;
    Map<String, dynamic> data = {

      'saldo': operacion.toString()
    };

    await _driverProvider.update(data, _authProvider
        .getUser()
        .uid);
    utils.Snackbar.showSnacbar(context, key, '-10');
  }

  Future<void> returnprice() async {
    Map<String, dynamic> data = {

      'pricepoint': 0.toInt()
    };

    await _driverProvider.update(data, _authProvider
        .getUser()
        .uid);
  }
  void updatelocations() async {

    Map<String, dynamic> datas = {
      'min': DateTime.now().minute.toInt(),
      'hora': DateTime.now().hour.truncate().toInt(),
      'fromLatLnglatitude': _position.latitude.toDouble(),
      'fromLatLnglongitude': _position.longitude.toDouble()
    };
    await _driverProvider.update(datas, _authProvider
        .getUser()
        .uid);

    print(
        '-----------------------------------------------/ SE ACTUALIZO LA UBICACION FROM /--------------------------------------------------------------- ');
  }





  void saveTravel(String status) async {
    _sharedPref.remove('status');
    _sharedPref.save("status", status);
  }

  void finishTravel() async {

      utils.Snackbar.showSnacbar(
          context, key, 'Calculando viaje, espere un momento.');

      getGoogleMapsDirections();
    // saveTravelHistory(total);

  }

  /* void saveTravelHistory(double price) async {
    TravelHistory travelHistory = new TravelHistory(
        from: travelInfo.from,
        to: travelInfo.to,
        idDriver: _authProvider.getUser().uid,
        idClient: _idTravel,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        price: price
    );

    String id = await _travelHistoryProvider.create(travelHistory);

    Map<String, dynamic> data = {
      'status': 'finished',
      'idTravelHistory': id,
      'price': price,
    };
    await _travelInfoProvider.update(data, _idTravel);
    travelInfo.status = 'finished';

    Navigator.pushNamedAndRemoveUntil(context, 'driver/travel/calification', (route) => false, arguments: id);
  }*/

  /*void _getTravelInfo() async {
    travelInfo = await _travelInfoProvider.getById(_idTravel);
    LatLng from = new LatLng(_position.latitude, _position.longitude);
    LatLng to = new LatLng(driver.fromLatLnglatitude, driver.fromLatLnglongitude);
    addSimpleMarker('from', driver.fromLatLnglatitude, driver.fromLatLnglongitude, 'Recoger aqui', '', fromMarker);
    setPolylines(from, to);
    getClientInfo();
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFromLatLng = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointToLatLng = PointLatLng(to.latitude, to.longitude);

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFromLatLng,
        pointToLatLng
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.amber,
        points: points,
        width: 6
    );

    polylines.add(polyline);

   //  addMarker('to', to.latitude, to.longitude, 'Destino', '', toMarker);

    refresh();
  }
*/
  void getDriverInfo() {
    Stream<DocumentSnapshot> driverStream = _driverProvider.getByIdStream(
        _authProvider
            .getUser()
            .uid);
    _driverInfoSuscription = driverStream.listen((DocumentSnapshot document) {
      driver = Driver.fromJson(document.data());
    });
  }

  void dispose() {
    _timer?.cancel();
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _driverInfoSuscription?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    if (stylemapsave == 'true') {
      controller.setMapStyle(
          '[{"elementType": "geometry","stylers": [{"color": "#242f3e"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#746855"}]},{"elementType": "labels.text.stroke","stylers": [{"color": "#242f3e"}]},{"featureType": "administrative.locality","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "poi.park","elementType": "geometry","stylers": [{"color": "#263c3f"}]},{"featureType": "poi.park","elementType": "labels.text.fill","stylers": [{"color": "#6b9a76"}]},{"featureType": "road","elementType": "geometry","stylers": [{"color": "#38414e"}]},{"featureType": "road","elementType": "geometry.stroke","stylers": [{"color": "#212a37"}]},{"featureType": "road","elementType": "labels.text.fill","stylers": [{"color": "#9ca5b3"}]},{"featureType": "road.highway","elementType": "geometry","stylers": [{"color": "#746855"}]},{"featureType": "road.highway","elementType": "geometry.stroke","stylers": [{"color": "#1f2835"}]},{"featureType": "road.highway","elementType": "labels.text.fill","stylers": [{"color": "#f3d19c"}]},{"featureType": "transit","elementType": "geometry","stylers": [{"color": "#2f3948"}]},{"featureType": "transit.station","elementType": "labels.text.fill","stylers": [{"color": "#d59563"}]},{"featureType": "water","elementType": "geometry","stylers": [{"color": "#17263c"}]},{"featureType": "water","elementType": "labels.text.fill","stylers": [{"color": "#515c6d"}]},{"featureType": "water","elementType": "labels.text.stroke","stylers": [{"color": "#17263c"}]}]');
      _mapController.complete(controller);
    }
    else {
      controller.setMapStyle('');
      _mapController.complete(controller);
    }
  }

  void saveLocation() async {
    await _geofireProvider.createWorking(
        _authProvider
            .getUser()
            .uid,
        _position.latitude,
        _position.longitude
    );
    _progressDialog.hide();
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      // _getTravelInfo();
      centerPosition();
      saveLocation();

      addMarker(
          'driver',
          _position.latitude,
          _position.longitude,
          'Tu posicion',
          '',
          markerDriver
      );
      refresh();

      _positionStream = Geolocator.getPositionStream(
          desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) {
        if (isStatus == true) {
          mt = mt + Geolocator.distanceBetween(
              _position.latitude,
              _position.longitude,
              position.latitude,
              position.longitude
          );
          km = mt / 1000;
        }

        _position = position;
        addMarker(
            'driver',
            _position.latitude,
            _position.longitude,
            'Tu posicion',
            '',
            markerDriver
        );
        animateCameraToPosition(_position.latitude, _position.longitude);

       /* if (travelInfo.fromLat != null && travelInfo.fromLng != null) {
          LatLng from = new LatLng(_position.latitude, _position.longitude);
          LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
          isCloseToPickupPosition(from, to);
        }
*/
        saveLocation();
        refresh();
      });
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void openBottomSheet() {
    if (_client == null) return;

    showMaterialModalBottomSheet(
        context: context,
        builder: (context) =>
            BottomSheetDriverInfo(
              imageUrl: _client?.image,
              username: _client?.username,
              email: _client?.email,
            )
    );
  }

  Future<void> calculatepoint() async {
    if (driver.pricepoint.toString() != null){
      try {

        double  pricespoint = driver.pricepoint.toDouble();
        Prices prices = await _pricesProvider.getAll();
        double kmValue = double.parse(kms.split(" ")[0]) * prices.km;
        double total = kmValue + pricespoint;
        Map<String, dynamic> data = {
          'fromLatLnglatitude': _position.latitude.toDouble(),
          'fromLatLnglongitude': _position.longitude.toDouble(),
          'pricepoint': total.toInt()
        };

        await _driverProvider.update(data, _authProvider
            .getUser()
            .uid);
        getDriverInfo();
      }
      catch (error) {
        utils.Snackbar.showSnacbar(context, key, 'TaximetroXPuntos: $error');
      }
    }
    else
    {
    try {
      Prices prices = await _pricesProvider.getAll();
      double kmValue = double.parse(kms.split(" ")[0]) * prices.km;
      double total = kmValue;
      Map<String, dynamic> data = {
        'fromLatLnglatitude': _position.latitude.toDouble(),
        'fromLatLnglongitude': _position.longitude.toDouble(),
        'pricepoint': total.toInt()
      };

      await _driverProvider.update(data, _authProvider
          .getUser()
          .uid);
      getDriverInfo();
    }
    catch (error) {
      utils.Snackbar.showSnacbar(context, key, 'TaximetroXPuntos: $error');
    }}


  }


  void getGoogleMapsDirectionsPricesPoint()async{
      bandera = true;
      utils.Snackbar.showSnacbar(context, key, 'Se ha guardado tu punto de partida!.');
      Future.delayed(Duration(milliseconds: 20000),(){
        bandera = false;
      });
      _directions = await _googleProvider.getGoogleMapsDirections(
          driver.fromLatLnglatitude,
          driver.fromLatLnglongitude,
          _position.latitude,
          _position.longitude
      );
      mins = _directions.duration.text;
      kms = _directions.distance.text;

      calculatepoint();

      refresh();
  }


  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    }
    else {
      utils.Snackbar.showSnacbar(context, key, 'Activa el GPS para obtener la posicion');
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS ACTIVADO');
      updateLocation();
    }
    else {
      print('GPS DESACTIVADO');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
        print('ACTIVO EL GPS');
      }
    }

  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 17
          )
      ));
    }
  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor =
    await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ) {

    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        rotation: _position.heading
    );

    markers[id] = marker;

  }

  void addSimpleMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ) {

    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(lat, lng),
      infoWindow: InfoWindow(title: title, snippet: content),
    );

    markers[id] = marker;
  }

  Future<void> chekstatus() async {
    if (status == 'starteddirecto'){
      isStatus = true;

     // startTimer();
      currentStatus = 'Finalizar Viaje';

    }

  }
}
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/api/environment.dart';
import 'package:uber/src/models/directions.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/models/TravelHistory.dart';
import 'package:uber/src/models/client.dart';
import 'package:uber/src/models/clientphone.dart';
import 'package:uber/src/models/travel_info.dart';
import 'package:uber/src/pages/driver/map/driver_map_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/client_phone_provider.dart';
import 'package:uber/src/providers/client_provider.dart';
import 'package:uber/src/providers/geofire_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/google_provider.dart';
import 'package:uber/src/providers/push_notifications_provider.dart';
import 'package:uber/src/providers/travel_history_provider.dart';
import 'package:uber/src/providers/travel_info_provider.dart';
import 'package:uber/src/providers/prices_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/models/prices.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uber/src/widgets/bottom_sheet_driver_info.dart';


class DriverTravelMapController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(1.2342774, -77.2645446),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Position _position;
  StreamSubscription<Position> _positionStream;

  BitmapDescriptor markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;
  Direction _directions;
  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;
  PricesProvider _pricesProvider;
  ClientPhoneProvider _clientProvider;
  TravelHistoryProvider _travelHistoryProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSuscription;

  Set<Polyline> polylines = {};
  List<LatLng> points = new List();
  double hrdata;
  double mindata;
  Driver driver;
  ClientPhone _client;

  String _idTravel;
  TravelInfo travelInfo;
  GoogleProvider _googleProvider;

  String currentStatus = 'INICIAR VIAJE';
  Color colorStatus = blackColors;
  bool bandera=false, swich = false, swichs= false;
  double _distanceBetween;
  String status;
  Timer _timer;
  int seconds = 0;
  double mt = 0;
  double km = 0;
  SharedPref _sharedPref;
  String mins, kms;


  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    _idTravel = ModalRoute.of(context).settings.arguments as String;
    _sharedPref = new SharedPref();
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _pricesProvider = new PricesProvider();
    _clientProvider = new ClientPhoneProvider();
    _travelHistoryProvider = new TravelHistoryProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    status = await _sharedPref.read('status');
    markerDriver = await createMarkerImageFromAsset('assets/img/uber_car.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');
    _googleProvider = new GoogleProvider();

    checkGPS();
    getDriverInfo();
  }

  void getClientInfo() async {
    _client = await _clientProvider.getById(_idTravel);
    checktravel();
  }
  Future<void> isDateInfo() async {
    _directions = await _googleProvider.getGoogleMapsDirections(
        travelInfo.fromLat,
        travelInfo.fromLng,
        _position.latitude,
        _position.longitude
    );
    mins = _directions.duration.text;
    kms = _directions.distance.text;
    print('------ DISTANCE: $_distanceBetween--------');
   // calculatePriceUpdate();
  }


  Future<double> calculatehr() async
  {
      _getTravelInfo();
    double hrdata = travelInfo.hora.toDouble();
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
    _getTravelInfo();
    double mindata = travelInfo.min.toDouble();
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
  Future<double> calculatePriceUpdate() async {
    Prices prices = await _pricesProvider.getAll();

    print('=========== MIN TOTALES ==============');

    print('=========== KM TOTALES ==============');

    double priceKm = double.parse(kms.split(" ")[0]) * prices.km;
    print('-------------------------KM TOTALES-----------------------');
    print(priceKm);
    double pricesBase = prices.base;
    double totalhr = await calculatehr();
    print('=========================HORA CAPTURADO=================================');
    print(totalhr);
    double totalmin= await calculatemin();
    print('=========================MIN CAPTURADO=================================');
    print(totalmin);
    double horas = (totalhr+ totalmin) * prices.min;
    double total = horas + priceKm + pricesBase;

    /*if (total < prices.minValue) {
      total = prices.minValue;
    }*/

    print('=========== TOTAL ==============');
    print(total.toString());

    if (total > travelInfo.price){
      return total;
    }
    else
      {
        return travelInfo.price;
      }
  }


  /*Future<double> calculatePrice() async {
    Prices prices = await _pricesProvider.getAll();

    if (seconds < 60) seconds = 60;
    if (km == 0) km = 0.1;

    int min = seconds ~/ 60;

    print('=========== MIN TOTALES ==============');
    print(min.toString());

    print('=========== KM TOTALES ==============');
    print(km.toString());

    double priceMin = min * prices.min;
    double priceKm = km * prices.km;
    double pricesBase = prices.base;
    double total = priceMin + priceKm + pricesBase;

    if (total < prices.minValue) {
      total = prices.minValue;
    }

    print('=========== TOTAL ==============');
    print(total.toString());

    return total;
  }*/

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = timer.tick;
      refresh();
    });
  }

  void isCloseToPickupPosition(LatLng from, LatLng to) {
    _distanceBetween = Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude
    );
    print('------ DISTANCE: $_distanceBetween--------');
  }

  void updateStatus () {
    if (travelInfo.status == 'accepted') {
      startTravel();
    }
    else if (travelInfo.status == 'started') {
      finishTravel();
    }
  }

  void startTravel() async {
    if (status == 'started'){
      finishTravel();

    }
    else
      {

    if (_distanceBetween <= 300) {
      Map<String, dynamic> data = {
        'status': 'started'
      };
      bandera = true;

      await _travelInfoProvider.update(data, _idTravel);
      travelInfo.status = 'started';
      currentStatus = 'FINALIZAR VIAJE';
      colorStatus = Colors.red;
      saveTravel('started');
      saveidClient(_client.id);
      saveHora();
      saveHoraInicio();
      polylines = {};
      points = List();
      // markers.remove(markers['from']);
      markers.removeWhere((key, marker) => marker.markerId.value == 'from');
      addSimpleMarker(
          'to',
          travelInfo.toLat,
          travelInfo.toLng,
          'Destino',
          '',
          toMarker
      );

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);
      startTimer();
      refresh();
    }
    else {
      utils.Snackbar.showSnacbar(context, key, 'Debes estar cerca a la posicion del cliente para iniciar el viaje');
    }

    refresh();

  }}

  void finishTravel() async {
    _timer?.cancel();
   await _getTravelInfo();
    print('----------------------------------TravelInfo.hora-------------------------');
    hrdata = travelInfo.hora;
    print(travelInfo?.hora);
    print('----------------------------------TravelInfo.min-------------------------');
    mindata =  travelInfo.min;
    print(travelInfo?.min);
    await saveHoraFinal();
    await isDateInfo();
    double total = await calculatePriceUpdate();
   saveTravel('finished');
    saveTravelHistory(total);

  }

  void saveTravelHistory(double total) async {
    TravelHistory travelHistory = new TravelHistory(
        from: travelInfo.from,
        to: travelInfo.to,
        idDriver: _authProvider.getUser().uid,
        idClient: _idTravel,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        price: total
    );

    String id = await _travelHistoryProvider.create(travelHistory);

    Map<String, dynamic> data = {
      'status': 'finished',
      'idTravelHistory': id,
      //'price': price,
    };
    await _travelInfoProvider.update(data, _idTravel);
    travelInfo.status = 'finished';

    Navigator.pushNamedAndRemoveUntil(context, 'driver/travel/calification', (route) => false, arguments: id);
  }

  void _getTravelInfo() async {
    if (status == 'started'){
      print('----------------------------------TravelInfo CON Started-------------------------');
      getClientInfo();
      travelInfo = await _travelInfoProvider.getById(_idTravel);


    }
    else {
      print('----------------------------------TravelInfo SIN Started-------------------------');
      getClientInfo();
      travelInfo = await _travelInfoProvider.getById(_idTravel);


      /* LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
      addSimpleMarker(
          'from', to.latitude, to.longitude, 'Recoger aqui', '', fromMarker);
      setPolylines(from, to);*/
    }
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
        color: blackColors,
        points: points,
        width: 6
    );

    polylines.add(polyline);

    // addMarker('to', toLatLng.latitude, toLatLng.longitude, 'Destino', '', toMarker);

    refresh();

  }

  void getDriverInfo() {
    Stream<DocumentSnapshot> driverStream = _driverProvider.getByIdStream(_authProvider.getUser().uid);
    _driverInfoSuscription = driverStream.listen((DocumentSnapshot document) {
      driver = Driver.fromJson(document.data());
      refresh();
    });
  }

  void dispose() {
    _timer?.cancel();
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _driverInfoSuscription?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle('');
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geofireProvider.createWorking(
        _authProvider.getUser().uid,
        _position.latitude,
        _position.longitude
    );
    _progressDialog.hide();
  }

  void updateLocation() async  {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
      _getTravelInfo();
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

      _positionStream = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best, distanceFilter: 1)
          .listen((Position position) async {

        if (travelInfo?.status == 'started') {
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

        if (travelInfo.fromLat != null && travelInfo.fromLng != null) {
          LatLng from = new LatLng(_position.latitude, _position.longitude);
          LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
          isCloseToPickupPosition(from, to);
        }

        saveLocation();
        polyliness();
        refresh();
        await Future.delayed(Duration(milliseconds: 0),() async { swich = false; });
        await Future.delayed(Duration(milliseconds: 0),() async { swichs = false; });
      });

    } catch(error) {
      print('Error en la localizacion: $error');
    }
  }

  void openBottomSheet() {
    if (_client == null) return;

    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetDriverInfo(
          imageUrl: _client?.image,
          username: _client?.username,
          email: _client?.email,
          phone: _client?.cellnumber

        )
    );
  }
  void saveTravel(String typeUser)async{
    _sharedPref.remove('status');
    _sharedPref.save("status", typeUser);
  }
  void saveidClient(String idClient)async{
    _sharedPref.remove('idClient');
    await _sharedPref.save("idClient", idClient);
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
  void ButtonEmergency() async{
    await FlutterPhoneDirectCaller.callNumber('911');
  }
  void ButtonCallPhone()async{
    await FlutterPhoneDirectCaller.callNumber(_client?.cellnumber);
  }
  void ButtonCancel()async{
    dispose();
    saveStatusClient('Haz cancelado el viaje');
    saveTravel('finished');
    Map<String, dynamic> data = {
      'status': 'cancel_finished',
    };
    await _travelInfoProvider.update(data, _idTravel);
    travelInfo.status = 'cancel_finished';
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => DriverMapPage(),
      ),
          (route) => false,
    );
  }
  void saveStatusClient(String typeUser)async{
    _sharedPref.remove('statusclient');
    _sharedPref.save("statusclient", typeUser);
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

  void polyliness(){
    if (status == 'accepted' && bandera == false && swich == false){
      swich = true;
      polylines = {};
      points = List();

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
      addSimpleMarker(
          'from', to.latitude, to.longitude, 'Recoger aqui', '', fromMarker);
      setPolylines(from, to);
    }
        if (status == 'started' || bandera == true && swich == false) {
          swich = true;
          polylines = {};
          points = List();
          markers.removeWhere((key, marker) => marker.markerId.value == 'to');
          addSimpleMarker(
              'to',
              travelInfo.toLat,
              travelInfo.toLng,
              'Destino',
              '',
              toMarker
          );

          LatLng from = new LatLng(_position.latitude, _position.longitude);
          LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

          setPolylines(from, to);
        }


  }

  Future<void> checktravel() async {
    if (status == 'started' && swich == false && swichs == false){
      swichs = true;
      getClientInfo();
      travelInfo.status = 'started';
      currentStatus = 'FINALIZAR VIAJE';
      colorStatus = Colors.red;
      // markers.remove(markers['from']);
      //markers.removeWhere((key, marker) => marker.markerId.value == 'from');
     polylines = {};
      points = List();

      markers.removeWhere((key, marker) => marker.markerId.value == 'to');


      addSimpleMarker(
          'to',
          travelInfo.toLat,
          travelInfo.toLng,
          'Destino',
          '',
          toMarker
      );

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);
      swich = true;

      refresh();

    }
    else
      {
        if (status == 'accepted' && swich == false && swichs == false){
          swichs = true;
          polylines = {};
          points = List();

        markers.removeWhere((key, marker) => marker.markerId.value == 'from');
        markers.removeWhere((key, marker) => marker.markerId.value == 'to');

        LatLng from = new LatLng(_position.latitude, _position.longitude);
        LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
        addSimpleMarker(
            'from', to.latitude, to.longitude, 'Recoger aqui', '', fromMarker);
        setPolylines(from, to);
        swich = true;
      }}
  }

  Future<void> saveHora() async {

    Map<String, dynamic> data = {
      'hora': DateTime.now().hour.truncate(),
      'min': DateTime.now().minute,

    };
    await _travelInfoProvider.update(data, _idTravel);
  }
  Future<void> saveHoraInicio() async {

    Map<String, dynamic> data = {
      'iHora': DateTime.now().toString()
    };
    await _travelInfoProvider.update(data, _idTravel);
  }
  Future<void> saveHoraFinal() async {

    Map<String, dynamic> data = {
      'fHora': DateTime.now().toString(),
    };
    await _travelInfoProvider.update(data, _idTravel);
  }

}
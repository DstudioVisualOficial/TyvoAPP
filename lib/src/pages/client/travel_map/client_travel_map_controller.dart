import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/api/environment.dart';
import 'package:uber/src/homes/utils/color.dart';
import 'package:uber/src/models/travel_info.dart';
import 'package:uber/src/pages/client/map/client_map_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/geofire_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/push_notifications_provider.dart';
import 'package:uber/src/providers/travel_info_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'package:uber/src/utils/snackbar.dart' as utils;
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/widgets/bottom_sheet_client_info.dart';

class ClientTravelMapController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapController = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(1.2342774, -77.2645446),
      zoom: 14.0
  );

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};


  BitmapDescriptor markerDriver;
  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  PushNotificationsProvider _pushNotificationsProvider;
  TravelInfoProvider _travelInfoProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSuscription;

  Set<Polyline> polylines = {};
  List<LatLng> points = new List();
  bool bandera = false;
  Driver driver;
  LatLng _driverLatLng;
  TravelInfo travelInfo;

  bool isRouteReady = false;
  bool swich = false;
  String currentStatus = '';
  Color colorStatus = Colors.white;
  SharedPref _sharedPref;
  bool isPickupTravel = false;
  bool isStartTravel = false;
  bool isFinishTravel = false;
  String status;

  StreamSubscription<DocumentSnapshot> _streamLocationController;

  StreamSubscription<DocumentSnapshot> _streamTravelController;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _sharedPref = new SharedPref();
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    status = await _sharedPref.read('status');
    _driverProvider = new DriverProvider();
    _travelInfoProvider = new TravelInfoProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Conectandose...');

    markerDriver = await createMarkerImageFromAsset('assets/img/uber_car.png');
    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin_red.png');
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin_blue.png');

    checkGPS();
  }

  Future<void> getDriverLocation(String idDriver) async {
    Stream<DocumentSnapshot> stream = _geofireProvider.getLocationByIdStream(idDriver);
    _streamLocationController = stream.listen((DocumentSnapshot document) async {
      GeoPoint geoPoint = document.data()['position']['geopoint'];
      _driverLatLng = new LatLng(geoPoint.latitude, geoPoint.longitude);
      addSimpleMarker(
          'driver',
          _driverLatLng.latitude,
          _driverLatLng.longitude,
          'Tu conductor',
          '',
          markerDriver
      );


        polyliness();
      refresh();
      await Future.delayed(Duration(milliseconds: 0),(){
        swich = false ;
      });

      if (!isRouteReady) {
        isRouteReady = true;
        checkTravelStatus();

      }

    });

  }

  void pickupTravel() {
    if (!isPickupTravel) {
      /*isPickupTravel = true;
      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
      addSimpleMarker('from', to.latitude, to.longitude, 'Recoger aqui', '', fromMarker);
      setPolylines(from, to);*/
    }
  }

  void checkTravelStatus() async {
    Stream<DocumentSnapshot> stream = _travelInfoProvider.getByIdStream(_authProvider.getUser().uid);
    _streamTravelController = stream.listen((DocumentSnapshot document) {
      travelInfo = TravelInfo.fromJson(document.data());

      if (travelInfo.status == 'accepted') {
        currentStatus = 'Viaje aceptado';
        colorStatus = Colors.green;
        pickupTravel();
      }
      else if (travelInfo.status == 'started') {
        currentStatus = 'Viaje iniciado';
        colorStatus = blackColors;
        saveTravel('started');
        startTravel();
      }
      else if (travelInfo.status == 'finished') {
        currentStatus = 'Viaje finalizado';
        colorStatus = Colors.blue;
        saveTravel('finished');
        finishTravel();
      }
      else if (travelInfo.status == 'cancel_finished'){
        currentStatus = 'Viaje Cancelado';
        colorStatus = Colors.red;
        saveTravel('finished');
        dispose();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ClientMapPage(),
          ),
              (route) => false,
        );
      }

      refresh();

    });
  }

  void saveTravel(String typeUser)async{
    _sharedPref.remove('status');
    _sharedPref.save("status", typeUser);
  }

  void openBottomSheet() {
    if (driver == null) return;

    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => BottomSheetClientInfo(
          imageUrl: driver?.image,
          username: driver?.username,
          modeloycolor: driver?.modeloycolor,
          plate: driver?.plate,
        )
    );
  }

  void finishTravel() {
    if (!isFinishTravel) {
      isFinishTravel = true;
      Navigator.pushNamedAndRemoveUntil(context, 'client/travel/calification', (route) => false, arguments: travelInfo.idTravelHistory);
    }
  }

  void startTravel() {
    if (!isStartTravel) {
      isStartTravel = true;
      polylines = {};
      points = List();
      markers.removeWhere((key, marker) => marker.markerId.value == 'from');
      bandera = true;
      /* polylines = {};
      points = List();
      markers.removeWhere((key, marker) => marker.markerId.value == 'from');
      addSimpleMarker(
          'to',
          travelInfo.toLat,
          travelInfo.toLng,
          'Destino',
          '',
          toMarker
      );

      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

      setPolylines(from, to);*/
      refresh();
    }
  }

  void _getTravelInfo() async {
    travelInfo = await _travelInfoProvider.getById(_authProvider.getUser().uid);
    animateCameraToPosition(travelInfo.fromLat, travelInfo.fromLng);
    getDriverInfo(travelInfo.idDriver);
    getDriverLocation(travelInfo.idDriver);
  }

  Future<void> setPolylines(LatLng from, LatLng to) async {

    print('------------------ENTRO SET POLYLINES------------------');

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

  void getDriverInfo(String id) async {
    driver = await _driverProvider.getById(id);
  //  refresh();
  }

  void dispose() {
    _statusSuscription?.cancel();
    _driverInfoSuscription?.cancel();
    _streamLocationController?.cancel();
    _streamTravelController?.cancel();
  }

  void onMapCreated(GoogleMapController controller) {
   // controller.setMapStyle('');
    _mapController.complete(controller);

    _getTravelInfo();
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {
      print('GPS ACTIVADO');
    }
    else {
      print('GPS DESACTIVADO');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        print('ACTIVO EL GPS');
      }
    }

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

  Future<void> polyliness() async {


    if (status == 'started' || bandera == true && swich == false ){
      swich = true;
        print('-------------------------------ENTRO EN LINEA STARTED-------------------------');

        markers.removeWhere((key, marker) => marker.markerId.value == 'to');
      polylines = {};
      points = List();
        addSimpleMarker(
            'to',
            travelInfo.toLat,
            travelInfo.toLng,
            'Destino',
            '',
            toMarker
        );

        LatLng from = new LatLng(
            _driverLatLng.latitude, _driverLatLng.longitude);
        LatLng to = new LatLng(travelInfo.toLat, travelInfo.toLng);

       await setPolylines(from, to);

        refresh();
    }
    if (status == 'accepted' && bandera == false && swich == false) {
      swich = true;
      polylines = {};
      points = List();
      markers.removeWhere((key, marker) => marker.markerId.value == 'from');
      LatLng from = new LatLng(_driverLatLng.latitude, _driverLatLng.longitude);
      LatLng to = new LatLng(travelInfo.fromLat, travelInfo.fromLng);
      addSimpleMarker(
          'from', to.latitude, to.longitude, 'Recoger aqui', '', fromMarker);
       await setPolylines(from, to);

      refresh();

    }

    }

  }


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uber/src/models/driver.dart';
import 'package:uber/src/pages/client/pagesClient/splash_page.dart';
import 'package:uber/src/pages/driver/cotizacion/drive_map_page_cotizacion.dart';
import 'package:uber/src/pages/driver/taximetroxpuntos/driver_travel_map_taximetroxpuntos_page.dart';
import 'package:uber/src/providers/auth_provider.dart';
import 'package:uber/src/providers/driver_provider.dart';
import 'package:uber/src/providers/geofire_provider.dart';
import 'package:uber/src/providers/push_notifications_provider.dart';
import 'package:uber/src/utils/my_progress_dialog.dart';
import 'package:uber/src/utils/shared_pref.dart';

import 'package:uber/src/utils/snackbar.dart' as utils;

class DriverMapController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  GeofireProvider _geofireProvider;
  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  PushNotificationsProvider _pushNotificationsProvider;

  bool isConnect = false;
  ProgressDialog _progressDialog;

  StreamSubscription<DocumentSnapshot> _statusSuscription;
  StreamSubscription<DocumentSnapshot> _driverInfoSuscription;
  SharedPref _sharedPref;
  Driver driver;
  String status;


  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _geofireProvider = new GeofireProvider();
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _sharedPref = new SharedPref();
    status = await SharedPref().read('statusclient');
    _pushNotificationsProvider = new PushNotificationsProvider();
    _progressDialog =
        MyProgressDialog.createProgressDialog(context, 'Conectandose...');
    markerDriver = await createMarkerImageFromAsset('assets/img/uber_car.png');
    checkGPS();
    saveToken();
    getDriverInfo();
    checkdata();

  }

  void getDriverInfo() {
    Stream<DocumentSnapshot> driverStream = _driverProvider.getByIdStream(
        _authProvider
            .getUser()
            .uid);
    _driverInfoSuscription = driverStream.listen((DocumentSnapshot document) {
      driver = Driver.fromJson(document.data());
      refresh();

    });
  }

  void saveToken() {
    _pushNotificationsProvider.saveToken(_authProvider
        .getUser()
        .uid, 'driver');
  }

  void openDrawer() {
    checkdata();
    key.currentState.openDrawer();
  }

  void goToEditPage() {
    if ( driver.username == null) {
      disconnect();
      status = 'Error al cargar los datos';
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        showCancelBtn: false,
        borderRadius: 30,
        backgroundColor: Colors.black,
        cancelBtnTextStyle: TextStyle(color: Colors.white),
        confirmBtnTextStyle: TextStyle(color: Colors.white),
        text: 'Error al cargar los datos.',
        title: 'ERROR',
        confirmBtnText: 'Reintentar',
        onConfirmBtnTap: () => {    _auth.signOut().then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SplashPage())))},
        confirmBtnColor: Colors.red,

      );
    }
    else {
      Navigator.pushNamed(context, 'driver/edit');
    }
  }

  void goToHistoryPage() {
    if ( driver.username == null) {
      disconnect();
      status = 'Error al cargar los datos';
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        showCancelBtn: false,
        borderRadius: 30,
        backgroundColor: Colors.black,
        cancelBtnTextStyle: TextStyle(color: Colors.white),
        confirmBtnTextStyle: TextStyle(color: Colors.white),
        text: 'Error al cargar los datos.',
        title: 'ERROR',
        confirmBtnText: 'Reintentar',
        onConfirmBtnTap: () => {    _auth.signOut().then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SplashPage())))},
        confirmBtnColor: Colors.red,

      );
    }
    else {
      Navigator.pushNamed(context, 'driverhistory');
    }
  }

  void goToHistoryTaximetroPage() {
    if ( driver.username == null) {
      disconnect();
      status = 'Error al cargar los datos';
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        showCancelBtn: false,
        borderRadius: 30,
        backgroundColor: Colors.black,
        cancelBtnTextStyle: TextStyle(color: Colors.white),
        confirmBtnTextStyle: TextStyle(color: Colors.white),
        text: 'Error al cargar los datos.',
        title: 'ERROR',
        confirmBtnText: 'Reintentar',
        onConfirmBtnTap: () => {    _auth.signOut().then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SplashPage())))},
        confirmBtnColor: Colors.red,

      );
    }
    else{
    Navigator.pushNamed(context, 'driver/agenda');
  }}

  void goToTaximetroPage() {
    if ( driver.username == null) {
      disconnect();
      status = 'Error al cargar los datos';
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        showCancelBtn: false,
        borderRadius: 30,
        backgroundColor: Colors.black,
        cancelBtnTextStyle: TextStyle(color: Colors.white),
        confirmBtnTextStyle: TextStyle(color: Colors.white),
        text: 'Error al cargar los datos.',
        title: 'ERROR',
        confirmBtnText: 'Reintentar',
        onConfirmBtnTap: () => {    _auth.signOut().then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SplashPage())))},
        confirmBtnColor: Colors.red,

      );
    }
    else{
    dispose();
    disconnect();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) =>
            DriverTravelMapTaximetroXPuntosPage()));}
  }

  void goToCotizacionPage() {
    if ( driver.username == null) {
      disconnect();
      status = 'Error al cargar los datos';
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        showCancelBtn: false,
        borderRadius: 30,
        backgroundColor: Colors.black,
        cancelBtnTextStyle: TextStyle(color: Colors.white),
        confirmBtnTextStyle: TextStyle(color: Colors.white),
        text: 'Error al cargar los datos.',
        title: 'ERROR',
        confirmBtnText: 'Reintentar',
        onConfirmBtnTap: () => {    _auth.signOut().then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SplashPage())))},
        confirmBtnColor: Colors.red,

      );
    }
    else {
      dispose();
      disconnect();
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (BuildContext context) => DriveMapPageCotizacion()));
    }
  }

  void dispose() {
    _positionStream?.cancel();
    _statusSuscription?.cancel();
    _driverInfoSuscription?.cancel();
  }

  void signOut() async {
    _sharedPref.remove('status');
    _sharedPref.remove('statusclient');
    _sharedPref.remove('idClient');

    _auth.signOut().then((value) =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => SplashPage())));
  }

  void onMapCreated(GoogleMapController controller) {
    //controller.setMapStyle('');
    _mapController.complete(controller);
  }

  void saveLocation() async {
    await _geofireProvider.create(
        _authProvider
            .getUser()
            .uid,
        _position.latitude,
        _position.longitude
    );
    _progressDialog.hide();
  }

  void connect() {
    if ( driver.username == null) {
      disconnect();
      status = 'Error al cargar los datos';
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        showCancelBtn: false,
        borderRadius: 30,
        backgroundColor: Colors.black,
        cancelBtnTextStyle: TextStyle(color: Colors.white),
        confirmBtnTextStyle: TextStyle(color: Colors.white),
        text: 'Error al cargar los datos.',
        title: 'ERROR',
        confirmBtnText: 'Reintentar',
        onConfirmBtnTap: () => {    _auth.signOut().then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SplashPage())))},
        confirmBtnColor: Colors.red,

      );
    }
    else{
    if (isConnect) {
      disconnect();
    }
    else {
      _progressDialog.show();
      updateLocation();
    }}
  }

  void disconnect() {
    _positionStream?.cancel();
    _geofireProvider.delete(_authProvider
        .getUser()
        .uid);
  }

  void checkIfIsConnect() {
    Stream<DocumentSnapshot> status =
    _geofireProvider.getLocationByIdStream(_authProvider
        .getUser()
        .uid);

    _statusSuscription = status.listen((DocumentSnapshot document) {
      if (document.exists) {
        isConnect = true;
      }
      else {
        isConnect = false;
      }

      refresh();
    });
  }

  void updateLocation() async {
    try {
      await _determinePosition();
      _position = await Geolocator.getLastKnownPosition();
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
          desiredAccuracy: LocationAccuracy.best,
          distanceFilter: 1
      ).listen((Position position) {
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
        saveLocation();
        refresh();
      });
    } catch (error) {
      print('Error en la localizacion: $error');
    }
  }

  void centerPosition() {
    if (_position != null) {
      animateCameraToPosition(_position.latitude, _position.longitude);
    }
    else {
      utils.Snackbar.showSnacbar(
          context, key, 'Activa el GPS para obtener la posicion');
    }
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationEnabled) {

      print('GPS ACTIVADO');
      updateLocation();

      checkIfIsConnect();
    }
    else {
      print('GPS DESACTIVADO');
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {

        updateLocation();

        checkIfIsConnect();
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

  void addMarker(String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker) {
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

  void checkdata() {
    if ( driver.username == null) {
      disconnect();
      status = 'Error al cargar los datos';
      CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        showCancelBtn: false,
        borderRadius: 30,
        backgroundColor: Colors.black,
        cancelBtnTextStyle: TextStyle(color: Colors.white),
        confirmBtnTextStyle: TextStyle(color: Colors.white),
        text: 'Error al cargar los datos.',
        title: 'ERROR',
        confirmBtnText: 'Reintentar',
        onConfirmBtnTap: () => {    _auth.signOut().then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SplashPage())))},
        confirmBtnColor: Colors.red,

      );
    }
  }

}
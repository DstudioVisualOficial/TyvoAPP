import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:uber/src/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'client_provider.dart';
import 'driver_provider.dart';

class PushNotificationsProvider{
FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
StreamController _streamController =
StreamController<Map<String, dynamic>>.broadcast();

Stream<Map<String, dynamic>> get message => _streamController.stream;



Future<void> initPushNotifications() async {

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
    if(message !=null){
      Map<String, dynamic> data = message.data;
      SharedPref sharedPref = new SharedPref();
      sharedPref.save('isNotification', 'value');
      _streamController.sink.add(data);
    }
  });
  
  
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;


    Map<String,dynamic> data = message.data;
    print('Cuando estamos en primer plano');
    print('OnMessage: $data');
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28
      volume: 1.0, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
    Future.delayed(Duration(milliseconds: 7000),()
    {
      FlutterRingtonePlayer.stop();
    });
    _streamController.sink.add(data);

    }
  );

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    Map<String,dynamic> data = message.data;
    print('OnResume $data');
    _streamController.sink.add(data);
  });


 /* _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print('Cuando estamos en primer plano');
        print('OnMessage: $message');
        _streamController.sink.add(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print('OnLaunch: $message');
        _streamController.sink.add(message);
        SharedPref sharedPref = new SharedPref();
        sharedPref.save('isNotification', 'true');
      },
      onResume: (Map<String, dynamic> message) {
        print('OnResume $message');
        _streamController.sink.add(message);
      }
  );

  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true,
          badge: true,
          alert: true,
          provisional: true
      )
  );

  _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
    print('Coonfiguraciones para Ios fueron regustradas $settings');
  });
*/


}

void saveToken(String idUser, String typeUser) async {
  String token = await _firebaseMessaging.getToken();
  Map<String, dynamic> data = {
    'token': token
  };

  if (typeUser == 'client') {
    ClientProvider clientProvider = new ClientProvider();
    clientProvider.update(data, idUser);
  }
  else {
    DriverProvider driverProvider = new DriverProvider();
    driverProvider.update(data, idUser);
  }

}
Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async {
  await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAlNFsHtk:APA91bHDScr5JoES-InoaFVDhfVSFMGqpeC8e_2qkVehpAhwYj28UfKxk2OtzqtYwNzCW4FjxPUpgrdJKCp-5oh9TFZ4-sc83ipO9a0y5rJeRH5Vnt8QiHo4AYnqqREHdq4yk366FexI'
      },
  body: jsonEncode(
          <String, dynamic> {
            'notification': <String, dynamic> {
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'ttl': '4500s',
            'data': data,
            'to': to
          }
      )
  );

}
void dispose () {
  _streamController?.onCancel;
}
}
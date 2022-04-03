import 'dart:async';
import 'dart:convert';

import 'package:geocode/geocode.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../Models/Calender/calender_model.dart';

class ApiService{

var address;
late String city;


  Future<CalenderModel> getdata() async {

    Position p =await  determinePosition();
    print(p.latitude);
    print(p.longitude);

    GeoCode geoCode = GeoCode();
     address=  await geoCode.reverseGeocoding(latitude:   p.latitude, longitude:p.longitude);
    print(address.city);
    city=address.city.toString();

    String url = 'http://api.aladhan.com/v1/calendar?latitude=${p.latitude}&longitude=${p.longitude}&method=1&month=4&year=2022';
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    print(response.body.length);
    if (response.statusCode == 200) {
      return CalenderModel.fromJson(data);
    } else {
      return CalenderModel.fromJson(data);
    }
  }




  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services
//Geolocator.isLocationServiceEnabled();
      Geolocator.requestPermission();
      // return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }



















}



// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class YourLocation extends StatefulWidget {
  @override
  _YourLocationState createState() => _YourLocationState();
}

class _YourLocationState extends State<YourLocation> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;
  LatLng _markerPosition = LatLng(26.850000, 80.949997); // Default marker position
  String _address = 'Lucknow';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

 Future<void> _getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  setState(() {
    _currentPosition = LatLng(position.latitude, position.longitude);
    _markerPosition = _currentPosition!;
  });

  if (_controller != null) {
    _controller!.animateCamera(
      CameraUpdate.newLatLng(_currentPosition!),
    );
  }
}



Future<void> _updateAddress(LatLng position) async {
  List<Placemark> result = await placemarkFromCoordinates(position.latitude, position.longitude);
  if (result.isNotEmpty) {
    setState(() {
      _address = '${result[0].name}, ${result[0].locality}, ${result[0].administrativeArea}';
    });

    // Show toast message
    if (_address.isNotEmpty) {
      Fluttertoast.showToast(
        msg: '📍 $_address',
        toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
        gravity: ToastGravity.BOTTOM, // Toast position
        timeInSecForIosWeb: 1, // Duration for iOS Web
        backgroundColor: Colors.black, // Background color
        textColor: Colors.white, // Text color
        fontSize: 16.0, // Font size
      );
    }
  }
}


  void _setMarker(LatLng position) {
    setState(() {
      _markerPosition = position;
      _updateAddress(position);
    });
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Your Location'),
    ),
    body: _currentPosition == null
        ? Center(child: CircularProgressIndicator())
        : GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 14.0,
            ),
            markers: {
              Marker(
                markerId: MarkerId("currentLocation"),
                position: _markerPosition,
                infoWindow: InfoWindow(title: _address),
                draggable: true,
                onDragEnd: (newPosition) {
                  _setMarker(newPosition);
                },
              ),
            },
            onTap: (position) {
              _setMarker(position);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
  );
}



}

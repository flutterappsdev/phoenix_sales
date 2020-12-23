import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../network/network.dart';
import '../constant/constants.dart';

class TripScreen extends StatefulWidget {
  static const String id = 'TripScreen';
  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  LatLng currentmarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  void initState() {
    // TODO: implement initState
    setUpPositionLocator();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // location = Location();
    // location.onLocationChanged.listen((LocationData cLoc) {
    //   currentLocation = cLoc;
    setUpPositionLocator();
    // });

    super.didChangeDependencies();
  }

  void setUpPositionLocator() async {
    try {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      currentLocation = await location.getLocation();

      LatLng pos = LatLng(currentLocation.latitude, currentLocation.longitude);
      print("Laongtide ");
      CameraPosition cp = CameraPosition(target: pos, zoom: 14);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
      //print(address);
      //print(Provider.of<AppData>(context).pickUpAddress.placeAddress);

    } catch (e) {
      print("krishna $e");
    }
  }

  Future _addMarkerLongPressed(LatLng latlang) async {
    setState(() {
      final MarkerId markerId = MarkerId("RANDOM_ID");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position:
            latlang, //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: "Marker here",
          snippet: 'This looks good',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      markers[markerId] = marker;
    });

    //This is optional, it will zoom when the marker has been created
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latlang, 15.0));
  }

  upLoadLocation() async {

    List<String>  d = DateTime.now().toString().split(' ');
    List<String>  d1 = d[1].split('.');


    try {
      String urlserver =
          '$Url/InsertLocation?UserName=$UserName&UserType=$UserType&AreaCode=$AreaCode&longi=${currentmarker.longitude}&lat=${currentmarker.latitude}&time=${d[0]}&date=${d[1]}&type=0&d=0';
      print(urlserver);
      NetworkHelper networkHelper = NetworkHelper(urlserver);
      var data = await networkHelper.getData();
      print(data);
    } catch (e) {
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.all(20),
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
              },
              onTap: (latlang) {
                print(latlang.longitude);
                setState(() {
                  currentmarker = latlang;

                });
                upLoadLocation();
                _addMarkerLongPressed(latlang);
              },
              markers: Set<Marker>.of(markers.values), //all markers are here
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.clear,size: 30),
        onPressed: (){
          Navigator.of(context).pop();
        },
      )
    );
  }
}

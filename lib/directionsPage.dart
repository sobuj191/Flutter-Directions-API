import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DirectionsPage extends StatefulWidget {
  @override
  _DirectionsPageState createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  final String accessToken = 'Add your Access Token';
  LatLng origin = LatLng(37.7749, 12.5194); // San Francisco, CA
  LatLng destination = LatLng(37.8749, 12.5194); // Los Angeles, CA
  String apiUrl = '';
  double distance = 0.0;
  double duration = 0.0;

  List<LatLng> routeCoordinates = [];
  @override
  void initState() {
    super.initState();
    fetchDirections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapbox Directions Example'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              zoom: 12.0,
              center: origin,
            ),
            children: [
              TileLayer(

                  urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}@2x?access_token=$accessToken',
                ),

              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: origin, // Marker 1
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 50.0,
                    ),
                    ),

                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: destination, // Marker 2

                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30.0,
                      ),
                    ),

                ],
              ),
              if(routeCoordinates.isNotEmpty)
              PolylineLayer(
                polylines: [
                Polyline(
                  points: routeCoordinates,
                  color: Colors.blue,
                  strokeWidth: 3.0,
                ),
              ],
              ),

            ],
          ),
          if (distance > 0 && duration > 0)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Distance: ${distance.toStringAsFixed(2)} km',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Duration: ${duration.toStringAsFixed(2)} minutes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

 Future<void> fetchDirections() async {

      apiUrl = 'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.longitude}%2C${origin.latitude}%3B${destination.longitude}%2C${destination.latitude}?alternatives=true&annotations=distance%2Cduration%2Cspeed&exclude=toll%2Cmotorway%2Cferry%2Cunpaved%2Ccash_only_tolls&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken';


    final response = await http.get(Uri.parse(apiUrl));
print(response.statusCode);
print(origin.latitude);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> routes = data['routes'];
      if (routes.isNotEmpty) {
        List<dynamic> coordinates = routes[0]['geometry']['coordinates'];
        setState(() {
          routeCoordinates = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
          distance = routes[0]['distance'] / 1000;
          duration = routes[0]['duration'] / 60;
        });
      }
      print("---------------------------------");
      print(routeCoordinates);
    } else {
      throw Exception('Failed to load directions');
    }
  }
}

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
  final String accessToken = '';
  LatLng origin = LatLng(37.7749, 12.5194); // San Francisco, CA
  LatLng destination = LatLng(37.8749, 12.5194); // Los Angeles, CA
  String apiUrl = '';

  List<LatLng> routeCoordinates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapbox Directions Example'),
      ),
      body: Stack(
        children: [
          // FlutterMap(
          //   options: MapOptions(
          //     zoom: 18,
          //     center: LatLng(37.7749, -122.4194),
          //   ),
          //   layers: [
          //     // Tile Layer for the map background
          //     TileLayerOptions(
          //       urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}@2x?access_token=$accessToken',
          //     ),
          //     // Polyline Layer for drawing the route
          //     PolylineLayerOptions(
          //       polylines: [
          //         Polyline(
          //           points: routeCoordinates,
          //           color: Colors.blue,
          //           strokeWidth: 3.0,
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
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
              PolylineLayer(
                polylines: [
                Polyline(
                  points: routeCoordinates,
                  color: Colors.red,
                  strokeWidth: 3.0,
                ),
              ],
              ),
            ],
          ),

          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                fetchDirections();
              },
              child: Text('Fetch Directions'),
            ),
          ),
        ],
      ),
    );
  }

  void fetchDirections() async {
    setState(() {
      apiUrl = 'https://api.mapbox.com/directions/v5/mapbox/driving/${origin.latitude}, ${origin.longitude}; ${destination.latitude}, ${destination.longitude}?steps=true&geometries=geojson&access_token=$accessToken';
    });

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
        });
      }
      print("---------------------------------");
      print(routeCoordinates);
    } else {
      throw Exception('Failed to load directions');
    }
  }
}

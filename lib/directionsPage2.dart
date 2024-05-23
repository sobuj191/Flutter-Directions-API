// // final String accessToken = 'pk.eyJ1IjoiemFpZGt1YmEiLCJhIjoiY2x1dGF2YzRhMDhieDJqcWYyZDloN203cyJ9.4ErZHaGTRhTqz4FRcUWn-w';
//
// class _MyHomePageState extends State<MyHomePage> {
//   List<LatLng> latlngList = List<LatLng>();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     loadAsset();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: FlutterMap(
//           options: MapOptions(
//             center: LatLng(31.050478, -7.931633),
//             zoom: 12.0,
//           ),
//           layers: [
//             TileLayerOptions(
//               urlTemplate:
//               "",
//               additionalOptions: {
//                 'accessToken':
//                 '',
//                 'id': 'mapbox.streets',
//               },
//             ),
//             MarkerLayerOptions(
//               markers: [
//                 Marker(
//                   width: 50.0,
//                   height: 50.0,
//                   point: LatLng(31.050478, -7.931633),
//                   builder: (ctx) => Container(
//                     child: Image.asset(
//                       "use an image for marker",
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             PolylineLayerOptions(polylines: [
//               Polyline(
//                 points: latlngList,
//                 // isDotted: true,
//                 color: Color(0xFF669DF6),
//                 strokeWidth: 3.0,
//                 borderColor: Color(0xFF1967D2),
//                 borderStrokeWidth: 0.1,
//               )
//             ])
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<String> loadAsset() async {
//     return await rootBundle
//         .loadString('assets/json/toubkal_2.json')
//         .then((onValue) {
//       setState(() {
//         RoadList.fromJson(json.decode(onValue)).roadList.forEach((data) {
//           latlngList.add(LatLng(data.lat, data.lng));
//         });
//       });
//
//       print('=====> latlng : ' + latlngList.length.toString());
//     });
//   }
//
// }

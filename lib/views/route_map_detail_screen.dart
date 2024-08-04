import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/detailed_stop_schema.dart';
import '../models/detailed_bus_schema.dart';

class RouteMapScreen extends StatefulWidget {
  final List<DetailedStopSchema> stops;
  final List<DetailedBusSchema> buses;

  RouteMapScreen({required this.stops, required this.buses});

  @override
  _RouteMapScreenState createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addStopsToMap();
    _addBusesToMap();
    _drawRouteLine();
  }

  void _addStopsToMap() {
    setState(() {
      _markers.addAll(widget.stops.map((stop) {
        return Marker(
          markerId: MarkerId(stop.stopId),
          position: LatLng(stop.position.latitude, stop.position.longitude),
          infoWindow: InfoWindow(title: stop.stopName),
        );
      }));
    });
  }

  void _addBusesToMap() {
    setState(() {
      _markers.addAll(widget.buses.map((bus) {
        return Marker(
          markerId: MarkerId(bus.busId),
          position: LatLng(bus.position.latitude, bus.position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Bus ${bus.busId}'),
        );
      }));
    });
  }

  void _drawRouteLine() {
    final List<LatLng> polylineCoordinates = widget.stops.map((stop) =>
        LatLng(stop.position.latitude, stop.position.longitude)).toList();

    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Map'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.stops.first.position.latitude, widget.stops.first.position.longitude),
            zoom: 13,
          ),
          markers: _markers,
          polylines: _polylines,
        ),
      ),
    );
  }
}
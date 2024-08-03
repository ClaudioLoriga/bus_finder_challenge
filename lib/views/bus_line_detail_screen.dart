import 'package:bus_finder_challenge/models/detailed_stop_schema.dart';
import 'package:flutter/material.dart';
import '../models/detailed_bus_schema.dart';
import '../models/direction.dart';
import '../models/route_detail.dart';
import '../view_models/bus_line_detail_view_model.dart';

class BusLineDetailScreen extends StatefulWidget {
  final String? routeId;

  const BusLineDetailScreen({required this.routeId});

  @override
  _BusLineDetailScreenState createState() => _BusLineDetailScreenState();
}

class _BusLineDetailScreenState extends State<BusLineDetailScreen> {
  late BusLineDetailViewModel _viewModel;
  bool _isLoading = true;
  String? _error;
  String? _selectedDirectionKey;

  @override
  void initState() {
    super.initState();
    _viewModel = BusLineDetailViewModel(widget.routeId);
    _loadRouteDetail();
  }

  Future<void> _loadRouteDetail() async {
    try {
      await _viewModel.fetchRouteDetail();
      setState(() {
        _isLoading = false;
        if (_viewModel.routeDetail?.directions.isNotEmpty ?? false) {
          _selectedDirectionKey = _viewModel.routeDetail!.directions.keys.first;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.routeId!.replaceAll('_', ' ')),
        actions: [
          TextButton(
            child:
            Text('Mappa', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              // Implement map functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isLoading && _error == null && _viewModel.routeDetail != null)
            _buildDirectionButtons(),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Linee'),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bus), label: 'Mezzi'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Vicino a te'),
        ],
      ),
    );
  }

  Widget _buildDirectionButtons() {
    return Container(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _viewModel.routeDetail!.directions.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedDirectionKey == entry.key
                    ? Colors.blue
                    : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _selectedDirectionKey = entry.key;
                });
              },
              child: Text(entry.key.substring(0, entry.key.indexOf('_'))),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(child: Text('Error: $_error'));
    } else if (_viewModel.routeDetail != null) {
      return Padding(
        padding: EdgeInsets.only(top: 16.0),  // Add padding here
        child: _buildBusInfoView(_viewModel.routeDetail!),
      );
    } else {
      return Center(child: Text('No data available'));
    }
  }

  Widget _buildBusInfoView(RouteDetail routeDetail) {
    if (_selectedDirectionKey == null) {
      return Center(child: Text('No direction selected'));
    }
    Direction selectedDirection =
    routeDetail.directions[_selectedDirectionKey]!;
    return _buildStopsList(selectedDirection.stops, selectedDirection.busList);
  }

  Widget _buildStopsList(List<DetailedStopSchema> stops, List<DetailedBusSchema> buses) {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: stops.length,
      itemBuilder: (context, index) {
        final stop = stops[index];
        final isFirstStop = index == 0;
        final isLastStop = index == stops.length - 1;

        return Stack(
          children: [
            // Continuous blue line
            if (!isLastStop)
              Positioned(
                left: 19,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: Colors.blue,
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFirstStop || isLastStop ? Colors.blue : Colors.white,
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stop.stopName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (stop.capolinea)
                            Text(
                              '(${isLastStop ? 'capolinea' : 'capolinea'})',
                              style: TextStyle(color: Colors.grey),
                            ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
                // Add bus information if available
                if (!isLastStop)
                  _buildBusInfo(buses, stop, stops[index + 1]),
                SizedBox(height: 20), // Add some space between stops
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBusInfo(List<DetailedBusSchema> buses, DetailedStopSchema currentStop, DetailedStopSchema nextStop) {
    DetailedBusSchema? matchingBus;

    try {
      matchingBus = buses.firstWhere(
            (bus) => bus.originStopId == currentStop.stopId && bus.destinationStopId == nextStop.stopId,
      );
    } catch (e) {
      // No matching bus found
      matchingBus = null;
    }

    if (matchingBus != null) {
      return Padding(
        padding: EdgeInsets.only(left: 40, bottom: 8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_bus, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text(
                '${matchingBus.busId} (in orario)',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}

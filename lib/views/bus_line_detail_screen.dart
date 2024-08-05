import 'package:flutter/material.dart';
import '../models/detailed_stop_schema.dart';
import '../models/detailed_bus_schema.dart';
import '../models/direction.dart';
import '../models/route_detail.dart';
import '../utils/utils.dart';
import '../view_models/bus_line_detail_view_model.dart';
import 'custom_widgets/custom_bottom_navigation_bar.dart';
import 'route_map_detail_screen.dart';

class BusLineDetailScreen extends StatefulWidget {
  final String? routeId;

  const BusLineDetailScreen({required this.routeId});

  @override
  _BusLineDetailScreenState createState() => _BusLineDetailScreenState();
}

class _BusLineDetailScreenState extends State<BusLineDetailScreen> {
  late BusLineDetailViewModel _viewModel;
  String? _selectedDirectionKey;

  @override
  void initState() {
    super.initState();
    _viewModel = BusLineDetailViewModel(widget.routeId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.routeId!.replaceAll('_', ' ')),
        actions: [
          StreamBuilder<RouteDetail>(
            stream: _viewModel.routeDetailStream,
            builder: (context, snapshot) {
              return TextButton(
                onPressed: snapshot.hasData
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RouteMapScreen(
                              routeId: widget.routeId!,
                              stops: snapshot.data!
                                  .directions[_selectedDirectionKey]!.stops,
                              buses: snapshot.data!
                                  .directions[_selectedDirectionKey]!.busList,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text(mappa,
                    style: TextStyle(color: Colors.blue)),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<RouteDetail>(
        stream: _viewModel.routeDetailStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _buildDirectionButtons(snapshot.data!),
                const SizedBox(height: heigth16),
                Expanded(child: _buildBusInfoView(snapshot.data!)),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('$error ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) {
            // Navigate back to HomepageScreen if not already there
            if (index == 0) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              // Show a placeholder message for other tabs
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(featureNotImplementedYet)),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildDirectionButtons(RouteDetail routeDetail) {
    if (_selectedDirectionKey == null && routeDetail.directions.isNotEmpty) {
      _selectedDirectionKey = routeDetail.directions.keys.first;
    }

    return SizedBox(
      height: height50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: routeDetail.directions.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding4),
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

  Widget _buildBusInfoView(RouteDetail routeDetail) {
    if (_selectedDirectionKey == null) {
      return const Center(child: Text(noDirectionSelected));
    }
    Direction selectedDirection =
        routeDetail.directions[_selectedDirectionKey]!;
    return _buildStopsList(selectedDirection.stops, selectedDirection.busList);
  }

  Widget _buildStopsList(
      List<DetailedStopSchema> stops, List<DetailedBusSchema> buses) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
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
                  width: width2,
                  color: Colors.blue,
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width40,
                      child: Container(
                        width: width12,
                        height: heigth12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFirstStop || isLastStop
                              ? Colors.blue
                              : Colors.white,
                          border: Border.all(color: Colors.blue, width: width2),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stop.stopName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (stop.capolinea)
                            Text(
                              '(${isLastStop ? capolinea : capolinea})',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          const SizedBox(height: heigth8),
                        ],
                      ),
                    ),
                  ],
                ),
                // Add bus information if available
                if (!isLastStop) _buildBusInfo(buses, stop, stops[index + 1]),
                const SizedBox(height: heigth20), // Add some space between stops
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBusInfo(List<DetailedBusSchema> buses,
      DetailedStopSchema currentStop, DetailedStopSchema nextStop) {
    DetailedBusSchema? matchingBus;

    try {
      matchingBus = buses.firstWhere(
        (bus) =>
            bus.originStopId == currentStop.stopId &&
            bus.destinationStopId == nextStop.stopId,
      );
    } catch (e) {
      // No matching bus found
      matchingBus = null;
    }

    if (matchingBus != null) {
      return Padding(
        padding: const EdgeInsets.only(left: padding40, bottom: padding8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: padding8, vertical: padding4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(padding4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.directions_bus, color: Colors.white, size: size16),
              const SizedBox(width: width4),
              Text(
                '${matchingBus.busId} $inOrario',
                style: const TextStyle(color: Colors.white, fontSize: fontSize12),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

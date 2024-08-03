import 'package:flutter/material.dart';
import '../models/line.dart';
import '../view_models/bus_lines_view_model.dart';
import '../models/vehicle_id_schema.dart';
import 'bus_line_detail_screen.dart';

class HomepageScreen extends StatelessWidget {
  final BusLinesViewModel viewModel = BusLinesViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Linee'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<List<Line>>(
        stream: viewModel.busLinesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Line busLine = snapshot.data![index];
                return ListTile(
                  leading: Icon(Icons.directions_outlined, color: Colors.blue),
                  title: Text('Linea ${busLine.trip?.routeId.replaceAll('_', ' ')}'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusLineDetailScreen(
                          routeId: busLine.trip?.routeId,
                        ),
                      ),
                    );                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions),
            label: 'Linee',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Mezzi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop),
            label: 'Vicino a te',
          ),
        ],
      ),
    );
  }
}
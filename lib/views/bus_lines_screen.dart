// homepage_screen.dart
import 'package:bus_finder_challenge/utils/utils.dart';
import 'package:flutter/material.dart';
import '../models/line.dart';
import '../view_models/bus_lines_view_model.dart';
import 'bus_line_detail_screen.dart';
import 'custom_widgets/custom_bottom_navigation_bar.dart';

class HomepageScreen extends StatelessWidget {
  final BusLinesViewModel viewModel = BusLinesViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(linesLabel),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
                  leading: const Icon(Icons.directions_outlined, color: Colors.blue),
                  title: Text('$linea ${busLine.trip?.routeId.replaceAll('_', ' ')}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusLineDetailScreen(
                          routeId: busLine.trip?.routeId,
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => const Divider(),
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
          // Handle navigation here
          if (index != 0) {
            // Navigate to other screens or show a placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(featureNotImplementedYet)),
            );
          }
        },
      ),
    );
  }
}
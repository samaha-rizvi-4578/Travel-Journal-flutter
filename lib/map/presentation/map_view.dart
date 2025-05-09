import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter for navigation
import '../../map/bloc/map_event.dart';
import '../../map/bloc/map_state.dart';
import '../../map/bloc/map_bloc.dart';
import '../../map/data/map_service.dart';
import '../../journal/data/journal_model.dart';
import '../../journal/data/journal_repository.dart';
import 'package:auth_ui/auth_ui.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('You must be logged in')));
    }

    return BlocProvider(
      create: (context) => MapBloc(
        mapService: MapService(context.read<JournalRepository>()),
      )..add(LoadMapMarkers(userEmail: user.email)), // Pass active user's email
      child: Scaffold(
        appBar: AppBar(title: const Text('Visited Locations')),
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MapReady && state.markers.isNotEmpty) {
              return _buildOpenStreetMap(context, state.markers);
            } else if (state is MapError) {
              return Center(child: Text('Error loading map: ${state.message}'));
            } else {
              return const Center(child: Text('No locations found.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildOpenStreetMap(BuildContext context, List<TravelJournal> journals) {
    final markers = journals
        .where((j) => j.latitude != null && j.longitude != null)
        .map(
          (j) => Marker(
            width: 80,
            height: 80,
            point: LatLng(j.latitude!, j.longitude!),
            child: GestureDetector(
              onTap: () {
                // Navigate to the ViewJournalPage for the tapped journal
                context.push('/journal/${j.id}');
              },
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),
        )
        .toList();

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          journals.isNotEmpty && journals[0].latitude != null
              ? journals[0].latitude!
              : 0,
          journals.isNotEmpty && journals[0].longitude != null
              ? journals[0].longitude!
              : 0,
        ),
        minZoom: 1,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
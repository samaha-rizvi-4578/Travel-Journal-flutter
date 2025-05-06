// map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      return const Scaffold(
        body: Center(child: Text('You must be logged in')),
      );
    }

    return BlocProvider(
      create: (context) => MapBloc(mapService: MapService(context.read<JournalRepository>()))
        ..add(LoadMapMarkers(userId: user.id)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Visited Locations')),
        body: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MapReady && state.markers.isNotEmpty) {
              return _buildGoogleMap(state.markers);
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

  Widget _buildGoogleMap(List<TravelJournal> journals) {
    // Create markers only if latitude/longitude exist
    final markers = journals
        .where((j) => j.latitude != null && j.longitude != null)
        .map((j) => Marker(
              markerId: MarkerId(j.id),
              position: LatLng(j.latitude!, j.longitude!),
              infoWindow: InfoWindow(title: j.placeName),
              onTap: () {
                // Navigate to journal detail page
                // Replace this with your navigation logic
                print("Tapped on ${j.placeName}");
              },
            ))
        .toSet();

    // Default fallback camera position
    final CameraPosition initialCameraPosition = journals.isNotEmpty &&
            journals[0].latitude != null &&
            journals[0].longitude != null
        ? CameraPosition(
            target: LatLng(journals[0].latitude!, journals[0].longitude!), zoom: 5)
        : const CameraPosition(target: LatLng(0, 0), zoom: 1);

    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      markers: markers,
      myLocationEnabled: true,
      mapType: MapType.normal,
      compassEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
    );
  }
}
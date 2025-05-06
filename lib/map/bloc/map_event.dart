// lib/map/bloc/map_event.dart
import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class LoadMapMarkers extends MapEvent {
  final String userId;

  const LoadMapMarkers({required this.userId});

  @override
  List<Object?> get props => [userId];
}
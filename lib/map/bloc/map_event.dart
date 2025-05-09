import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

class LoadMapMarkers extends MapEvent {
  final String userEmail; // Use userEmail instead of userId

  const LoadMapMarkers({required this.userEmail});

  @override
  List<Object?> get props => [userEmail];
}
import 'package:equatable/equatable.dart';
import '../../journal/data/journal_model.dart';

abstract class MapState extends Equatable {
  const MapState();
}

class MapInitial extends MapState {
  @override
  List<Object?> get props => [];
}

class MapLoading extends MapState {
  @override
  List<Object?> get props => [];
}

class MapReady extends MapState {
  final List<TravelJournal> markers;

  const MapReady(this.markers);

  @override
  List<Object?> get props => [markers];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}
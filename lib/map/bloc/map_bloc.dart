import 'package:flutter_bloc/flutter_bloc.dart';
import '../../map/bloc/map_event.dart';
import '../../map/bloc/map_state.dart';
import '../../map/data/map_service.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapService mapService;

  MapBloc({required this.mapService}) : super(MapInitial()) {
    on<LoadMapMarkers>((event, emit) async {
      emit(MapLoading());
      try {
        final journals = await mapService.getVisitedJournalsWithLocation(event.userId).first;
        emit(MapReady(journals));
      } catch (e) {
        emit(MapError(e.toString()));
      }
    });
  }
}
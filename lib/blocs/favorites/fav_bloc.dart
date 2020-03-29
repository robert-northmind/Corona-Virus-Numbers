import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'fav_event.dart';
import 'fav_state.dart';

class FavBloc extends HydratedBloc<FavEvent, FavState> {
  @override
  FavState get initialState {
    return super.initialState ?? FavState(favCountries: []);
  }

  @override
  Stream<FavState> mapEventToState(FavEvent event) async* {
    List<String> favCountries = List<String>.from(state.favCountries);
    final isAlreadyFav = state.favCountries.contains(event.country);
    if (isAlreadyFav) {
      favCountries.remove(event.country);
    } else {
      favCountries.add(event.country);
    }

    yield FavState(favCountries: favCountries);
  }

  @override
  FavState fromJson(Map<String, dynamic> source) {
    try {
      return FavState.fromJson(json: source);
    } catch (_) {
      return FavState(favCountries: []);
    }
  }

  @override
  Map<String, dynamic> toJson(FavState state) {
    try {
      return state.toJson();
    } catch (_) {
      return {};
    }
  }
}

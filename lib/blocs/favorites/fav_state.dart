import 'package:equatable/equatable.dart';

class FavState extends Equatable {
  final List<String> favCountries;
  FavState({this.favCountries});

  Map<String, dynamic> toJson() {
    return {'Favs': favCountries};
  }

  factory FavState.fromJson({Map<String, dynamic> json}) {
    final favCountriesJson = json['Favs'] as List<dynamic>;
    List<String> favCountries = [];
    favCountriesJson.forEach((favJson) {
      favCountries.add(favJson as String);
    });
    return FavState(favCountries: favCountries);
  }

  @override
  List<Object> get props => [favCountries];
}

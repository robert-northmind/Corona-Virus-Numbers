import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

enum GraphHistoryTimeType { lastSevenDays, allTime }

class GraphHistoryEvent {
  final GraphHistoryTimeType graphHistoryTimeType;
  GraphHistoryEvent({this.graphHistoryTimeType});
}

class GraphHistoryState extends Equatable {
  final GraphHistoryTimeType graphHistoryTimeType;
  GraphHistoryState({this.graphHistoryTimeType});

  Map<String, dynamic> toJson() {
    int enumValue = 0;
    switch (graphHistoryTimeType) {
      case GraphHistoryTimeType.allTime:
        enumValue = 0;
        break;
      case GraphHistoryTimeType.lastSevenDays:
        enumValue = 1;
        break;
    }
    return {'GraphHistoryTimeType': enumValue};
  }

  factory GraphHistoryState.fromJson({Map<String, dynamic> json}) {
    final enumValue = json['GraphHistoryTimeType'] as int;
    GraphHistoryTimeType graphHistoryTimeType;
    if (enumValue == 0) {
      graphHistoryTimeType = GraphHistoryTimeType.allTime;
    } else {
      graphHistoryTimeType = GraphHistoryTimeType.lastSevenDays;
    }
    return GraphHistoryState(graphHistoryTimeType: graphHistoryTimeType);
  }

  @override
  List<Object> get props => [graphHistoryTimeType];
}

class GraphHistoryBloc
    extends HydratedBloc<GraphHistoryEvent, GraphHistoryState> {
  @override
  GraphHistoryState get initialState {
    return super.initialState ??
        GraphHistoryState(graphHistoryTimeType: GraphHistoryTimeType.allTime);
  }

  @override
  GraphHistoryState fromJson(Map<String, dynamic> source) {
    try {
      return GraphHistoryState.fromJson(json: source);
    } catch (_) {
      return GraphHistoryState(
          graphHistoryTimeType: GraphHistoryTimeType.allTime);
    }
  }

  @override
  Stream<GraphHistoryState> mapEventToState(GraphHistoryEvent event) async* {
    yield GraphHistoryState(graphHistoryTimeType: event.graphHistoryTimeType);
  }

  @override
  Map<String, dynamic> toJson(GraphHistoryState state) {
    try {
      return state.toJson();
    } catch (_) {
      return {};
    }
  }
}

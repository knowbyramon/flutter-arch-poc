import 'package:knowby_api/knowby_api.dart';

sealed class KnowbyEvent {}

class KnowbyStarted extends KnowbyEvent {
  KnowbyStarted(this.knowby);

  final Knowby? knowby;
}

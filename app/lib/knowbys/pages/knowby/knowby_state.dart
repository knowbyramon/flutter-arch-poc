import 'package:knowby_api/knowby_api.dart';

sealed class KnowbyState {}

class KnowbyInitial extends KnowbyState {}

class KnowbyLoading extends KnowbyState {}

class KnowbySuccess extends KnowbyState {
  KnowbySuccess(this.knowby);

  final Knowby knowby;
}

class KnowbyFailure extends KnowbyState {
  KnowbyFailure(this.error);

  final String error;
}

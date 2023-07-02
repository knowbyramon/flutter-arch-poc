import 'package:knowby_api/knowby_api.dart';

sealed class KnowbysState {}

class KnowbysInitial extends KnowbysState {}

class KnowbysLoading extends KnowbysState {}

class KnowbysSuccess extends KnowbysState {
  KnowbysSuccess(this.knowbys);

  final List<Knowby> knowbys;
}

class KnowbysFailure extends KnowbysState {
  KnowbysFailure(this.error);

  final String error;
}

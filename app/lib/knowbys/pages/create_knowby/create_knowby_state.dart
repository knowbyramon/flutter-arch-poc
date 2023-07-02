sealed class CreateKnowbyState {}

class CreateKnowbyInitial extends CreateKnowbyState {}

class CreateKnowbyLoading extends CreateKnowbyState {}

class CreateKnowbySuccess extends CreateKnowbyState {}

class CreateKnowbyLeaving extends CreateKnowbyState {}

class CreateKnowbyFailure extends CreateKnowbyState {
  CreateKnowbyFailure(this.error);

  final String error;
}

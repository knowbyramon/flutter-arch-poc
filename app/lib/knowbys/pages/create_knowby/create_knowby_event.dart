sealed class CreateKnowbyEvent {}

class CreateKnowbyStarted extends CreateKnowbyEvent {}

class CreateKnowbySubmitted extends CreateKnowbyEvent {
  CreateKnowbySubmitted(this.name);

  final String name;
}

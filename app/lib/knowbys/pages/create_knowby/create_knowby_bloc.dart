import 'package:app/knowbys/pages/create_knowby/create_knowby_event.dart';
import 'package:app/knowbys/pages/create_knowby/create_knowby_state.dart';
import 'package:app/knowbys/repositories/knowbys_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowby_api/knowby_api.dart';

class CreateKnowbyBloc extends Bloc<CreateKnowbyEvent, CreateKnowbyState> {
  CreateKnowbyBloc(this.knowbysRepository) : super(CreateKnowbyInitial()) {
    on<CreateKnowbyEvent>(
      (event, emit) => switch (event) {
        CreateKnowbyStarted() => _handleStarted(event, emit),
        CreateKnowbySubmitted() => _handleSubmitted(event, emit),
      },
    );
  }

  final KnowbysRepository knowbysRepository;

  Future<void> _handleStarted(
    CreateKnowbyStarted event,
    Emitter<CreateKnowbyState> emit,
  ) async {
    emit(CreateKnowbySuccess());
  }

  Future<void> _handleSubmitted(
    CreateKnowbySubmitted event,
    Emitter<CreateKnowbyState> emit,
  ) async {
    final name = event.name;
    if (name.isEmpty) {
      emit(CreateKnowbyFailure('Name cannot be empty'));
      return;
    }
    emit(CreateKnowbyLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      await knowbysRepository.createKnowby(name);
      emit(CreateKnowbyLeaving());
    } on KnowbyClientException catch (e) {
      emit(CreateKnowbyFailure(e.message));
    }
  }
}

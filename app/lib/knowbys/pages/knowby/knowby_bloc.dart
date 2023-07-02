import 'package:app/knowbys/pages/knowby/knowby_event.dart';
import 'package:app/knowbys/pages/knowby/knowby_state.dart';
import 'package:app/knowbys/repositories/knowbys_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowby_api/knowby_api.dart';

class KnowbyBloc extends Bloc<KnowbyEvent, KnowbyState> {
  KnowbyBloc(this.knowbyId, this.knowbysRepository) : super(KnowbyInitial()) {
    on<KnowbyEvent>(
      (event, emit) => switch (event) {
        KnowbyStarted() => _handleStarted(event, emit),
      },
    );
  }

  final String knowbyId;
  final KnowbysRepository knowbysRepository;

  Future<void> _handleStarted(
    KnowbyStarted event,
    Emitter<KnowbyState> emit,
  ) async {
    final knowby = event.knowby;
    if (knowby != null) {
      emit(KnowbySuccess(knowby));
      return;
    }
    emit(KnowbyLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final knowby = await knowbysRepository.getKnowby(knowbyId);
      emit(KnowbySuccess(knowby));
    } on KnowbyClientException catch (e) {
      emit(KnowbyFailure(e.message));
    }
  }
}

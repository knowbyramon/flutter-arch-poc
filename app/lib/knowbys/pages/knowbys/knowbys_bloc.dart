import 'package:app/knowbys/pages/knowbys/knowbys_event.dart';
import 'package:app/knowbys/pages/knowbys/knowbys_state.dart';
import 'package:app/knowbys/repositories/knowbys_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowby_api/knowby_api.dart';

class KnowbysBloc extends Bloc<KnowbysEvent, KnowbysState> {
  KnowbysBloc(this.knowbysRepository) : super(KnowbysInitial()) {
    on<KnowbysEvent>(
      (event, emit) => switch (event) {
        KnowbysStarted() => _handleStarted(event, emit),
      },
    );
  }

  final KnowbysRepository knowbysRepository;

  Future<void> _handleStarted(
    KnowbysStarted event,
    Emitter<KnowbysState> emit,
  ) async {
    emit(KnowbysLoading());
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final knowbys = await knowbysRepository.getKnowbys();
      emit(KnowbysSuccess(knowbys));
    } on KnowbyClientException catch (e) {
      emit(KnowbysFailure(e.message));
    }
  }
}

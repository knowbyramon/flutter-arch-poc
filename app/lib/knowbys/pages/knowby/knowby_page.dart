import 'package:app/knowbys/pages/knowby/knowby_bloc.dart';
import 'package:app/knowbys/pages/knowby/knowby_event.dart';
import 'package:app/knowbys/pages/knowby/knowby_state.dart';
import 'package:app/knowbys/repositories/knowbys_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowby_api/knowby_api.dart';

class KnowbyPage extends StatelessWidget {
  const KnowbyPage({super.key, required this.knowbyId, this.knowby});

  final String knowbyId;
  final Knowby? knowby;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          KnowbyBloc(knowbyId, context.read<KnowbysRepository>())
            ..add(KnowbyStarted(knowby)),
      child: const KnowbyView(),
    );
  }
}

class KnowbyView extends StatelessWidget {
  const KnowbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KnowbyBloc, KnowbyState>(
      builder: (context, state) => switch (state) {
        KnowbyInitial() => _buildInitial(context, state),
        KnowbyLoading() => _buildLoading(context, state),
        KnowbySuccess() => _buildSuccess(context, state),
        KnowbyFailure() => _buildFailure(context, state),
      },
    );
  }

  Widget _buildInitial(BuildContext context, KnowbyInitial state) {
    return Scaffold(appBar: AppBar());
  }

  Widget _buildLoading(BuildContext context, KnowbyLoading state) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSuccess(BuildContext context, KnowbySuccess state) {
    final knowby = state.knowby;
    return Scaffold(
      appBar: AppBar(title: Text(knowby.name)),
      body: ListView(),
    );
  }

  Widget _buildFailure(BuildContext context, KnowbyFailure state) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(state.error)),
    );
  }
}

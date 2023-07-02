import 'package:app/knowbys/pages/knowbys/knowbys_bloc.dart';
import 'package:app/knowbys/pages/knowbys/knowbys_event.dart';
import 'package:app/knowbys/pages/knowbys/knowbys_state.dart';
import 'package:app/knowbys/repositories/knowbys_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:knowby_api/knowby_api.dart';

class KnowbysPage extends StatelessWidget {
  const KnowbysPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          KnowbysBloc(context.read<KnowbysRepository>())..add(KnowbysStarted()),
      child: const KnowbysView(),
    );
  }
}

class KnowbysView extends StatelessWidget {
  const KnowbysView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Knowbys')),
      body: BlocBuilder<KnowbysBloc, KnowbysState>(
        builder: (context, state) => switch (state) {
          KnowbysInitial() => _buildInitial(context, state),
          KnowbysLoading() => _buildLoading(context, state),
          KnowbysSuccess() => _buildSuccess(context, state),
          KnowbysFailure() => _buildFailure(context, state),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bloc = context.read<KnowbysBloc>();
          await context.pushNamed('CreateKnowby');
          bloc.add(KnowbysStarted());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInitial(BuildContext context, KnowbysInitial state) {
    return const SizedBox();
  }

  Widget _buildLoading(BuildContext context, KnowbysLoading state) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildSuccess(BuildContext context, KnowbysSuccess state) {
    final knowbys = state.knowbys;
    return ListView.separated(
      padding: MediaQuery.of(context).padding.add(const EdgeInsets.all(24)),
      itemBuilder: (context, index) => _buildKnowby(context, knowbys[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemCount: knowbys.length,
    );
  }

  Widget _buildKnowby(BuildContext context, Knowby knowby) {
    final createdAt = knowby.createdAt.toString();
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: Text(knowby.name),
        subtitle: Text(createdAt.substring(0, createdAt.lastIndexOf(':'))),
        onTap: () => context.goNamed(
          'Knowby',
          pathParameters: {'knowbyId': knowby.id},
          extra: knowby,
        ),
      ),
    );
  }

  Widget _buildFailure(BuildContext context, KnowbysFailure state) {
    return Center(child: Text(state.error));
  }
}

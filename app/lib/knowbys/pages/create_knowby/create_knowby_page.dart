import 'package:app/knowbys/pages/create_knowby/create_knowby_bloc.dart';
import 'package:app/knowbys/pages/create_knowby/create_knowby_event.dart';
import 'package:app/knowbys/pages/create_knowby/create_knowby_state.dart';
import 'package:app/knowbys/repositories/knowbys_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateKnowbyPage extends StatelessWidget {
  const CreateKnowbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateKnowbyBloc(context.read<KnowbysRepository>())
        ..add(CreateKnowbyStarted()),
      child: const CreateKnowbyView(),
    );
  }
}

class CreateKnowbyView extends StatefulWidget {
  const CreateKnowbyView({super.key});

  @override
  State<CreateKnowbyView> createState() => _CreateKnowbyViewState();
}

class _CreateKnowbyViewState extends State<CreateKnowbyView> {
  var _name = '';

  void _handleStateChanged(BuildContext context, CreateKnowbyState state) {
    if (state is CreateKnowbyLeaving) {
      context.pop();
    } else if (state is CreateKnowbyFailure) {
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(state.error),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Knowby')),
      body: BlocConsumer<CreateKnowbyBloc, CreateKnowbyState>(
        listener: _handleStateChanged,
        builder: (context, state) => state is CreateKnowbyLoading
            ? _buildLoading(context, state)
            : _buildForm(context),
      ),
    );
  }

  Widget _buildLoading(BuildContext context, CreateKnowbyLoading state) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildForm(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: MediaQuery.of(context)
            .padding
            .copyWith(bottom: 0)
            .add(const EdgeInsets.all(24)),
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Name'),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) => _name = value,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          onPressed: () => context
              .read<CreateKnowbyBloc>()
              .add(CreateKnowbySubmitted(_name)),
          child: const Text('CREATE'),
        ),
      ),
    );
  }
}

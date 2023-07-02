import 'package:app/knowbys/pages/create_knowby/create_knowby_page.dart';
import 'package:app/knowbys/pages/knowby/knowby_page.dart';
import 'package:app/knowbys/pages/knowbys/knowbys_page.dart';
import 'package:app/knowbys/repositories/knowbys_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:knowby_api/knowby_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  App({super.key, required this.apiClient, required this.preferences});

  final KnowbyApiClient apiClient;
  final SharedPreferences preferences;

  final _router = GoRouter(
    routes: [
      GoRoute(
        name: 'Home',
        path: '/',
        redirect: (context, state) => state.namedLocation('Knowbys'),
      ),
      GoRoute(
        name: 'Knowbys',
        path: '/knowbys',
        builder: (context, state) => const KnowbysPage(),
        routes: [
          GoRoute(
            name: 'CreateKnowby',
            path: 'create',
            builder: (context, state) => const CreateKnowbyPage(),
          ),
          GoRoute(
            name: 'Knowby',
            path: ':knowbyId',
            builder: (context, state) => KnowbyPage(
              knowbyId: state.pathParameters['knowbyId']!,
              knowby: state.extra as Knowby?,
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => KnowbysRepository(apiClient, preferences),
        )
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          inputDecorationTheme: const InputDecorationTheme(filled: true),
        ),
        routerConfig: _router,
      ),
    );
  }
}

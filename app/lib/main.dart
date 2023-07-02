import 'dart:developer';

import 'package:app/app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowby_api/knowby_api.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _apiHost = String.fromEnvironment(
  'API_HOST',
  defaultValue: 'http://localhost:8080',
);

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (record) => log(
      '${record.time}: ${record.level.name}: ${record.message}',
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    ),
  );
  Bloc.observer = LoggingBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = KnowbyApiClient(_apiHost);
  final preferences = await SharedPreferences.getInstance();
  runApp(App(apiClient: apiClient, preferences: preferences));
}

class LoggingBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    Logger('${bloc.runtimeType}').info('${event.runtimeType}');
  }
}

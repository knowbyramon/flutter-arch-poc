import 'dart:developer';
import 'dart:io';

import 'package:api/controllers/knowbys_controller.dart';
import 'package:api/repositories/knowbys_repository.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

final _log = Logger('Server');

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
  final pipeline = const Pipeline().addMiddleware(logRequests(logger: _logger));
  final knowbysRepository = KnowbysRepository();
  final knowbysController = KnowbysController(knowbysRepository);
  final router = Router()..mount('/knowbys', knowbysController.router.call);
  final handler = pipeline.addHandler(router.call);
  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  _log.info('listening on port ${server.port}');
}

void _logger(String message, bool isError) =>
    _log.log(isError ? Level.SEVERE : Level.INFO, message);

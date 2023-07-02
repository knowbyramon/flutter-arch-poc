import 'dart:convert';

import 'package:api/repositories/knowbys_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class KnowbysController {
  KnowbysController(this.knowbyRepository);

  final KnowbysRepository knowbyRepository;

  Router get router => Router()
    ..post('/', _createKnowby)
    ..get('/', _getKnowbys)
    ..get('/<id>', _getKnowby)
    ..put('/<id>', _updateKnowby)
    ..delete('/<id>', _deleteKnowby);

  Future<Response> _createKnowby(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    final name = json['name'] as String?;
    if (name == null || name.isEmpty) {
      return Response.badRequest(body: 'Name cannot be empty');
    }
    final knowby = await knowbyRepository.createKnowby(name);
    return Response.ok(jsonEncode(knowby));
  }

  Future<Response> _getKnowbys(Request request) async {
    final knowbys = await knowbyRepository.getKnowbys();
    return Response.ok(jsonEncode(knowbys));
  }

  Future<Response> _getKnowby(Request request, String id) async {
    final knowby = await knowbyRepository.getKnowby(id);
    if (knowby == null) {
      return Response.notFound('Could not find Knowby with matching ID');
    }
    return Response.ok(jsonEncode(knowby));
  }

  Future<Response> _updateKnowby(Request request, String id) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    final name = json['name'] as String?;
    if (name != null && name.isEmpty) {
      return Response.badRequest(body: 'Name cannot be empty');
    }
    final knowby = await knowbyRepository.updateKnowby(id, name: name);
    if (knowby == null) {
      return Response.notFound('Could not find Knowby with matching ID');
    }
    return Response.ok(jsonEncode(knowby));
  }

  Future<Response> _deleteKnowby(Request request, String id) async {
    final knowby = await knowbyRepository.deleteKnowby(id);
    if (knowby == null) {
      return Response.notFound('Could not find Knowby with matching ID');
    }
    return Response.ok(jsonEncode(knowby));
  }
}

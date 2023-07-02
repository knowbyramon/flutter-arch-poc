import 'package:api/uuid.dart';
import 'package:knowby_api/knowby_api.dart';

class KnowbysRepository {
  KnowbysRepository() {
    createKnowby('Test Knowby 1');
    createKnowby('Test Knowby 2');
    createKnowby('Test Knowby 3');
  }

  final _knowbys = <String, Knowby>{};

  Future<Knowby> createKnowby(String name) async {
    final now = DateTime.now();
    final knowby = Knowby(
      id: uuid.v4(),
      createdAt: now,
      updatedAt: now,
      name: name,
    );
    return _knowbys[knowby.id] = knowby;
  }

  Future<List<Knowby>> getKnowbys() async {
    return _knowbys.values.toList();
  }

  Future<Knowby?> getKnowby(String id) async {
    return _knowbys[id];
  }

  Future<Knowby?> updateKnowby(String id, {String? name}) async {
    var knowby = _knowbys[id];
    if (knowby == null) {
      return null;
    }
    if (name != null) {
      knowby = knowby.copyWith(name: name);
    }
    return _knowbys[id] = knowby;
  }

  Future<Knowby?> deleteKnowby(String id) async {
    return _knowbys.remove(id);
  }
}

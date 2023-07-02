import 'dart:convert';

import 'package:knowby_api/knowby_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KnowbysRepository {
  KnowbysRepository(this.apiClient, this.preferences);

  final KnowbyApiClient apiClient;
  final SharedPreferences preferences;

  Future<Knowby> createKnowby(String name) async {
    final knowby = await apiClient.createKnowby(name);
    await _writeKnowby(knowby);
    return knowby;
  }

  Future<List<Knowby>> getKnowbys() async {
    final knowbys = await apiClient.getKnowbys();
    for (final knowby in knowbys) {
      await _writeKnowby(knowby);
    }
    return knowbys;
  }

  Future<Knowby> getKnowby(String id) async {
    final cacheResult = _readKnowby(id);
    if (cacheResult != null &&
        DateTime.now().difference(cacheResult.cachedAt).inMinutes < 1) {
      return cacheResult.knowby;
    }
    final Knowby knowby;
    try {
      knowby = await apiClient.getKnowby(id);
    } on KnowbyNotFoundException {
      await _clearKnowby(id);
      rethrow;
    }
    await _writeKnowby(knowby);
    return knowby;
  }

  Future<Knowby> updateKnowby(String id, {String? name}) async {
    final updatedKnowby = await apiClient.updateKnowby(id, name: name);
    await _writeKnowby(updatedKnowby);
    return updatedKnowby;
  }

  Future<Knowby> deleteKnowby(String id) async {
    final knowby = await apiClient.deleteKnowby(id);
    await _clearKnowby(id);
    return knowby;
  }

  Future<void> _writeKnowby(Knowby knowby) async {
    final cachedAt = DateTime.now().toIso8601String();
    await preferences.setString(
      'knowby_${knowby.id}',
      jsonEncode({'cachedAt': cachedAt, 'knowby': knowby.toJson()}),
    );
  }

  ({DateTime cachedAt, Knowby knowby})? _readKnowby(String id) {
    final data = preferences.getString('knowby_$id');
    if (data == null) {
      return null;
    }
    final json = jsonDecode(data) as Map<String, dynamic>;
    final cachedAt = DateTime.parse(json['cachedAt'] as String);
    final knowby = Knowby.fromJson(json['knowby'] as Map<String, dynamic>);
    return (cachedAt: cachedAt, knowby: knowby);
  }

  Future<void> _clearKnowby(String id) => preferences.remove('knowby_$id');
}

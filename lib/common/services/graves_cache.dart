import "dart:async";
import "dart:convert";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../features/grave/data/models/grave.dart";

const _gravesCacheKey = "_graves_cache__";
const _graveCacheKey = "_grave_cache__";

class GravesCache {
  const GravesCache(this._prefs);
  final SharedPreferences _prefs;

  static Future<GravesCache> open() async => GravesCache(await SharedPreferences.getInstance());

  Future<void> saveAll(IList<Grave> graves) async {
    await _prefs.setStringList(_gravesCacheKey, graves.map(_encode).toList());
  }

  Future<void> save(Grave grave) => _prefs.setString("$_graveCacheKey${grave.id}", _encode(grave));

  IList<Grave>? readAll() {
    final cached = _prefs.getStringList(_gravesCacheKey);
    if (cached == null || cached.isEmpty) return null;
    return cached.map(_decode).toIList();
  }

  Grave? read(String graveId) {
    final cached = _prefs.getString("$_graveCacheKey$graveId");
    if (cached != null) return _decode(cached);
    return readAll()?.where((g) => g.id == graveId).firstOrNull;
  }

  static String _encode(Grave grave) => jsonEncode(grave.toJson());

  static Grave _decode(String json) => Grave.fromJson(jsonDecode(json) as Map<String, dynamic>);
}

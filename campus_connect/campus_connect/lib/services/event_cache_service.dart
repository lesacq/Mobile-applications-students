import 'package:hive/hive.dart';
import '../models/event.dart';

class EventCacheService {
  static const String boxName = 'eventsBox';

  Future<void> cacheEvents(List<Event> events) async {
    final box = await Hive.openBox(boxName);
    await box.put('events', events.map((e) => e.toMap()).toList());
  }

  Future<List<Event>> getCachedEvents() async {
    final box = await Hive.openBox(boxName);
    final cached = box.get('events') as List?;
    if (cached == null) return [];
    return cached.map((e) => Event.fromMap(e['id'], Map<String, dynamic>.from(e))).toList();
  }
}

import 'package:flutter/material.dart';
import '../services/event_service.dart';
import '../models/event.dart';
import '../services/event_cache_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class EventViewModel extends ChangeNotifier {
  final EventCacheService _cacheService = EventCacheService();

    Future<void> deleteEvent(String eventId) async {
      try {
        await _eventService.deleteEvent(eventId);
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }

    Future<void> updateEvent(Event event) async {
      try {
        await _eventService.updateEvent(event);
      } catch (e) {
        _errorMessage = e.toString();
        notifyListeners();
      }
    }
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _isLoading = true;
  String? _errorMessage;


  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;


  void listenToEvents() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      // Offline: load from cache
      _events = await _cacheService.getCachedEvents();
      _isLoading = false;
      _errorMessage = 'Offline: showing cached events.';
      notifyListeners();
      return;
    }
    _eventService.getEvents().listen((eventList) async {
      _events = eventList;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      // Cache events for offline use
      await _cacheService.cacheEvents(eventList);
    }, onError: (error) {
      _isLoading = false;
      _errorMessage = error.toString();
      notifyListeners();
    });
  }


  Future<void> addEvent(Event event) async {
    try {
      await _eventService.addEvent(event);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }


  Future<void> toggleLike(String eventId, String userId) async {
    await _eventService.toggleLike(eventId, userId);
    // The stream will automatically update the list
  }


  Future<void> addComment(String eventId, Comment comment) async {
    await _eventService.addComment(eventId, comment);
  }
}

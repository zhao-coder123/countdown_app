import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/countdown_model.dart';
import '../services/database_service.dart';

class CountdownProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<CountdownModel> _countdowns = [];
  List<CountdownModel> _filteredCountdowns = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedEventType = 'all';
  Timer? _updateTimer;
  DateTime _lastUpdate = DateTime.now();

  List<CountdownModel> get countdowns => _filteredCountdowns;
  List<CountdownModel> get allCountdowns => _countdowns;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedEventType => _selectedEventType;

  CountdownProvider() {
    _initializeData();
    _startPeriodicUpdate();
  }

  Future<void> _initializeData() async {
    await loadCountdowns();
  }

  void _startPeriodicUpdate() {
    _updateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      if (now.minute != _lastUpdate.minute && _countdowns.isNotEmpty) {
        _lastUpdate = now;
        notifyListeners();
      }
    });
  }

  void requestRealTimeUpdate() {
    notifyListeners();
  }

  Future<void> loadCountdowns() async {
    _isLoading = true;
    notifyListeners();

    try {
      _countdowns = await _databaseService.getActiveCountdowns();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading countdowns: $e');
      _countdowns = [];
      _filteredCountdowns = [];
      rethrow; // 重新抛出异常，让调用方处理
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCountdown(CountdownModel countdown) async {
    try {
      final id = await _databaseService.insertCountdown(countdown);
      final newCountdown = countdown.copyWith(id: id);
      _countdowns.add(newCountdown);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding countdown: $e');
      rethrow;
    }
  }

  Future<void> updateCountdown(CountdownModel countdown) async {
    try {
      await _databaseService.updateCountdown(countdown);
      final index = _countdowns.indexWhere((c) => c.id == countdown.id);
      if (index != -1) {
        _countdowns[index] = countdown;
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating countdown: $e');
      rethrow;
    }
  }

  Future<void> deleteCountdown(int id) async {
    try {
      await _databaseService.deleteCountdown(id);
      _countdowns.removeWhere((c) => c.id == id);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting countdown: $e');
      rethrow;
    }
  }

  Future<void> archiveCountdown(int id) async {
    try {
      await _databaseService.archiveCountdown(id);
      _countdowns.removeWhere((c) => c.id == id);
      _applyFilters();
      notifyListeners();
    } catch (e) {
      debugPrint('Error archiving countdown: $e');
      rethrow;
    }
  }

  Future<void> markAsCompleted(int id) async {
    try {
      await _databaseService.markAsCompleted(id);
      final index = _countdowns.indexWhere((c) => c.id == id);
      if (index != -1) {
        _countdowns[index] = _countdowns[index].copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking countdown as completed: $e');
      rethrow;
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setEventTypeFilter(String eventType) {
    _selectedEventType = eventType;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<CountdownModel> filtered = List.from(_countdowns);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((countdown) {
        return countdown.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               countdown.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedEventType != 'all') {
      filtered = filtered.where((countdown) {
        return countdown.eventType == _selectedEventType;
      }).toList();
    }

    filtered.sort((a, b) => a.targetDate.compareTo(b.targetDate));

    _filteredCountdowns = filtered;
  }

  List<CountdownModel> getUpcomingCountdowns({int limit = 3}) {
    final now = DateTime.now();
    return _countdowns
        .where((countdown) => countdown.targetDate.isAfter(now))
        .take(limit)
        .toList();
  }

  List<CountdownModel> getExpiredCountdowns() {
    final now = DateTime.now();
    return _countdowns
        .where((countdown) => countdown.targetDate.isBefore(now))
        .toList();
  }

  List<CountdownModel> getCountdownsByType(String eventType) {
    return _countdowns
        .where((countdown) => countdown.eventType == eventType)
        .toList();
  }

  CountdownModel? getCountdownById(int id) {
    try {
      return _countdowns.firstWhere((countdown) => countdown.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, int> getStatistics() {
    final now = DateTime.now();
    final upcoming = _countdowns.where((c) => c.targetDate.isAfter(now)).length;
    final expired = _countdowns.where((c) => c.targetDate.isBefore(now)).length;
    final completed = _countdowns.where((c) => c.isCompleted).length;
    
    return {
      'total': _countdowns.length,
      'upcoming': upcoming,
      'expired': expired,
      'completed': completed,
    };
  }

  CountdownModel? getNextCountdown() {
    final now = DateTime.now();
    final upcomingCountdowns = _countdowns
        .where((countdown) => countdown.targetDate.isAfter(now))
        .toList();
    
    if (upcomingCountdowns.isEmpty) return null;
    
    upcomingCountdowns.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    return upcomingCountdowns.first;
  }

  CountdownModel createNewCountdown({
    required String title,
    required DateTime date,
    String? description,
    String eventType = 'custom',
    String colorTheme = 'gradient1',
    String iconName = 'event',
  }) {
    return CountdownModel(
      title: title,
      description: description ?? '',
      targetDate: date,
      eventType: eventType,
      colorTheme: colorTheme,
      iconName: iconName,
      createdAt: DateTime.now(),
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
} 
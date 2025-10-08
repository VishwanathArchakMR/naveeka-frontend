// lib/core/storage/seed_data_loader.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

/// Singleton class for loading and managing seed data
class SeedDataLoader {
  static final SeedDataLoader _instance = SeedDataLoader._internal();
  factory SeedDataLoader() => _instance;
  SeedDataLoader._internal();

  static SeedDataLoader get instance => _instance;

  bool _isLoaded = false;
  Map<String, dynamic> _homeData = {};
  Map<String, dynamic> _trailsData = {};
  Map<String, dynamic> _atlasData = {};
  Map<String, dynamic> _journeyData = {};
  Map<String, dynamic> _naveeAIData = {};
  Map<String, dynamic> _placesData = {};
  Map<String, dynamic> _bookingData = {};
  Map<String, dynamic> _historyData = {};
  Map<String, dynamic> _favoritesData = {};
  Map<String, dynamic> _followingData = {};
  Map<String, dynamic> _planningData = {};
  Map<String, dynamic> _messagesData = {};
  Map<String, dynamic> _hotelsData = {};
  Map<String, dynamic> _restaurantsData = {};
  Map<String, dynamic> _flightsData = {};
  Map<String, dynamic> _trainsData = {};
  Map<String, dynamic> _busesData = {};
  Map<String, dynamic> _activitiesData = {};

  bool get isLoaded => _isLoaded;

  // Getters for all data
  Map<String, dynamic> get homeData => _homeData;
  Map<String, dynamic> get trailsData => _trailsData;
  Map<String, dynamic> get atlasData => _atlasData;
  Map<String, dynamic> get journeyData => _journeyData;
  Map<String, dynamic> get naveeAIData => _naveeAIData;
  Map<String, dynamic> get placesData => _placesData;
  Map<String, dynamic> get bookingData => _bookingData;
  Map<String, dynamic> get historyData => _historyData;
  Map<String, dynamic> get favoritesData => _favoritesData;
  Map<String, dynamic> get followingData => _followingData;
  Map<String, dynamic> get planningData => _planningData;
  Map<String, dynamic> get messagesData => _messagesData;
  Map<String, dynamic> get hotelsData => _hotelsData;
  Map<String, dynamic> get restaurantsData => _restaurantsData;
  Map<String, dynamic> get flightsData => _flightsData;
  Map<String, dynamic> get trainsData => _trainsData;
  Map<String, dynamic> get busesData => _busesData;
  Map<String, dynamic> get activitiesData => _activitiesData;

  /// Load all seed data from assets
  Future<void> loadAllSeedData() async {
    if (_isLoaded) return;

    try {
      _homeData = await _loadJsonAsset('assets/seed-data/home_seed.json');
      _trailsData = await _loadJsonAsset('assets/seed-data/trail_seed.json');
      _atlasData = await _loadJsonAsset('assets/seed-data/atlas_seed.json');
      _journeyData = await _loadJsonAsset('assets/seed-data/journey_seed.json');
      _naveeAIData = await _loadJsonAsset('assets/seed-data/navee_ai_seed.json');
      _placesData = await _loadJsonAsset('assets/seed-data/places_seed.json');
      _bookingData = await _loadJsonAsset('assets/seed-data/booking_seed.json');
      _historyData = await _loadJsonAsset('assets/seed-data/history_seed.json');
      _favoritesData = await _loadJsonAsset('assets/seed-data/favorites_seed.json');
      _followingData = await _loadJsonAsset('assets/seed-data/following_seed.json');
      _planningData = await _loadJsonAsset('assets/seed-data/planning_seed.json');
      _messagesData = await _loadJsonAsset('assets/seed-data/messages_seed.json');
      _hotelsData = await _loadJsonAsset('assets/seed-data/hotels_seed.json');
      _restaurantsData = await _loadJsonAsset('assets/seed-data/restaurants_seed.json');
      _flightsData = await _loadJsonAsset('assets/seed-data/flights_seed.json');
      _trainsData = await _loadJsonAsset('assets/seed-data/trains_seed.json');
      _busesData = await _loadJsonAsset('assets/seed-data/buses_seed.json');
      _activitiesData = await _loadJsonAsset('assets/seed-data/activities_seed.json');

      _isLoaded = true;
      if (kDebugMode) {
        print('✅ All seed data loaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading seed data: $e');
      }
      rethrow;
    }
  }

  /// Reload all seed data
  Future<void> reload() async {
    _isLoaded = false;
    await loadAllSeedData();
  }

  /// Load specific atlas data
  Future<Map<String, dynamic>> loadAtlasData() async {
    if (!_isLoaded) {
      await loadAllSeedData();
    }
    return _atlasData;
  }

  /// Load JSON asset from file system
  Future<Map<String, dynamic>> _loadJsonAsset(String assetPath) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading asset $assetPath: $e');
      }
      return {};
    }
  }
}

/// Provider for SeedDataLoader instance
final seedDataLoaderProvider = Provider<SeedDataLoader>((ref) {
  return SeedDataLoader.instance;
});

/// Home data provider
final homeDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.homeData;
});

final trailsDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.trailsData;
});

final atlasDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  // Prefer the new direct loader to enable remote override when configured
  return await loader.loadAtlasData();
});

final journeyDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.journeyData;
});

final naveeAIDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.naveeAIData;
});

final placesDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.placesData;
});

final bookingDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.bookingData;
});

final historyDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.historyData;
});

final favoritesDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.favoritesData;
});

final followingDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.followingData;
});

final planningDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.planningData;
});

final messagesDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.messagesData;
});

final hotelsDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.hotelsData;
});

final restaurantsDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.restaurantsData;
});

final flightsDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.flightsData;
});

final trainsDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.trainsData;
});

final busesDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.busesData;
});

final activitiesDataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final loader = ref.watch(seedDataLoaderProvider);
  if (!loader.isLoaded) {
    await loader.loadAllSeedData();
  }
  return loader.activitiesData;
});
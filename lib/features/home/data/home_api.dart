// lib/features/home/data/home_api.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/network/api_result.dart';
import '../../../core/config/constants.dart';
import '../../../core/storage/seed_data_loader.dart';

/// Location-aware data source for the Home screen sections with seed data fallback. [2]
class HomeApi {
  HomeApi() : _dio = DioClient.instance.dio;
  final Dio _dio;

  /// Nearby places using lat/lng and optional radiusKm (km). [2]
  Future<ApiResult<List<Map<String, dynamic>>>> nearbyPlaces({
    required double lat,
    required double lng,
    double radiusKm = AppConstants.defaultNearbyRadiusKm,
    int limit = AppConstants.pageSize,
    List<String>? categories,
  }) {
    return ApiResult.guardFuture(() async {
      try {
        final qp = <String, dynamic>{
          'lat': lat,
          'lng': lng,
          'radius_km': radiusKm,
          'limit': limit,
          if (categories != null && categories.isNotEmpty) 'categories': categories.join(','),
        };
        final res = await _dio.get(AppConstants.apiPlaces, queryParameters: qp);
        final data = _asList(res.data);
        return data;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ nearbyPlaces API failed, using seed data: $e');
        }
        // Fallback to seed data
        return _getPlacesFromSeed(limit: limit, categories: categories);
      }
    });
  } // [2][4]

  /// Nearby hotels with the same geo filter semantics. [2]
  Future<ApiResult<List<Map<String, dynamic>>>> nearbyHotels({
    required double lat,
    required double lng,
    double radiusKm = AppConstants.defaultNearbyRadiusKm,
    int limit = AppConstants.pageSize,
  }) {
    return ApiResult.guardFuture(() async {
      try {
        final qp = <String, dynamic>{
          'lat': lat,
          'lng': lng,
          'radius_km': radiusKm,
          'limit': limit,
        };
        final res = await _dio.get(AppConstants.apiHotels, queryParameters: qp);
        final data = _asList(res.data);
        return data;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ nearbyHotels API failed, using seed data: $e');
        }
        // Fallback to seed data
        return _getHotelsFromSeed(limit: limit);
      }
    });
  } // [2][8]

  /// Nearby restaurants with geo filter. [2]
  Future<ApiResult<List<Map<String, dynamic>>>> nearbyRestaurants({
    required double lat,
    required double lng,
    double radiusKm = AppConstants.defaultNearbyRadiusKm,
    int limit = AppConstants.pageSize,
  }) {
    return ApiResult.guardFuture(() async {
      try {
        final qp = <String, dynamic>{
          'lat': lat,
          'lng': lng,
          'radius_km': radiusKm,
          'limit': limit,
        };
        final res = await _dio.get(AppConstants.apiRestaurants, queryParameters: qp);
        final data = _asList(res.data);
        return data;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ nearbyRestaurants API failed, using seed data: $e');
        }
        // Fallback to seed data
        return _getRestaurantsFromSeed(limit: limit);
      }
    });
  } // [2][1]

  /// Trending places (optionally location-biased if lat/lng provided). [2]
  Future<ApiResult<List<Map<String, dynamic>>>> trendingPlaces({
    double? lat,
    double? lng,
    int limit = AppConstants.pageSize,
  }) {
    return ApiResult.guardFuture(() async {
      try {
        final qp = <String, dynamic>{
          'sort': 'trending',
          'limit': limit,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
        };
        final res = await _dio.get(AppConstants.apiPlaces, queryParameters: qp);
        final data = _asList(res.data);
        return data;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ trendingPlaces API failed, using seed data: $e');
        }
        // Fallback to seed data - return a subset marked as trending
        return _getPlacesFromSeed(limit: limit);
      }
    });
  } // [2][11]

  /// "What's new" feed of recently added places. [2]
  Future<ApiResult<List<Map<String, dynamic>>>> whatsNew({
    int limit = AppConstants.pageSize,
  }) {
    return ApiResult.guardFuture(() async {
      try {
        final qp = <String, dynamic>{
          'sort': 'new',
          'limit': limit,
        };
        final res = await _dio.get(AppConstants.apiPlaces, queryParameters: qp);
        final data = _asList(res.data);
        return data;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ whatsNew API failed, using seed data: $e');
        }
        // Fallback to seed data
        return _getPlacesFromSeed(limit: limit);
      }
    });
  } // [2][8]

  /// Explore by region (e.g., state/country/region code or name). [2]
  Future<ApiResult<List<Map<String, dynamic>>>> exploreByRegion({
    required String region,
    int limit = AppConstants.pageSize,
  }) {
    return ApiResult.guardFuture(() async {
      try {
        final qp = <String, dynamic>{
          'region': region,
          'limit': limit,
        };
        final res = await _dio.get(AppConstants.apiPlaces, queryParameters: qp);
        final data = _asList(res.data);
        return data;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ exploreByRegion API failed, using seed data: $e');
        }
        // Fallback to seed data
        return _getPlacesFromSeed(limit: limit);
      }
    });
  } // [2][4]

  /// Top hotels near a location (sorted by rating or popularity). [2]
  Future<ApiResult<List<Map<String, dynamic>>>> topHotelsNear({
    required double lat,
    required double lng,
    int limit = AppConstants.pageSize,
  }) {
    return ApiResult.guardFuture(() async {
      try {
        final qp = <String, dynamic>{
          'lat': lat,
          'lng': lng,
          'sort': 'rating_desc',
          'limit': limit,
        };
        final res = await _dio.get(AppConstants.apiHotels, queryParameters: qp);
        final data = _asList(res.data);
        return data;
      } catch (e) {
        if (kDebugMode) {
          debugPrint('⚠️ topHotelsNear API failed, using seed data: $e');
        }
        // Fallback to seed data
        return _getHotelsFromSeed(limit: limit);
      }
    });
  } // [2][8]

  // ---------- Helpers ----------
  List<Map<String, dynamic>> _asList(dynamic data) {
    // Accepts either { data: [...] } or plain [...].
    if (data is Map && data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data'] as List);
    }
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    }
    return const <Map<String, dynamic>>[];
  } // Supports common API shapes and avoids crashes on unexpected payloads. [7]

  // ---------- Seed Data Helpers ----------
  List<Map<String, dynamic>> _getPlacesFromSeed({
    int limit = AppConstants.pageSize,
    List<String>? categories,
  }) {
    try {
      final seedData = SeedDataLoader.instance.placesData;
      if (seedData.isEmpty) {
        if (kDebugMode) {
          debugPrint('⚠️ placesData seed is empty');
        }
        return [];
      }
      
      // Extract places array from seed data
      List<dynamic> places = [];
      if (seedData['places'] is List) {
        places = seedData['places'] as List;
      } else if (seedData['data'] is List) {
        places = seedData['data'] as List;
      } else if (seedData is List) {
        places = seedData as List;
      }
      
      // Filter by categories if provided
      if (categories != null && categories.isNotEmpty) {
        places = places.where((p) {
          if (p is! Map) return false;
          final placeCategories = p['categories'];
          if (placeCategories is List) {
            return categories.any((cat) => placeCategories.contains(cat));
          }
          return false;
        }).toList();
      }
      
      // Limit results
      final limitedPlaces = places.take(limit).toList();
      return List<Map<String, dynamic>>.from(limitedPlaces);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error reading places from seed: $e');
      }
      return [];
    }
  }

  List<Map<String, dynamic>> _getHotelsFromSeed({int limit = AppConstants.pageSize}) {
    try {
      final seedData = SeedDataLoader.instance.hotelsData;
      if (seedData.isEmpty) {
        if (kDebugMode) {
          debugPrint('⚠️ hotelsData seed is empty');
        }
        return [];
      }
      
      // Extract hotels array from seed data
      List<dynamic> hotels = [];
      if (seedData['hotels'] is List) {
        hotels = seedData['hotels'] as List;
      } else if (seedData['data'] is List) {
        hotels = seedData['data'] as List;
      } else if (seedData is List) {
        hotels = seedData as List;
      }
      
      final limitedHotels = hotels.take(limit).toList();
      return List<Map<String, dynamic>>.from(limitedHotels);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error reading hotels from seed: $e');
      }
      return [];
    }
  }

  List<Map<String, dynamic>> _getRestaurantsFromSeed({int limit = AppConstants.pageSize}) {
    try {
      final seedData = SeedDataLoader.instance.restaurantsData;
      if (seedData.isEmpty) {
        if (kDebugMode) {
          debugPrint('⚠️ restaurantsData seed is empty');
        }
        return [];
      }
      
      // Extract restaurants array from seed data
      List<dynamic> restaurants = [];
      if (seedData['restaurants'] is List) {
        restaurants = seedData['restaurants'] as List;
      } else if (seedData['data'] is List) {
        restaurants = seedData['data'] as List;
      } else if (seedData is List) {
        restaurants = seedData as List;
      }
      
      final limitedRestaurants = restaurants.take(limit).toList();
      return List<Map<String, dynamic>>.from(limitedRestaurants);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error reading restaurants from seed: $e');
      }
      return [];
    }
  }
}

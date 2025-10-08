// lib/features/places/presentation/widgets/distance_indicator.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../models/place.dart';

/// Unit system for distance formatting.
enum UnitSystem { metric, imperial }

/// Displays distance between an origin and a target using the haversine formula.
/// - Supports metric (km/m) and imperial (mi/ft) formats.
/// - Compact label or Chip styles.
/// - Convenience factory for Place models.
class DistanceIndicator extends StatelessWidget {
  const DistanceIndicator({
    super.key,
    required this.targetLat,
    required this.targetLng,
    this.originLat,
    this.originLng,
    this.unit = UnitSystem.metric,
    this.icon = Icons.near_me_outlined,
    this.precisionKm = 1,
    this.precisionMi = 1,
    this.compact = false,
    this.labelSuffix = 'away',
  });

  /// Build from a Place and explicit origin (e.g., device location).
  factory DistanceIndicator.fromPlace(
    Place place, {
    Key? key,
    required double originLat,
    required double originLng,
    UnitSystem unit = UnitSystem.metric,
    bool compact = false,
    IconData icon = Icons.near_me_outlined,
    int precisionKm = 1,
    int precisionMi = 1,
    String labelSuffix = 'away',
  }) {
    // Read a flexible JSON map from Place and pick common lat/lng keys.
    Map<String, dynamic> j = const <String, dynamic>{};
    try {
      final dyn = place as dynamic;
      final m = dyn.toJson();
      if (m is Map<String, dynamic>) j = m;
    } catch (_) {}
    final tLat = _parseDouble(j['lat'] ?? j['latitude'] ?? j['coord_lat'] ?? j['location_lat']);
    final tLng = _parseDouble(j['lng'] ?? j['lon'] ?? j['longitude'] ?? j['coord_lng'] ?? j['location_lng']);

    return DistanceIndicator(
      key: key,
      targetLat: tLat,
      targetLng: tLng,
      originLat: originLat,
      originLng: originLng,
      unit: unit,
      compact: compact,
      icon: icon,
      precisionKm: precisionKm,
      precisionMi: precisionMi,
      labelSuffix: labelSuffix,
    );
  }

  final double? originLat;
  final double? originLng;
  final double? targetLat;
  final double? targetLng;

  final UnitSystem unit;
  final IconData icon;
  final int precisionKm;
  final int precisionMi;
  final bool compact;
  final String labelSuffix;

  @override
  Widget build(BuildContext context) {
    if (originLat == null || originLng == null || targetLat == null || targetLng == null) {
      return const SizedBox.shrink();
    }

    final meters = _haversineMeters(originLat!, originLng!, targetLat!, targetLng!);
    final text = _formatDistance(meters);

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.black87)),
        ],
      );
    }

    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      visualDensity: VisualDensity.compact,
    );
  }

  // ---------------------------
  // Distance & formatting
  // ---------------------------

  // Haversine distance in meters.
  // R ≈ 6371 km (mean Earth radius), converted to meters.
  double _haversineMeters(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // meters
    final phi1 = _deg2rad(lat1);
    final phi2 = _deg2rad(lat2);
    final dPhi = _deg2rad(lat2 - lat1);
    final dLam = _deg2rad(lon2 - lon1);

    final a = _hav(dPhi) + (math.cos(phi1) * math.cos(phi2) * _hav(dLam));
    final c = 2 * math.asin(math.sqrt(a));
    return R * c;
  }

  String _formatDistance(double meters) {
    switch (unit) {
      case UnitSystem.metric:
        if (meters < 1000) {
          final m = meters.round();
          return '$m m $labelSuffix';
        } else {
          final km = meters / 1000.0;
          return '${km.toStringAsFixed(precisionKm)} km $labelSuffix';
        }
      case UnitSystem.imperial:
        // 1 mile = 1.609344 km ≈ 0.621371 miles per km.
        final miles = meters / 1000.0 * 0.621371;
        if (miles < 0.1) {
          // Show feet under ~0.1 mi for finer granularity (1 m ≈ 3.28084 ft).
          final feet = meters * 3.28084;
          return '${feet.round()} ft $labelSuffix';
        } else {
          return '${miles.toStringAsFixed(precisionMi)} mi $labelSuffix';
        }
    }
  }

  double _deg2rad(double d) => d * (3.141592653589793 / 180.0);

  double _hav(double x) {
    final s = math.sin(x / 2);
    return s * s;
  }

  // Static parser for the factory.
  static double? _parseDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}

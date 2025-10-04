// lib/features/quick_actions/presentation/booking/widgets/suggested_bookings.dart

import 'package:flutter/material.dart';

import '/../../../models/place.dart';
import '/../../features/places/presentation/widgets/distance_indicator.dart';

class SuggestedBookings extends StatelessWidget {
  const SuggestedBookings({
    super.key,
    required this.places,
    this.title = 'Suggested bookings',
    this.originLat,
    this.originLng,
    this.unit = UnitSystem.metric,
    this.onOpenPlace,
    this.onBook,
    this.onSeeAll,
    this.heroPrefix = 'book-suggest',
    this.cardWidth = 260,
    this.nextAvailableById,
    this.priceFromById,
  });

  final List<Place> places;
  final String title;

  final double? originLat;
  final double? originLng;
  final UnitSystem unit;

  final void Function(Place place)? onOpenPlace;
  final Future<void> Function(Place place)? onBook;
  final VoidCallback? onSeeAll;

  final String heroPrefix;
  final double cardWidth;

  /// Optional pre-fetched next availability per place.id
  final Map<String, DateTime>? nextAvailableById;

  /// Optional pre-fetched "from" price per place.id (minor units or display string)
  final Map<String, String>? priceFromById;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with See all
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  if (onSeeAll != null)
                    TextButton(
                      onPressed: onSeeAll,
                      child: const Text('See all'),
                    ),
                ],
              ),
            ),

            // Horizontal list of booking cards
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: places.length,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, i) {
                  final p = places[i];
                  return Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 8 : 6, right: i == places.length - 1 ? 8 : 6),
                    child: _BookingCard(
                      place: p,
                      width: cardWidth,
                      heroTag: '$heroPrefix-${p.id}',
                      originLat: originLat,
                      originLng: originLng,
                      unit: unit,
                      onOpen: () => onOpenPlace?.call(p),
                      onBook: onBook == null ? null : () => onBook!(p),
                      nextAt: nextAvailableById?[p.id.toString()],
                      priceFrom: priceFromById?[p.id.toString()],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ); // A horizontal ListView.builder inside a section Card creates a compact carousel of items with smooth sideways scrolling. [web:5969]
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.place,
    required this.width,
    required this.heroTag,
    required this.originLat,
    required this.originLng,
    required this.unit,
    this.onOpen,
    this.onBook,
    this.nextAt,
    this.priceFrom,
  });

  final Place place;
  final double width;
  final String heroTag;
  final double? originLat;
  final double? originLng;
  final UnitSystem unit;
  final VoidCallback? onOpen;
  final Future<void> Function()? onBook;
  final DateTime? nextAt;
  final String? priceFrom;

  @override
  Widget build(BuildContext context) {
    final img = _coverUrl(place);
    final name = _nameOf(place);
    final lat = _latOf(place), lng = _lngOf(place);
    final hasCoords = lat != null && lng != null;
    final rating = _ratingOf(place);
    final reviews = _reviewsCountOf(place);

    return SizedBox(
      width: width,
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onOpen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              SizedBox(
                height: 120,
                width: double.infinity,
                child: img == null
                    ? _fallbackImage()
                    : Hero(
                        tag: heroTag,
                        child: Image.network(
                          img,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _fallbackImage(),
                          loadingBuilder: (context, child, prog) {
                            if (prog == null) return child;
                            return _loading();
                          },
                        ),
                      ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 2),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),

              // Meta: rating + distance
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    if (rating != null) _RatingPill(rating: rating, reviews: reviews),
                    if (rating != null && hasCoords && originLat != null && originLng != null) const SizedBox(width: 8),
                    if (hasCoords && originLat != null && originLng != null)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DistanceIndicator.fromPlace(
                            place,
                            originLat: originLat!,
                            originLng: originLng!,
                            unit: unit,
                            compact: true,
                            labelSuffix: 'away',
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Price or next availability
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                child: Text(
                  _secondaryLine(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),

              const Spacer(),

              // Footer actions
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: onOpen,
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('Open'),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: onBook,
                      icon: const Icon(Icons.event_available_outlined, size: 18),
                      label: const Text('Book'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ); // Each suggestion is a Material Card with media, text, and actions, matching accessible card patterns in Flutter. [web:6107]
  }

  String _secondaryLine(BuildContext context) {
    final pf = (priceFrom ?? '').trim();
    if (pf.isNotEmpty) {
      return 'From $pf';
    }
    if (nextAt != null) {
      final local = nextAt!.toLocal();
      final date = '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
      final time = MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(local));
      return 'Next: $date · $time';
    }
    return 'Check availability';
  }

  // ---------- Place helpers via toJson keys ----------

  Map<String, dynamic> _json(Place p) {
    try {
      final dyn = p as dynamic;
      final j = dyn.toJson();
      if (j is Map<String, dynamic>) return j;
    } catch (_) {}
    return const <String, dynamic>{};
  }

  String _nameOf(Place p) {
    final m = _json(p);
    final s = (m['name'] ?? m['title'])?.toString().trim();
    return (s == null || s.isEmpty) ? 'Place' : s;
  }

  String? _coverUrl(Place p) {
    final m = _json(p);
    // Prefer photos/images first element, else imageUrl/cover/thumbnail
    final photos = m['photos'];
    if (photos is List && photos.isNotEmpty) {
      final first = photos.first.toString().trim();
      if (first.isNotEmpty) return first;
    }
    final single = (m['imageUrl'] ?? m['cover'] ?? m['thumbnail'])?.toString().trim();
    return (single != null && single.isNotEmpty) ? single : null;
  }

  double? _latOf(Place p) {
    final m = _json(p);
    final v = m['lat'] ?? m['latitude'] ?? m['locationLat'] ?? m['coordLat'];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  double? _lngOf(Place p) {
    final m = _json(p);
    final v = m['lng'] ?? m['longitude'] ?? m['locationLng'] ?? m['coordLng'];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  double? _ratingOf(Place p) {
    final m = _json(p);
    final v = m['rating'] ?? m['avgRating'];
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  int? _reviewsCountOf(Place p) {
    final m = _json(p);
    final v = m['reviewsCount'] ?? m['reviewCount'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  Widget _fallbackImage() {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: const Icon(Icons.photo_size_select_actual_outlined, color: Colors.black26),
    );
  }

  Widget _loading() {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating, this.reviews});
  final double rating;
  final int? reviews;

  @override
  Widget build(BuildContext context) {
    final showReviews = reviews != null && reviews! > 0;
    final text = showReviews ? '${rating.toStringAsFixed(1)} · $reviews' : rating.toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 14, color: Colors.amber),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

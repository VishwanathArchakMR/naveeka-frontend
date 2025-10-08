// lib/features/places/presentation/widgets/booking_services.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A single booking/action item that can either launch a URL or run a custom tap handler.
class BookingAction {
  const BookingAction({
    required this.label,
    required this.icon,
    this.url,
    this.onTap,
    this.prominent = false,
    this.color,
    this.requiresConfirm = false,
    this.confirmTitle,
    this.confirmMessage,
  }) : assert(url != null || onTap != null, 'Provide either url or onTap');

  final String label;
  final IconData icon;
  final Uri? url;
  final VoidCallback? onTap;

  /// If true, render as a FilledButton; otherwise OutlinedButton.
  final bool prominent;

  /// Optional button color override (used only for prominent = true).
  final Color? color;

  /// If true, shows a small confirm sheet before performing the action.
  final bool requiresConfirm;
  final String? confirmTitle;
  final String? confirmMessage;
}

/// A compact action bar for booking/interacting with a Place-like object:
/// - Use [actions] for custom entries.
/// - Or call [BookingServices.defaultActionsFromPlace] to derive sensible defaults from a place-like map/object.
class BookingServices extends StatelessWidget {
  const BookingServices({
    super.key,
    required this.actions,
    this.title = 'Booking & services',
    this.showTitle = true,
    this.wrapSpacing = 8,
    this.runSpacing = 8,
  });

  final List<BookingAction> actions;
  final String title;
  final bool showTitle;
  final double wrapSpacing;
  final double runSpacing;

  /// Derive default actions (Directions, Call, Website) from a place-like object plus optional booking URLs.
  /// Accepts either a Map<String,dynamic> or any dynamic object with optional fields: website/url, phone/tel, lat/latitude, lng/longitude.
  static List<BookingAction> defaultActionsFromPlace(
    dynamic place, {
    Uri? reserveUrl,
    Uri? bookingUrl,
    Uri? orderUrl,
  }) {
    final out = <BookingAction>[];

    if (reserveUrl != null) {
      out.add(BookingAction(
        label: 'Reserve',
        icon: Icons.event_seat_outlined,
        url: reserveUrl,
        prominent: true,
        requiresConfirm: false,
      ));
    }

    if (bookingUrl != null) {
      out.add(BookingAction(
        label: 'Book tickets',
        icon: Icons.local_activity_outlined,
        url: bookingUrl,
        prominent: true,
        requiresConfirm: false,
      ));
    }

    if (orderUrl != null) {
      out.add(BookingAction(
        label: 'Order',
        icon: Icons.delivery_dining_outlined,
        url: orderUrl,
        prominent: false,
        requiresConfirm: false,
      ));
    }

    final website = _pickWebsite(place);
    if (website != null && website.trim().isNotEmpty) {
      out.add(BookingAction(
        label: 'Website',
        icon: Icons.public_outlined,
        url: _ensureHttp(website.trim()),
      ));
    }

    final phone = _pickPhone(place);
    if (phone != null && phone.trim().isNotEmpty) {
      out.add(BookingAction(
        label: 'Call',
        icon: Icons.call_outlined,
        url: Uri(scheme: 'tel', path: phone.trim()),
      ));
    }

    final coords = _pickLatLng(place);
    if (coords != null) {
      final q = '${coords.$1.toStringAsFixed(6)},${coords.$2.toStringAsFixed(6)}';
      out.add(BookingAction(
        label: 'Directions',
        icon: Icons.map_outlined,
        url: Uri.parse('https://www.google.com/maps/search/?api=1&query=$q'),
      ));
    }

    return out;
  }

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            Wrap(
              spacing: wrapSpacing,
              runSpacing: runSpacing,
              children: actions.map((a) {
                return a.prominent
                    ? FilledButton.icon(
                        onPressed: () => _tap(context, a),
                        icon: Icon(a.icon),
                        label: Text(a.label),
                        style: a.color != null ? FilledButton.styleFrom(backgroundColor: a.color) : null,
                      )
                    : OutlinedButton.icon(
                        onPressed: () => _tap(context, a),
                        icon: Icon(a.icon),
                        label: Text(a.label),
                      );
              }).toList(growable: false),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _tap(BuildContext context, BookingAction a) async {
    if (a.requiresConfirm) {
      final go = await _confirm(context, a.confirmTitle ?? a.label, a.confirmMessage);
      if (go != true) return;
    }
    if (a.onTap != null) {
      a.onTap!();
      return;
    }
    if (a.url != null) {
      final http = a.url!.scheme.startsWith('http');
      final ok = await launchUrl(
        a.url!,
        mode: http ? LaunchMode.externalApplication : LaunchMode.platformDefault,
      );
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch ${a.label.toLowerCase()}')),
        );
      }
    }
  }

  Future<bool?> _confirm(BuildContext context, String title, String? msg) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: false,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
                  IconButton(onPressed: () => Navigator.of(ctx).maybePop(false), icon: const Icon(Icons.close)),
                ],
              ),
              if (msg != null && msg.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                Align(alignment: Alignment.centerLeft, child: Text(msg)),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).maybePop(false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(ctx).maybePop(true),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Uri _ensureHttp(String raw) {
    final s = raw.trim();
    if (s.startsWith('http://') || s.startsWith('https://')) return Uri.parse(s);
    return Uri.parse('https://$s');
  }

  // ---- Safe extractors for dynamic or Map-based place data ----

  static String? _pickWebsite(dynamic p) {
    try {
      final v = (p.website as String?);
      if (v != null) return v;
    } catch (_) {}
    try {
      final v = (p.url as String?);
      if (v != null) return v;
    } catch (_) {}
    if (p is Map) {
      return p['website']?.toString() ??
          p['url']?.toString() ??
          p['site']?.toString() ??
          p['link']?.toString();
    }
    return null;
  }

  static String? _pickPhone(dynamic p) {
    try {
      final v = (p.phone as String?);
      if (v != null) return v;
    } catch (_) {}
    try {
      final v = (p.tel as String?);
      if (v != null) return v;
    } catch (_) {}
    if (p is Map) {
      return p['phone']?.toString() ??
          p['tel']?.toString() ??
          p['telephone']?.toString() ??
          p['mobile']?.toString();
    }
    return null;
  }

  // Returns (lat, lng) as a record if both present
  static (double, double)? _pickLatLng(dynamic p) {
    double? parseDouble(dynamic v) {
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    double? lat;
    double? lng;

    // Try direct properties
    try {
      lat = parseDouble(p.lat);
    } catch (_) {}
    try {
      lng = parseDouble(p.lng);
    } catch (_) {}

    // Try alternate property names
    if (lat == null) {
      try {
        lat = parseDouble(p.latitude);
      } catch (_) {}
    }
    if (lng == null) {
      try {
        lng = parseDouble(p.longitude);
      } catch (_) {}
    }

    // Try map-based
    if (p is Map) {
      lat ??= parseDouble(p['lat']) ?? parseDouble(p['latitude']);
      lng ??= parseDouble(p['lng']) ?? parseDouble(p['longitude']);
      // nested geo {lat,lng}
      if (lat == null || lng == null) {
        final geo = p['geo'];
        if (geo is Map) {
          lat ??= parseDouble(geo['lat']) ?? parseDouble(geo['latitude']);
          lng ??= parseDouble(geo['lng']) ?? parseDouble(geo['longitude']);
        }
      }
    }

    if (lat != null && lng != null) return (lat, lng);
    return null;
  }
}

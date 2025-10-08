// lib/features/journey/presentation/restaurants/restaurant_search_screen.dart

import 'package:flutter/material.dart';

import 'restaurant_results_screen.dart';
import 'widgets/cuisine_by_location.dart';
import '../cabs/widgets/location_picker.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({
    super.key,
    this.title = 'Search restaurants',
    this.initialDestination,
    this.initialCenterLat,
    this.initialCenterLng,
    this.initialCuisines = const <String>{},
    this.currency = '₹',

    // Optional: plug backend fetcher for cuisines to power CuisineByLocation
    this.fetchCuisines, // Future<List<Map>> Function({double? lat,double? lng,String? city})
  });

  final String title;
  final String? initialDestination;
  final double? initialCenterLat;
  final double? initialCenterLng;
  final Set<String> initialCuisines;
  final String currency;

  final Future<List<Map<String, dynamic>>> Function({
    double? lat,
    double? lng,
    String? city,
  })? fetchCuisines;

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final _destCtrl = TextEditingController();

  double? _centerLat;
  double? _centerLng;

  Set<String> _cuisines = <String>{};

  @override
  void initState() {
    super.initState();
    _destCtrl.text = widget.initialDestination ?? '';
    _centerLat = widget.initialCenterLat;
    _centerLng = widget.initialCenterLng;
    _cuisines = {...widget.initialCuisines};
  }

  @override
  void dispose() {
    _destCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _pickCenterOnMap() async {
    final res = await LocationPicker.show(
      context,
      title: 'Choose map center',
      initialLat: _centerLat,
      initialLng: _centerLng,
    );
    if (res != null) {
      setState(() {
        _centerLat = (res['lat'] as double?) ?? _centerLat;
        _centerLng = (res['lng'] as double?) ?? _centerLng;
      });
    }
  }

  void _search() {
    final dest = _destCtrl.text.trim();
    if (dest.isEmpty) {
      _snack('Enter a destination');
      return;
    }

    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => RestaurantResultsScreen(
        destination: dest,
        centerLat: _centerLat,
        centerLng: _centerLng,
        currency: widget.currency,
        initialCuisines: _cuisines,
        title: 'Restaurants',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final centerBadge = (_centerLat != null && _centerLng != null)
        ? 'Lat ${_centerLat!.toStringAsFixed(3)}, Lng ${_centerLng!.toStringAsFixed(3)}'
        : 'Optional';

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            // Destination
            TextFormField(
              controller: _destCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Destination (city/area)',
                prefixIcon: const Icon(Icons.place_outlined),
                suffixIcon: IconButton(
                  tooltip: 'Pick center on map',
                  icon: const Icon(Icons.map_outlined),
                  onPressed: _pickCenterOnMap,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Map center status
            ListTile(
              onTap: _pickCenterOnMap,
              leading: const Icon(Icons.my_location),
              title: const Text('Map center'),
              subtitle: Text(centerBadge, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right),
            ),

            const SizedBox(height: 12),

            // Cuisines (inline quick picks + "All" sheet)
            CuisineByLocation(
              lat: _centerLat,
              lng: _centerLng,
              city: _destCtrl.text.trim().isEmpty ? widget.initialDestination : _destCtrl.text.trim(),
              fetchCuisines: widget.fetchCuisines ?? (({double? lat, double? lng, String? city}) async => <Map<String, dynamic>>[]),
              initialSelected: _cuisines,
              multiSelect: true,
              title: 'Cuisines',
              // Note: If CuisineByLocation exposes a selection callback, replace with its exact parameter (e.g., onChanged/onSelected). [web:6155]
            ),

            const SizedBox(height: 20),

            // CTA
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _search,
                icon: const Icon(Icons.search),
                label: const Text('Search restaurants'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

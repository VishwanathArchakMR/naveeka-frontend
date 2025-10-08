// lib/navigation/app_router.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/atlas/presentation/atlas_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/trails/presentation/trails_screen.dart';
import '../features/trails/presentation/trails_feed.dart';
import '../features/trails/presentation/trails_explore.dart';
import '../features/trails/presentation/trails_create_post.dart';
import '../features/trails/presentation/trails_activity.dart';
import '../features/trails/presentation/widgets/trail_profile.dart';
import '../features/trails/data/trail_location_api.dart';

import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

Page<dynamic> _materialPage(Widget child, GoRouterState state) =>
    MaterialPage<void>(key: state.pageKey, child: child);

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutePaths.splash,
  debugLogDiagnostics: !kReleaseMode,
  routes: <RouteBase>[
    GoRoute(
      name: RouteNames.splash,
      path: RoutePaths.splash,
      pageBuilder: (context, state) => _materialPage(
        const _SplashPlaceholder(),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.home,
      path: RoutePaths.home,
      pageBuilder: (context, state) => _materialPage(
        const HomeScreen(),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.atlas,
      path: RoutePaths.atlas,
      pageBuilder: (context, state) {
        final qp = state.uri.queryParameters;
        final initialQuery = qp['q'];
        final region = qp['region'];
        final nearby = _parseBool(qp['nearby']);
        final trending = _parseBool(qp['trending']);
        return _materialPage(
          AtlasScreen(
            initialQuery: initialQuery,
            region: region,
            nearby: nearby,
            trending: trending,
          ),
          state,
        );
      },
    ),
    GoRoute(
      name: RouteNames.placeDetail,
      path: '${RoutePaths.placeDetail}/:${RouteParams.id}',
      pageBuilder: (context, state) {
        final id = state.pathParameters[RouteParams.id] ?? '';
        return _materialPage(_PlaceDetailPlaceholder(placeId: id), state);
      },
    ),

    // Trails main route wired to real screen with nested subroutes
    GoRoute(
      name: RouteNames.trails,
      path: RoutePaths.trails,
      pageBuilder: (context, state) => _materialPage(const TrailsScreen(), state),
      routes: [
        GoRoute(
          name: RouteNames.trailsFeed,
          path: 'feed',
          pageBuilder: (context, state) => _materialPage(const TrailsFeed(), state),
        ),
        GoRoute(
          name: RouteNames.trailsExplore,
          path: 'explore',
          pageBuilder: (context, state) => _materialPage(const TrailsExplore(), state),
        ),
        GoRoute(
          name: RouteNames.trailsCreate,
          path: 'create',
          pageBuilder: (context, state) => _materialPage(const TrailsCreatePost(), state),
        ),
        GoRoute(
          name: RouteNames.trailsActivity,
          path: 'activity',
          pageBuilder: (context, state) => _materialPage(const TrailsActivityPage(), state),
        ),
        GoRoute(
          name: RouteNames.trailsProfile,
          path: 'profile',
          pageBuilder: (context, state) => _materialPage(
            const TrailProfile(
              detail: TrailDetail(
                summary: TrailSummary(
                  id: 'placeholder',
                  name: 'Placeholder Trail',
                  center: GeoPoint(0.0, 0.0),
                ),
                description: 'This is a placeholder trail',
              ),
            ),
            state,
          ),
        ),
      ],
    ),

    // Register missing quick action routes
    GoRoute(
      name: RouteNames.booking,
      path: RoutePaths.booking,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Booking'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.history,
      path: RoutePaths.history,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'History'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.favorites,
      path: RoutePaths.favorites,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Favorites'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.following,
      path: RoutePaths.following,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Following'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.planning,
      path: RoutePaths.planning,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Planning'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.messages,
      path: RoutePaths.messages,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Messages'),
        state,
      ),
    ),

    GoRoute(
      name: RouteNames.journey,
      path: RoutePaths.journey,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Journey'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.naveeAI,
      path: RoutePaths.naveeAI,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Navee AI'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.settings,
      path: RoutePaths.settings,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Settings'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.profile,
      path: RoutePaths.profile,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Profile'),
        state,
      ),
    ),
    GoRoute(
      name: RouteNames.checkout,
      path: RoutePaths.checkout,
      pageBuilder: (context, state) => _materialPage(
        const _SimplePlaceholder(title: 'Checkout'),
        state,
      ),
    ),
  ],
  errorPageBuilder: (context, state) => _materialPage(
    _RouterErrorScreen(error: state.error),
    state,
  ),
  redirect: (context, state) {
    return null;
  },
);

bool? _parseBool(String? v) {
  if (v == null) return null;
  final s = v.toLowerCase();
  return s == '1' || s == 'true' || s == 'yes';
}

class _SplashPlaceholder extends StatelessWidget {
  const _SplashPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash'),
      ),
    );
  }
}

class _PlaceDetailPlaceholder extends StatelessWidget {
  final String placeId;
  const _PlaceDetailPlaceholder({required this.placeId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Place Detail')),
      body: Center(
        child: Text('Place ID: $placeId'),
      ),
    );
  }
}

class _SimplePlaceholder extends StatelessWidget {
  final String title;
  const _SimplePlaceholder({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

class _RouterErrorScreen extends StatelessWidget {
  final Exception? error;
  const _RouterErrorScreen({this.error});
  @override
  Widget build(BuildContext context) {
    final message = error?.toString() ?? 'Unknown route error';
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Error')),
      body: Center(
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

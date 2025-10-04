    loader.loadAllSeedData();
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

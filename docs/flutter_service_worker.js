'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "bf9c0a10bede500d2a9883ab1154dcb9",
"assets/AssetManifest.bin.json": "68f6b65b5d8875210c84012708ce9a64",
"assets/AssetManifest.json": "e0d24612a3a6e8e1857e0d12a65fe44b",
"assets/assets/animations/empty_box.json": "7fa3d00a1ab7c8baa14576e6cfbb5d1f",
"assets/assets/animations/heart_animation.json": "aff21056b9471e7043543b45fcff671d",
"assets/assets/animations/loading.json": "01f1d8dc10012b037e8062bc70849422",
"assets/assets/animations/location_pulse.json": "c5b1be5681bf302dc33af1397826e0df",
"assets/assets/animations/map_loading.json": "ee6e65d2d15971a775c6d9ccaa5019e0",
"assets/assets/animations/voice_animation.json": "2f0cfa6bc81714c730561f990dd5442b",
"assets/assets/fonts/Inter-Bold.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/fonts/Inter-Medium.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/fonts/Inter-Regular.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/fonts/Inter-SemiBold.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/fonts/Poppins-Bold.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/fonts/Poppins-Medium.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/fonts/Poppins-Regular.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/fonts/Poppins-SemiBold.ttf": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/booking_icon.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/directions.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/distance.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/favorites_icon.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/following_icon.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/gps.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/heart_filled.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/heart_outline.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/history_icon.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/location_pin.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/map_view.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/messages_icon.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/icons/planning_icon.svg": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/images/placeholder.jpg": "619ff015661ef16381e22473269f1453",
"assets/assets/seed-data/activities_seed.json": "6b4c12ff0179362437575f5a40e32f16",
"assets/assets/seed-data/airports_seed.json": "7f2ba3c8af598de0d6c788268b1cc98a",
"assets/assets/seed-data/atlas_seed.json": "36c17e9bca5888ecd2f09883b5038b84",
"assets/assets/seed-data/booking_seed.json": "4d6b04a0bfb35bfd97021e5a7cec241f",
"assets/assets/seed-data/buses_seed.json": "0d953edc0a35ac1bfffecbbd9e6e523d",
"assets/assets/seed-data/bus_stops_seed.json": "4b2bace3eeab5999bb4ba81b3f438458",
"assets/assets/seed-data/favorites_seed.json": "99dea5c78b90272114c54ef9b176ace6",
"assets/assets/seed-data/flights_seed.json": "fa4f7a87371e44e37c2dc52c7ff8deff",
"assets/assets/seed-data/following_seed.json": "4ada0a7b073d326c45e5a497d705b994",
"assets/assets/seed-data/history_seed.json": "408316e1790ac3fa1261f38fae15030f",
"assets/assets/seed-data/home_seed.json": "cb76aad03a25d396decff2d8afc5cf74",
"assets/assets/seed-data/hotels_seed.json": "15fb8fa87008e3ff927a30a18c90ba67",
"assets/assets/seed-data/journey_seed.json": "0230f5168a8e70bb1a20d970619e63e1",
"assets/assets/seed-data/locations_master.json": "a146365051ec91272736cc12bf4f16fd",
"assets/assets/seed-data/messages_seed.json": "0aaeb5cf6bd95779d2a73b7e1a1d89e6",
"assets/assets/seed-data/navee_ai_seed.json": "ea99bca2505d96cadf09d0cd9f5c91be",
"assets/assets/seed-data/places_seed.json": "2e6b11b075e85d6c586361e50485fc36",
"assets/assets/seed-data/planning_seed.json": "fad1fb06089ce10259c8412ceb4cea0e",
"assets/assets/seed-data/restaurants_seed.json": "517ee32ba7f8326cbec4e8cf1853f77c",
"assets/assets/seed-data/settings_seed.json": "db634b41efb66013e6090bedb2a852fc",
"assets/assets/seed-data/trail_seed.json": "828c7dbd056e9bc39b83f2bc49380958",
"assets/assets/seed-data/trains_seed.json": "b24485195ce1536a324cc8d1a470828a",
"assets/assets/seed-data/train_stations_seed.json": "3d2124f2bcd198c3dda0ffe6bc985518",
"assets/FontManifest.json": "093205878c14ca2b9c75ad531107e67c",
"assets/fonts/MaterialIcons-Regular.otf": "05b8ef7274a27f3d8fdcd3283b1df2bb",
"assets/NOTICES": "7ffa364d0b6d031a1618ccc12a169477",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "0b57fc51ae02db992bcb0613d7e569e4",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "c6bc8dd809341ab671c014fef86b6871",
"/": "c6bc8dd809341ab671c014fef86b6871",
"main.dart.js": "7485a95fd68a6799ba4fa8a9fc894358",
"manifest.json": "01b1888215a33e0d27b0087cb0f3c523",
"version.json": "704ae23bd66ec449c8e34d789d4cb0d5"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

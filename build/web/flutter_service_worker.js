'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "04e86aab4eb32c6fbcc718028619edb6",
"assets/AssetManifest.bin.json": "56616b3fdf294ce834de7cb8905818e0",
"assets/AssetManifest.json": "4fc544ed392ebd37b7764c55d3e5e94a",
"assets/assets/cards/10_of_clubs.png": "7fb1f45b710e0d1ca186dd79c7d1113e",
"assets/assets/cards/10_of_diamonds.png": "d1be977d1098848d2f91996a9d630e20",
"assets/assets/cards/10_of_hearts.png": "4f45bcb3d89cfcb01905b915e697ce91",
"assets/assets/cards/10_of_spades.png": "624c5f7cc89fe2b9da0b3bf35b3e0858",
"assets/assets/cards/2_of_clubs.png": "cd9a9693c5a49d83fb6bda1f1ee830f8",
"assets/assets/cards/2_of_diamonds.png": "b021d586b2f29f33314da7929fcf88aa",
"assets/assets/cards/2_of_hearts.png": "1f081d5fb8b007bea93e4de51e0c4cdf",
"assets/assets/cards/2_of_spades.png": "100b9a80778fb6c50afe46ab79e73dec",
"assets/assets/cards/3_of_clubs.png": "d57363353313624e1e8a9924c4043ab8",
"assets/assets/cards/3_of_diamonds.png": "3db76f2a9a7ff2680a04d8cb1c83d49c",
"assets/assets/cards/3_of_hearts.png": "7eca300c1a29155ec8419070c0fa93a3",
"assets/assets/cards/3_of_spades.png": "7117c860920858c8c0e1675ab48fa2d5",
"assets/assets/cards/4_of_clubs.png": "3ae2a25650b580988358d7cf30b64955",
"assets/assets/cards/4_of_diamonds.png": "1e53e041333ae849f41f91322b8684d7",
"assets/assets/cards/4_of_hearts.png": "0a6e3cbbfa0926e75dddda85fefffbf0",
"assets/assets/cards/4_of_spades.png": "af832ccf0f39a5a95f84bb453d4b8800",
"assets/assets/cards/5_of_clubs.png": "2fdaf2532cc937cf9ea0545e691f00bf",
"assets/assets/cards/5_of_diamonds.png": "718ffdce51bd629275d8049c6e246e4d",
"assets/assets/cards/5_of_hearts.png": "1edc652b19bc988348fcc545097550d1",
"assets/assets/cards/5_of_spades.png": "ed02ff9120ae73e9abc26d29f990b282",
"assets/assets/cards/6_of_clubs.png": "4ca835efca51d745e8af182b46c4cdfe",
"assets/assets/cards/6_of_diamonds.png": "bb79bb6542ee263255d4c1cdcf7f9326",
"assets/assets/cards/6_of_hearts.png": "dc88aca87d82dcf30f8f802839e46b44",
"assets/assets/cards/6_of_spades.png": "d4772bb90cf4f0a7447d2e1a5aabd8d3",
"assets/assets/cards/7_of_clubs.png": "62aa841c3cff624d8f57cce961c62be9",
"assets/assets/cards/7_of_diamonds.png": "4c293cdaab68eb4b240d570899f0853c",
"assets/assets/cards/7_of_hearts.png": "a8c6948d111a267ccb3b83c98461b312",
"assets/assets/cards/7_of_spades.png": "b09814e2189f6c1a9e67e228513e8518",
"assets/assets/cards/8_of_clubs.png": "63fcb3c204975ad08205996e2824c127",
"assets/assets/cards/8_of_diamonds.png": "82c8f08fdbb622af31f6c4e3cf10c4f0",
"assets/assets/cards/8_of_hearts.png": "75da1f9567d3092e0fdce616f46bf289",
"assets/assets/cards/8_of_spades.png": "085e3ca3e6bea378c0f8a3fcaf6f5416",
"assets/assets/cards/9_of_clubs.png": "73462a18ea651937ca04137797be99ac",
"assets/assets/cards/9_of_diamonds.png": "6bc3ba1343500526ccc837651d3c963f",
"assets/assets/cards/9_of_hearts.png": "86d439cf96b38d90d9af95b429dcb509",
"assets/assets/cards/9_of_spades.png": "9a05178883f2308f91886fdd2ac87e40",
"assets/assets/cards/ace_of_clubs.png": "57e702715bb2b17fdb98490e2f207c78",
"assets/assets/cards/ace_of_diamonds.png": "ce5bc5de8c7c718e2ae1698a9fe143a5",
"assets/assets/cards/ace_of_hearts.png": "1fcff170d8dae28c874e292a9f7f5e1c",
"assets/assets/cards/ace_of_spades.png": "9d2f7fb753d727c6c794991dac5589f4",
"assets/assets/cards/back.png": "3f4b9109d76da54ca5e6f78d24e7ef6f",
"assets/assets/cards/back@2x.png": "e7051d9e94efc4a49e18e71fa5422d8d",
"assets/assets/cards/black_joker.png": "8e78fe87e9d3e05e070d0c937e67214c",
"assets/assets/cards/jack_of_clubs.png": "d6d61a82d0c1d41c2d9243aeb5090ad8",
"assets/assets/cards/jack_of_diamonds.png": "f4f1c70bea52aa9b7633330730b8d720",
"assets/assets/cards/jack_of_hearts.png": "f634cf976686fc790a45ddf118c39610",
"assets/assets/cards/jack_of_spades.png": "43030464716ef1c7ab056eedabbfd914",
"assets/assets/cards/king_of_clubs.png": "7c08604030c80100031a2c9a2d51058b",
"assets/assets/cards/king_of_diamonds.png": "6547e008b50fc870bf7ab54b524a6f72",
"assets/assets/cards/king_of_hearts.png": "a1e1243727b63c3aeb0bcc2cdd120c1f",
"assets/assets/cards/king_of_spades.png": "311032ee0effc346a912adad67d50e0e",
"assets/assets/cards/queen_of_clubs.png": "c8485ac99e53544715f62be0c2149a61",
"assets/assets/cards/queen_of_diamonds.png": "06641f15288cb587249e4f2736908f42",
"assets/assets/cards/queen_of_hearts.png": "349cb8fff708fd11615781973d29695c",
"assets/assets/cards/queen_of_spades.png": "180d1f0d5d4f6aa019e589506c04f227",
"assets/assets/cards/red_joker.png": "d55a4ada1cb2c5c393369a6c6d994e9b",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/NOTICES": "8c997229e13f4879c73ee476e34f61fb",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "5ee038a7a119066a77cae7592541fecd",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "daf2c59566263dde5b620e2dcaabe9a1",
"/": "daf2c59566263dde5b620e2dcaabe9a1",
"main.dart.js": "94b034e65f67cf99be7729392429e1c6",
"manifest.json": "e9723896a63e6fe458fe3c9e12b39a71",
"version.json": "3e8d9e46bf355005625cd9783d40f519"};
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

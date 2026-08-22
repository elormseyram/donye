import 'dart:async';
import 'dart:html' as html;

bool _ready = false;
Future<bool>? _loading;

bool get isGoogleMapsReady => _ready;

Future<bool> ensureGoogleMapsLoaded(String apiKey) {
  if (_ready) return Future.value(true);
  if (apiKey.trim().isEmpty) return Future.value(false);
  return _loading ??= _load(apiKey.trim());
}

Future<bool> _load(String apiKey) async {
  final existing = html.document.querySelector(
    'script[data-dornye-google-maps="true"]',
  );
  if (existing != null) {
    _ready = true;
    return true;
  }

  final completer = Completer<bool>();
  final script = html.ScriptElement()
    ..dataset['dornyeGoogleMaps'] = 'true'
    ..async = true
    ..defer = true
    ..src = 'https://maps.googleapis.com/maps/api/js?key='
        '${Uri.encodeQueryComponent(apiKey)}';
  script.onLoad.first.then((_) {
    _ready = true;
    if (!completer.isCompleted) completer.complete(true);
  });
  script.onError.first.then((_) {
    if (!completer.isCompleted) completer.complete(false);
  });
  html.document.head?.append(script);
  return completer.future.timeout(
    const Duration(seconds: 15),
    onTimeout: () => false,
  );
}

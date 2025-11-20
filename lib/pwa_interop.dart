import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS('installPWA')
external JSPromise _installPWA();

extension InstallPWAInterop on web.Window {
  JSPromise installPWA() => _installPWA();
}

import 'dart:js_interop';

import 'package:web/web.dart' as web;

class RequisicionBeforeUnload {
  RequisicionBeforeUnload(bool Function() hasChanges) {
    _listener = ((web.Event event) {
      if (hasChanges()) {
        event.preventDefault();
        (event as web.BeforeUnloadEvent).returnValue = '';
      }
    }).toJS;
    web.window.addEventListener('beforeunload', _listener);
  }

  late final JSFunction _listener;
  void dispose() => web.window.removeEventListener('beforeunload', _listener);
}

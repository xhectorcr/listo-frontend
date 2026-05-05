import 'dart:html' as html;

Future<bool> requestBrowserCameraPermission() async {
  try {
    final mediaStream = await html.window.navigator.mediaDevices?.getUserMedia({'video': true});
    if (mediaStream != null) {
      // Stop tracks immediately; this call only triggers the permission prompt
      for (final track in mediaStream.getTracks()) {
        track.stop();
      }
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}

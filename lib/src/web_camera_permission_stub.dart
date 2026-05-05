Future<bool> requestBrowserCameraPermission() async {
  // Non-web platforms: nothing to do here (permission handled elsewhere)
  return true;
}

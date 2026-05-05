Future<bool> checkAndRequestCameraPermission() async {
  // Web or unsupported platforms: assume permission is handled by browser
  return true;
}

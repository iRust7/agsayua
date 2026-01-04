/// Utility helpers for resolving product and category images.
class ImageUtils {
  /// Normalizes image paths from the API.
  /// - If the path is an http/https URL, return as-is.
  /// - If it's a relative asset path (e.g. "Assets/file.jpg"), prefix with "lib/".
  static String? resolveImagePath(String? path) {
    if (path == null || path.isEmpty) return null;
    if (_isNetworkPath(path)) return path;

    var normalized = path;
    if (normalized.startsWith('/')) {
      normalized = normalized.substring(1);
    }

    return 'lib/$normalized';
  }

  /// Checks whether the path points to a network image.
  static bool isNetworkPath(String path) => path.startsWith('http://') || path.startsWith('https://');

  static bool _isNetworkPath(String path) => isNetworkPath(path);
}

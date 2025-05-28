final class Env {
  static String get googleMapsApiKey =>
      const String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static List<EnvKey> get keys => [
    EnvKey('googleMapsApiKey', () => googleMapsApiKey),
  ];
}

final class EnvKey {
  EnvKey(this.name, this.value);

  String call() => value();

  final String name;

  final String Function() value;
}

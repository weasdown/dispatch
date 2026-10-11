final class Environment {
  static String get googleMapsApiKey =>
      const String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static List<EnvironmentKey> get keys => [
    EnvironmentKey('googleMapsApiKey', () => googleMapsApiKey),
  ];
}

final class EnvironmentKey {
  EnvironmentKey(this.name, this.value);

  String call() => value();

  final String name;

  final String Function() value;
}

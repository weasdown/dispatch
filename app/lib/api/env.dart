final class Env {
  static String get googleMapsApiKey =>
      const String.fromEnvironment('GOOGLE_MAPS_API_KEY');

  static List<Key> get keys => [
    Key('googleMapsApiKey', () => googleMapsApiKey),
  ];
}

final class Key {
  Key(this.name, this.value);

  String call() => value();

  final String name;

  final String Function() value;
}

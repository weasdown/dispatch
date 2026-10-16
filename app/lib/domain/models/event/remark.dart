import '../person/user.dart';

final class Remark {
  Remark({required this.author, required this.message});

  final User author;

  final DateTime timestamp = DateTime.now();

  final String message;
}

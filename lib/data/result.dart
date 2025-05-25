/*
 *  Copyright (c) 2025. Oxford Hypernautics Ltd
 *  All rights reserved.
 */

/// The following classes were copied from [result.dart] in Flutter's sample [compass_app][compass].
///
/// [result.dart]: https://github.com/flutter/samples/blob/main/compass_app/app/lib/utils/result.dart
/// [compass]: https://github.com/flutter/samples/blob/main/compass_app
library;

/// Utility class to wrap result data
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Ok(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error) = Error._;

  /// Returns a [Future] with an [Error] result built around a given [error].
  Future<Error> futureError(Exception error) =>
      Future(() => Result.error(error) as Error);

  /// Returns a [Future] with an [Ok] result built around a given [value].
  Future<Ok<T>> futureOk(T value) => Future(() => Result.ok(value) as Ok<T>);

  /// Returns a [Future] with a [Result]`<void>`.
  Future<Result<void>> futureOkVoid() =>
      Future(() => const Result.okVoid() as Result<void>);

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value) = Ok._;

  /// Creates a successful [Result]`<void>`.
  const factory Result.okVoid() = Ok._void;
}

/// Subclass of [Result] for values
final class Ok<T> extends Result<T> {
  /// Builds an [Ok] [Result] with a given [value].
  const Ok._(this.value);

  /// Builds an [Ok] [Result] that has no [value].
  const Ok._void() : value = null as T;

  /// Returned value in result
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Subclass of [Result] for errors
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Returned error in result
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

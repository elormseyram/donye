import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

extension EitherX<L, R> on Either<L, R> {
  R getRight() => (this as Right<L, R>).value;
  L getLeft() => (this as Left<L, R>).value;
  bool get isRight => fold((_) => false, (_) => true);
  bool get isLeft => !isRight;
}

extension FailureEitherX<R> on Either<Failure, R> {
  String get failureMessage => fold((f) => f.message, (_) => '');

  T fold2<T>({
    required T Function(Failure failure) onFailure,
    required T Function(R data) onSuccess,
  }) {
    return fold(onFailure, onSuccess);
  }
}

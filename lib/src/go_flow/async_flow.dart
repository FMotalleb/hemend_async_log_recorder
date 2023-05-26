import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/go_flow/helper.dart';

/// Async Flow Handler will create an additional call stack to push desired
/// methods to run after the main call
class AsyncFlow<T> {
  AsyncFlow._()
      : _differedStack = [],
        _isDone = false;

  /// This static method serves as the entry point to the AsyncFlow handler.
  /// It receives an [AsyncTask] and executes it within a try scope.
  /// It returns a AsyncResultSignature<T> object, which consists of a result
  /// and an exception.
  ///
  /// The task parameter represents the main method to be executed in
  /// the task flow. Within this method, you can use
  /// the defer method (accessible as a parameter) to push methods to run after
  /// the main method call.
  ///
  /// The defer method receives the result and/or exception from
  /// the last deferred method or the main method. It can act on
  /// these values and may or may not modify the result of the flow.
  static AsyncResultSignature<T> handle<T>(
    AsyncTask<T> task,
  ) =>
      AsyncFlow<T>._()._deferredCall(task);
  final List<AsyncDeferred<T>> _differedStack;
  bool _isDone;
  void _pushToDiffer(AsyncDeferred<T> task) => _differedStack.add(task);

  AsyncResultSignature<T> _deferredCall(
    AsyncTask<T> task,
  ) async {
    if (_isDone) {
      throw Exception('This Flow is already completed');
    }
    ResultSignature<T> result = (result: null, exception: null);
    try {
      result = await task(_pushToDiffer) ?? result;
    } catch (e) {
      result = (result: null, exception: e);
    }

    _isDone = true;
    return _differedStack.reversed.fold<Future<ResultSignature<T>>>(
      Future.value(result),
      (previousValue, element) async {
        final prevResult = await previousValue;
        final result = await element(prevResult);
        return prevResult.copyWith(
          result: result?.result,
          exception: result?.exception,
        );
      },
    );
  }
}

import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/go_flow/helper.dart';

/// {@template sync-flow}
/// The SyncFlowHandler is responsible for managing synchronous task flows by
/// creating an additional call stack to schedule and execute desired methods
/// after the main call. It provides a structured and organized approach to
/// handle sequential execution of synchronous tasks.
///
/// By utilizing the Sync Flow Handler, developers can easily define and
/// orchestrate the execution order of synchronous methods, allowing for
/// modular and customizable synchronous task flows.
/// The handler creates a separate call stack for deferred methods, enabling
/// them to run in a controlled and predetermined sequence, ensuring proper
/// flow and synchronization within the task execution.
/// This abstraction simplifies the implementation of complex synchronous flows,
/// enhances code readability, and promotes maintainability by separating
/// the flow control logic from the actual task implementations.
///
/// Overall, the Sync Flow Handler serves as a valuable tool in managing
/// synchronous task flows and enables developers to design efficient
/// and well-structured synchronous execution paths.
/// {@endtemplate}
class SyncFlow<T> {
  /// {@macro sync-flow}
  SyncFlow()
      : _differedStack = [],
        _isDone = false;

  /// entry point to the SyncFlowHandler
  ///
  /// will receive a [SyncTask] and call it in a try scope
  /// and returns a Record of ([T]? result, [Object]? exception)
  ///
  /// you can use `defer` method (accessible in the [SyncTask] as parameter)
  /// to push methods to run after the main method call
  ///
  /// defer method will receive result and|or exception from last deferred
  /// or the main method itself and act on them then they may or may not modify
  /// the result of the flow
  static ResultSignature<T> handle<T>(
    SyncTask<T> task,
  ) =>
      SyncFlow<T>().deferredCall(task);
  final List<SyncDeferred<T>> _differedStack;
  bool _isDone;
  void _pushToDiffer(SyncDeferred<T> task) => _differedStack.add(task);

  /// will receive a [SyncTask] and call it in a try scope
  /// and returns a Record of ([T]? result, [Object]? exception)
  ///
  /// you can use `defer` method (accessible in the [SyncTask] as parameter)
  /// to push methods to run after the main method call
  ///
  /// defer method will receive result and|or exception from last deferred
  /// or the main method itself and act on them then they may or may not modify
  ResultSignature<T> deferredCall(
    SyncTask<T> task,
  ) {
    if (_isDone) {
      throw Exception('This Flow is already completed');
    }
    ResultSignature<T>? result = (result: null, exception: null);
    try {
      result = task(_pushToDiffer) ?? result;
    } catch (e) {
      result = (result: null, exception: e);
    }

    _isDone = true;
    return _differedStack.reversed.fold<ResultSignature<T>>(
      result,
      (previousValue, element) {
        final deferResult = element(previousValue);
        return previousValue.copyWith(
          result: deferResult?.result,
          exception: deferResult?.exception,
        );
      },
    );
  }
}

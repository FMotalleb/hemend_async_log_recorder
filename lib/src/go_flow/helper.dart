import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/go_flow/async_flow.dart';
import 'package:hemend_async_log_recorder/src/go_flow/sync_flow.dart';

/// This helper method simplifies the usage of the sync flow handler
/// by encapsulating the execution logic and returning the result as a
/// ResultSignature object.
///
/// Developers can easily integrate this method into their code to streamline
/// the implementation of synchronous task flows with the flow handler.
ResultSignature<T> syncFlow<T>(
  SyncTask<T> task,
) =>
    SyncFlow.handle<T>(task);

/// The provided code snippet presents a simple helper method designed to
/// facilitate the usage of a flow handler. This helper method, named asyncFlow,
/// takes an AsyncTask<T> as a parameter and returns an AsyncResultSignature<T>
/// object.
///
/// The purpose of this helper method is to streamline the usage of
/// the flow handler by abstracting away the details of handling and executing
/// the asynchronous task flow. By encapsulating the interaction with
/// the flow handler within the asyncFlow method, developers can utilize a more
/// concise and straightforward syntax.
///
/// Internally, the asyncFlow method utilizes the AsyncFlow.handle<T> method
/// from the AsyncFlow class to execute the provided task.
/// The AsyncFlow.handle<T> method takes the AsyncTask<T> as input and
/// orchestrates the execution of the task flow, managing the scheduling of
/// deferred methods and handling the flow's result.
///
/// By leveraging the asyncFlow helper method, developers can avoid direct
/// interactions with the flow handler and benefit from a more streamlined and
/// readable code structure. The asyncFlow method encapsulates the complexities
/// of the flow handler and provides a simplified interface for utilizing
/// asynchronous task flows.
AsyncResultSignature<T> asyncFlow<T>(
  AsyncTask<T> task,
) =>
    AsyncFlow.handle<T>(task);

/// helper extension for [ResultSignature] record
extension SignatureHelper<T> on ResultSignature<T> {
  /// The copyWith method is used to create a new record with updated result and
  /// exception values. It receives an optional T as the new result value and
  /// an optional Object as the exception value. It returns a new
  /// [ResultSignature] object.
  ///
  /// The copyWith method replaces non-null result and/or exception values over
  /// the current this.result and/or this.exception values. If either result or
  /// exception is null, it returns the current values from the source
  /// [ResultSignature].
  ///
  /// Example usage:
  /// ```dart
  /// final originalResult = ResultSignature<int>(result: 5, exception: null);
  /// final newResult = originalResult.copyWith(result: 10);
  ///  // newResult will have result: 10 and exception: null
  /// final originalResult2 = ResultSignature<String>(
  ///         result: null,
  ///         exception: Exception('Error'),
  ///       );
  /// final newResult2 = originalResult2.copyWith(exception: null);
  /// // newResult2 will have result: null and exception: Exception('Error')
  /// ```
  ResultSignature<T> copyWith({T? result, Object? exception}) {
    return (
      result: result ?? this.result,
      exception: exception ?? this.exception,
    );
  }
}

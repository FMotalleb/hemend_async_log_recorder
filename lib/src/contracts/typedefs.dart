import 'package:hemend_logger/hemend_logger.dart';

/// Adapter for [LogRecordEntity] to json-like [Map]
/// with string keys and dynamic values
typedef RecordSerializer = Adapter<LogRecordEntity, Map<String, dynamic>>;

/// Adapter for [LogRecordEntity] to string
typedef RecordStringify = Adapter<LogRecordEntity, String>;

/// Post request handler that receives the url and the body of the request
/// and returns nothing but a future to complete the request
typedef PostMethod = Future<void> Function(
  String url,
  Map<String, dynamic> data,
);

/// {@template a-result-signature}
/// The result signature refers to the shape or structure of the object that will
///  be returned from the handler in a specific context. It serves as a container
///   for the last result obtained from deferred methods and also holds
///  information about the most recent exception that was thrown within
///  the handler.
///
/// The purpose of the result signature is to encapsulate the outcome of
/// the handler's execution, allowing for the transmission of relevant data and
/// error information. By defining a standardized structure for the result
/// signature, it becomes easier to handle and process the returned object
/// consistently across different components or modules within a system.
///
/// In practice, the result signature typically includes fields or properties
/// that represent the result of the handler's operation and any relevant
/// metadata associated with it. This can include, for example, the success or
/// failure status of the operation, the actual result or output produced, and
/// any additional contextual information or error messages.
///
/// By utilizing a well-defined result signature, developers can establish clear
/// expectations regarding the structure and content of the returned object,
/// enabling better interoperability and error handling in the overall system.
/// This approach promotes code reusability, maintainability, and enhances the
/// overall robustness of the system by providing a standardized interface for
/// communicating the outcome of the handler's execution.
/// {@endtemplate}
typedef AsyncResultSignature<T> = Future<ResultSignature<T>?>;

/// {@template a-deferred-callback}
/// The concept of a deferred callback outlines the behavior and functionality
/// of a method that is executed after a previous deferred operation or
/// the main method itself has completed. This callback method receives
/// the result and/or exception from the preceding deferred operation or
/// the main method and performs specific actions based on this information.
/// It also has the capability to modify the flow's result, depending on
/// the requirements.
///
/// The AsyncDeferred type defines the signature of a deferred callback method.
/// It takes a ResultSignature<T> as input, representing the result and
/// exception from the previous deferred operation or the main method.
/// The callback method can then process this input and return
/// an AsyncResultSignature<T> object or null if no further modifications or
/// actions are necessary.
///
/// The purpose of the deferred callback is to provide a mechanism for handling
/// and reacting to the result or exception of a preceding deferred operation.
/// This allows for additional logic or modifications to be applied before
/// passing the control flow to subsequent steps. The callback method can access
/// and analyze the result and exception data, enabling it to make informed
/// decisions or perform specific operations based on the outcome.
///
/// By utilizing deferred callbacks, developers can introduce dynamic behavior
/// and flexible control flow in asynchronous programming scenarios. The ability
/// to modify the flow's result empowers developers to implement custom error
/// handling, logging, retries, or other post-processing tasks based on
/// the context and requirements of the application.
///
/// Overall, the concept of a deferred callback enhances the extensibility and
/// flexibility of asynchronous programming paradigms by allowing developers to
/// define and control the behavior of methods that follow deferred operations
/// or the main execution flow.
/// {@endtemplate}
typedef AsyncDeferred<T> = AsyncResultSignature<T>? Function(
  ResultSignature<T> result,
);

/// {@template a-task}
/// The concept of a task flow describes the behavior and functionality of an
/// asynchronous method that executes a series of operations in a specific order
/// . The AsyncTask type defines the signature of such a task flow method.
/// It takes a void Function(AsyncDeferred<T>) defer parameter, which enables
/// the method to schedule and execute deferred methods after completing its own
/// tasks.
///
/// Within the task flow method, developers can define the sequence of
/// operations to be performed asynchronously. This can include any combination
/// of computations, I/O operations, or network requests. The task flow method
/// takes control of the execution and ensures that each operation is executed
/// in the defined order.
///
/// The defer function, provided as a parameter to the task flow method, serves
/// as a mechanism to schedule deferred methods. These deferred methods are
/// executed after the task flow method has completed its own tasks. By invoking
/// the defer function and passing an AsyncDeferred<T> callback, developers can
/// schedule additional operations or callbacks to be executed in the subsequent
/// steps of the task flow.
///
/// The purpose of the task flow is to enable developers to orchestrate and
/// control the execution of asynchronous operations in a structured manner.
/// By defining a clear sequence of tasks and utilizing deferred methods,
/// developers can ensure that each operation is executed at the appropriate
/// time and with the necessary dependencies. This promotes maintainability,
/// readability, and better error handling in asynchronous programming scenarios
///
/// In summary, the concept of a task flow provides a structured approach to
/// organizing and executing asynchronous operations. By defining the order of
/// tasks and utilizing the defer function to schedule deferred methods,
/// developers can create more robust and maintainable asynchronous workflows.
/// {@endtemplate}
typedef AsyncTask<T> = AsyncResultSignature<T>? Function(
  void Function(AsyncDeferred<T>) defer,
);

/// {@template result-signature}
/// The `ResultSignature` represents the structure of the object that will be
/// returned from the handler. It contains information about the last result
/// obtained from deferred methods and the most recent exception thrown within
/// the handler.
///
/// The purpose of the `ResultSignature` is to encapsulate the outcome of
/// the handler's execution in a standardized format. It provides a container
/// for the last result obtained from deferred methods, allowing subsequent
/// operations to access and utilize this result. Additionally, it captures
/// the latest exception thrown within the handler, enabling appropriate error
/// handling and reporting.
///
/// The `ResultSignature` typically includes two components:
///
/// 1. `result`: This field holds the last result obtained from deferred methods
/// or the main method itself. It represents the outcome or output of
/// the handler's execution. The type of the `result` can vary based on
/// the specific implementation or context.
///
/// 2. `exception`: This field contains the most recent exception thrown within
/// the handler, if any. It captures any errors or exceptional conditions
/// that occurred during the execution of the handler. The `exception` can be of
/// type `Exception`, `Error`, or any other relevant exception type.
///
/// By using the `ResultSignature` object, developers can pass along the last
/// result and exception information to subsequent components or modules for
/// further processing or handling. This promotes transparency, traceability,
/// and effective error management within the handler's execution flow.
/// {@endtemplate}
typedef ResultSignature<T> = ({T? result, Object? exception});

/// {@template deferred-callback}
/// The concept of a synchronous deferred method defines the behavior and
/// functionality of a method that is scheduled to run synchronously after
/// the completion of a preceding deferred method or the main method itself.
///
/// Synchronous deferred methods receive the result and/or exception from
/// the previous deferred method or the main method as parameters.
/// These inputs provide contextual information that
/// the synchronous deferred method can utilize to make decisions or
/// perform actions. The method can act on the received result and/or exception
/// and has the option to modify the result of the overall flow.
///
/// Similar to asynchronous deferred methods, synchronous deferred methods can
/// perform various tasks based on the received inputs. They may handle errors,
/// perform data transformations, or execute any other relevant operations.
///
/// Synchronous deferred methods provide an opportunity to implement custom
/// logic and fine-tune the behavior of the synchronous task flow.
/// By receiving and acting upon the result and/or exception from preceding
/// steps, developers can create synchronous task flows that are adaptable
/// and customizable to meet specific requirements.
/// {@endtemplate}
typedef SyncDeferred<T> = ResultSignature<T>? Function(ResultSignature<T>?);

/// {@template task}
/// The SyncTask type defines the behavior and structure of a synchronous
/// task flow. It represents a method that will be executed synchronously and
/// receives a defer method from the flow handler as a parameter.
/// The defer method can be used to push a synchronous deferred method to run
/// after the execution of the current task.

/// Within the SyncTask method, developers have the ability to utilize the defer
/// method to schedule and define subsequent synchronous deferred methods.
/// These deferred methods will run after the completion of the current task.
/// They can receive and act upon the result and/or exception from the previous
/// deferred method or the main method, allowing for custom actions and
/// potential modification of the overall result.

/// By leveraging the defer method and synchronous deferred methods, developers
/// can orchestrate a synchronous task flow with specific behaviors and
/// sequential execution. Each task can perform its designated operations and
/// utilize the defer method to schedule subsequent steps.
/// {@endtemplate}
typedef SyncTask<T> = ResultSignature<T>? Function(
  void Function(SyncDeferred<T>) defer,
);

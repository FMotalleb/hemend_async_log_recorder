import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/go_flow/async_flow.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'async_flow_test.mocks.dart';
import 'dummy_task.dart';

@GenerateMocks([DummyAsyncTaskOrder])
void main() {
  // Define some example async tasks for testing
  late AsyncTask<int> dummyTask;
  late DummyAsyncTaskOrder orderedTasks;
  late AsyncTask<int> orderedTask;
  setUp(
    () {
      dummyTask = (defer) async {
        defer((answer) async {
          return (
            result: answer.result! + 1,
            exception: null,
          );
        });
        return (
          result: 1,
          exception: null,
        );
      };

      orderedTasks = MockDummyAsyncTaskOrder();
      when(orderedTasks.t1()).thenAnswer(
        (_) async => (
          result: 1,
          exception: null,
        ),
      );
      when(orderedTasks.t2()).thenAnswer(
        (_) async => (
          result: 2,
          exception: null,
        ),
      );
      when(orderedTasks.t3()).thenAnswer(
        (_) async => (
          result: 3,
          exception: null,
        ),
      );
      when(orderedTasks.d1(any)).thenAnswer(
        (_) async => null,
      );
      when(orderedTasks.d2(any)).thenAnswer(
        (_) async => null,
      );
      when(orderedTasks.d3(any)).thenAnswer(
        (_) async => null,
      );
      orderedTask = (defer) {
        orderedTasks.t1();
        defer(
          (r) async => orderedTasks.d1(r),
        );
        orderedTasks.t2();
        defer(
          (r) async => orderedTasks.d2(r),
        );
        orderedTasks.t3();
        defer(
          (r) async => orderedTasks.d3(r),
        );
        return null;
      };
    },
  );

  test(
    'AsyncFlow handles deferred tasks',
    () async {
      final result = AsyncFlow.handle(dummyTask);
      expect(
        await result.then((value) => value?.result),
        equals(2),
      );
      expect(
        await result.then((value) => value?.exception),
        equals(null),
      );
    },
  );
  test(
    'AsyncFlow handles deferred tasks in correct order',
    () async {
      await AsyncFlow.handle(orderedTask);

      verifyInOrder([
        orderedTasks.t1(),
        orderedTasks.t2(),
        orderedTasks.t3(),
        orderedTasks.d3(any),
        orderedTasks.d2(any),
        orderedTasks.d1(any),
      ]);
    },
  );

  test(
    'AsyncFlow throws exception when flow is already completed',
    () async {
      final flow = AsyncFlow<int>();
      final firstInvocation = flow.deferredCall(dummyTask);
      await firstInvocation;
      final secondInvocation = flow.deferredCall(dummyTask);
      await expectLater(
        secondInvocation,
        throwsException,
      );
    },
  );
}

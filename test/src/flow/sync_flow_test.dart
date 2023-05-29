import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/go_flow/sync_flow.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'dummy_task.dart';
import 'sync_flow_test.mocks.dart';

@GenerateMocks([DummySyncTaskOrder])
void main() {
  // Define some example async tasks for testing
  late SyncTask<int> dummyTask;
  late DummySyncTaskOrder orderedTasks;
  late SyncTask<int> orderedTask;
  setUp(
    () {
      dummyTask = (defer) {
        defer((answer) {
          return (
            result: answer!.result! + 1,
            exception: null,
          );
        });
        return (
          result: 1,
          exception: null,
        );
      };

      orderedTasks = MockDummySyncTaskOrder();
      when(orderedTasks.t1()).thenReturn(
        (
          result: 1,
          exception: null,
        ),
      );
      when(orderedTasks.t2()).thenReturn(
        (
          result: 2,
          exception: null,
        ),
      );
      when(orderedTasks.t3()).thenReturn(
        (
          result: 3,
          exception: null,
        ),
      );
      when(orderedTasks.d1(any)).thenReturn(
        null,
      );
      when(orderedTasks.d2(any)).thenReturn(
        null,
      );
      when(orderedTasks.d3(any)).thenReturn(
        null,
      );
      orderedTask = (defer) {
        orderedTasks.t1();
        defer(
          (r) => orderedTasks.d1(r),
        );
        orderedTasks.t2();
        defer(
          (r) => orderedTasks.d2(r),
        );
        orderedTasks.t3();
        defer(
          (r) => orderedTasks.d3(r),
        );
        return null;
      };
    },
  );

  test(
    'SyncFlow handles deferred tasks',
    () {
      final result = SyncFlow.handle(dummyTask);
      expect(
        result.result,
        equals(2),
      );
      expect(
        result.exception,
        equals(null),
      );
    },
  );
  test(
    'SyncFlow handles deferred tasks in correct order',
    () {
      SyncFlow.handle(orderedTask);

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
    'SyncFlow throws exception when flow is already completed',
    () {
      final flow = SyncFlow<int>();
      // ignore: cascade_invocations
      flow.deferredCall(dummyTask);
      expect(
        () => flow.deferredCall(dummyTask),
        throwsException,
      );
    },
  );
}

import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';
import 'package:hemend_async_log_recorder/src/go_flow/helper.dart';
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
  late DummySyncTaskOrder orderedFailedTasks;
  late SyncTask<int> orderedTask;
  late SyncTask<int> orderedFailedTask;
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

      orderedFailedTasks = MockDummySyncTaskOrder();
      when(orderedFailedTasks.t1()).thenReturn(
        (
          result: 1,
          exception: null,
        ),
      );
      when(orderedFailedTasks.t2()).thenThrow(
        Exception(),
      );
      when(orderedFailedTasks.t3()).thenThrow(
        Exception(),
      );
      when(orderedFailedTasks.d1(any)).thenReturn(
        null,
      );
      when(orderedFailedTasks.d2(any)).thenReturn(
        null,
      );
      when(orderedFailedTasks.d3(any)).thenReturn(
        null,
      );
      orderedFailedTask = (defer) {
        orderedFailedTasks.t1();
        defer(
          (r) => orderedFailedTasks.d1(r),
        );
        orderedFailedTasks.t2();
        defer(
          (r) => orderedFailedTasks.d2(r),
        );
        orderedFailedTasks.t3();
        defer(
          (r) => orderedFailedTasks.d3(r),
        );
        return null;
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
    'helper does the job',
    () async {
      final result = syncFlow(dummyTask);
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

      SyncFlow.handle(orderedFailedTask);

      verifyInOrder(
        [
          orderedFailedTasks.t1(),
          // in this test t2 has thrown an exception so it get called once
          orderedFailedTasks.t2(),
          orderedFailedTasks.d1(any),
        ],
      );

      verifyNever(
        orderedFailedTasks.t3(),
      );

      verifyNever(
        orderedFailedTasks.d2(any),
      );

      verifyNever(
        orderedFailedTasks.d3(any),
      );
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

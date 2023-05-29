import 'package:hemend_async_log_recorder/src/contracts/typedefs.dart';

abstract class DummyAsyncTaskOrder {
  AsyncResultSignature<int>? t1();
  AsyncResultSignature<int>? t2();
  AsyncResultSignature<int>? t3();
  AsyncResultSignature<int>? d1(ResultSignature<int>? result);
  AsyncResultSignature<int>? d2(ResultSignature<int>? result);
  AsyncResultSignature<int>? d3(ResultSignature<int>? result);
}

abstract class DummySyncTaskOrder {
  ResultSignature<int>? t1();
  ResultSignature<int>? t2();
  ResultSignature<int>? t3();
  ResultSignature<int>? d1(ResultSignature<int>? result);
  ResultSignature<int>? d2(ResultSignature<int>? result);
  ResultSignature<int>? d3(ResultSignature<int>? result);
}

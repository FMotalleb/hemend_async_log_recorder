## 0.1.13+1

* (feat): `Allocate` flag on FileSink
  * create file on absence

* (revert-v0.1.11+1): `FileSink` now does not create file by its own. (you have to pass allocate=true flag)

## 0.1.11+1

* (fix): missing file exception in linux

## 0.1.10+1

* (fix): concurrency bug in post request

## 0.1.9+1

* (minor): exposing `ILogSync` contract for further extendability

## 0.1.8+1

* (major): websocket recorder disabled for now
* (tests): go_flow

## 0.1.6+1

* (tests): io file tests
* (fix): changed `ILogSink.close()` return type to `Future<void>`
* (feat): added `ILogSink.isClosed` property

## 0.1.5+1

* (minor): minor analysis changes

## 0.1.4+2

* (feat): web socket log recorder

## 0.1.3+1

* (feat): deferred execution flow like go
* (minor): closing http.Client() and File's IoSink() using deferred flow

## 0.1.2+1

* (dependency) migrated to hemend_logger 0.1.4+1

## 0.1.1+1

* (minor) formatting
* (fix) dart 3 compatibility issue (extending `Sink` interface)

## 0.1.0+1

* (init) initial release

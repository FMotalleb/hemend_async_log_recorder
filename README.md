# Hemend Async Logger

[![License: MIT][license_badge]][license_link]
[![pub package](https://img.shields.io/pub/v/hemend_async_log_recorder?color=blue)](https://pub.dev/packages/hemend_async_log_recorder)
[![pub points](https://img.shields.io/pub/points/hemend_async_log_recorder)](https://pub.dev/packages/hemend_async_log_recorder)
[![code_count](https://img.shields.io/github/languages/top/fmotalleb/hemend_async_log_recorder?color=green&label=pure%20dart)](https://pub.dev/packages/hemend_async_log_recorder)
[![code size](https://img.shields.io/github/languages/code-size/fmotalleb/hemend_async_log_recorder)](https://github.com/FMotalleb/hemend_async_log_recorder)
[![git repo](https://img.shields.io/pub/v/hemend_async_log_recorder?color=blue&label=git)](https://github.com/FMotalleb/hemend_async_log_recorder)

A Very Good Project created by Very Good CLI.

## Installation 💻

**❗ In order to start using Hemend Async Logger you must have the [Dart SDK][dart_install_link] installed on your machine.**

Add `hemend_async_log_recorder` to your `pubspec.yaml`:

```yaml
dependencies:
  hemend_async_log_recorder: <latest-version>
```

Install it:

```sh
dart pub get
```

---

## Usage

This software package extends [`hemend_logger`](https://pub.dev/packages/hemend_logger) package's capabilities to use asynchronously logging functions like recording logs using a post request, websocket, file, etc.

currently shipped with internal support for post request and file logging functionality.

---

## Continuous Integration 🤖

Hemend Async Logger comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows

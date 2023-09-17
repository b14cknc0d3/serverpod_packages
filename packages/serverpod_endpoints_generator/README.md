# Serverpod Endpoints Generator

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Endpoint generator for serverpod

## Installation 💻



Install via `dart pub add`:

```sh
dart pub add serverpod_endpoints_annotation
dart pub add serverpod_endpoints_generator --dev
```

---
###
to generate an endpoint you must create a dart file eg `user.dart` under `lib/src/endpoints/` dir


### STEP1

```dart
//user.dart
import 'package:serverpod_endpoints_annotation/serverpod_endpoints_annotation.dart';

@EndpointGen(model:User)
class UserModelAdmin extends UserAdmin{
//
}

```
### STEP2
run build runner command
```dart run build_runner build -d```

then `user.gen_endpoint.dart` will be generated



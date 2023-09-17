// ignore_for_file: prefer_const_constructors

import 'package:generator_test/generator_test.dart';
import 'package:serverpod_endpoints_generator/serverpod_endpoints_generator.dart';
import 'package:test/test.dart';

void main() {
  group('endpoint gen tests', () {
    test('successfully generates', () async {
      final generator = SuccessGenerator.fromBuilder(
        'user',
        endpointGenerator,
        compareWithFixture: false,
      );
      await generator.test();
    });
  });
}

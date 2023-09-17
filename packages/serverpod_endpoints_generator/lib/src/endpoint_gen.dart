// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:serverpod_endpoints_generator/src/method_gen.dart';

///helper for endpoint generations
class EndpointGenerator {
  final String modelName;
  final String queries;
  final bool requiredLogin;
  final bool isSuperUser;
  EndpointGenerator({
    required this.modelName,
    required this.queries,
    required this.requiredLogin,
    required this.isSuperUser,
  });
  static const String baseEndpoint = 'BaseEndpoint';
  static const String importProtocol =
      'import "/src/generated/protocol.dart";\n';
  static const String importServerpod =
      'import "package:serverpod/server.dart";\n';
  static const String importAdminEp =
      'import "package:serverpod_endpoints_annotation/serverpod_endpoints_annotation.dart";\n';

  final _dartfmt = DartFormatter();

  ///generate endpoint
  String generate() {
    final methodGen = MethodGen(
      modelName: modelName,
      queries: queries,
      requireLogin: requiredLogin,
      isSuperUser: isSuperUser,
    );

    final endPoint = Class(
      (c) => c
        ..name = '${modelName}Endpoint'
        ..extend = refer('Endpoint', importServerpod) //serverpod endpoint
        ..implements.addAll([
          refer('$baseEndpoint<Session,$modelName>', importAdminEp),
        ])
        ..methods.addAll(methodGen.generate()),
    );
    final emitter = DartEmitter();
    return importAdminEp +
        importServerpod +
        importProtocol +
        _dartfmt.format('${endPoint.accept(emitter)}');
  }
}

void main(List<String> args) {
  print(
    EndpointGenerator(
      modelName: 'Model',
      queries: 't.id.equals(1);',
      requiredLogin: true,
      isSuperUser: true,
    ).generate(),
  );
}

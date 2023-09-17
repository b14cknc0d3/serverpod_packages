import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

import 'package:serverpod_endpoints_annotation/serverpod_endpoints_annotation.dart';
import 'package:serverpod_endpoints_generator/src/endpoint_gen.dart';
import 'package:source_gen/source_gen.dart';

/// {@template serverpod_endpoints_generator}
/// Endpoint generator for serverpod
/// {@endtemplate}
class ServerpodEndpointGenerator extends GeneratorForAnnotation<EndpointGen> {
  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement || element is EnumElement) {
      throw InvalidGenerationSourceError(
        'Generator cannot target ${element.runtimeType}',
        element: element,
      );
    }
    final model = annotation.read('model').typeValue;
    final requiredLogin = annotation.read('requiredLogin').boolValue;
    // final searchQueryBuilder = annotation.read('searchQueryBuilder').listValue;
    final isSuperUserOnly = annotation.read('isSuperUser').boolValue;

    return EndpointGenerator(
      modelName: model.element!.name!,
      requiredLogin: requiredLogin,
      isSuperUser: isSuperUserOnly,
      queries: 't.id.equals(1)', //TODO: implement searchQueryBuilder
    ).generate();
  }

  /// {@macro serverpod_endpoints_generator}
}

///entry point
Builder endpointGenerator(BuilderOptions options) => LibraryBuilder(
      ServerpodEndpointGenerator(),
      generatedExtension: '.gen_endpoint.dart',
      allowSyntaxErrors: true,
    );

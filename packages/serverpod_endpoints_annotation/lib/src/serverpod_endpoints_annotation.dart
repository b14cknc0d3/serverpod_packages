// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:meta/meta_meta.dart';

/// {@template serverpod_endpoints_annotation}
/// Serverpod Endpoint annotation package for endpoints generation
/// {@endtemplate}
@Target({TargetKind.classType})
class EndpointGen {
  /// model to generate endpoint
  final Type model;

  ///endpoint require login or not
  final bool requiredLogin;

  ///set endpoints scope to super admin
  final bool isSuperUser;

  const EndpointGen({
    required this.model,
    this.requiredLogin = true,
    this.isSuperUser = true,
  });
}

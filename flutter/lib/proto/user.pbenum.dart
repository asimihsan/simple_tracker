///
//  Generated code. Do not modify.
//  source: user.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class CreateUserErrorReason extends $pb.ProtobufEnum {
  static const CreateUserErrorReason CREATE_USER_ERROR_REASON_NO_ERROR = CreateUserErrorReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CREATE_USER_ERROR_REASON_NO_ERROR');
  static const CreateUserErrorReason USER_ALREADY_EXISTS = CreateUserErrorReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER_ALREADY_EXISTS');
  static const CreateUserErrorReason CREATE_USER_ERROR_REASON_INTERNAL_SERVER_ERROR = CreateUserErrorReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CREATE_USER_ERROR_REASON_INTERNAL_SERVER_ERROR');

  static const $core.List<CreateUserErrorReason> values = <CreateUserErrorReason> [
    CREATE_USER_ERROR_REASON_NO_ERROR,
    USER_ALREADY_EXISTS,
    CREATE_USER_ERROR_REASON_INTERNAL_SERVER_ERROR,
  ];

  static final $core.Map<$core.int, CreateUserErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CreateUserErrorReason? valueOf($core.int value) => _byValue[value];

  const CreateUserErrorReason._($core.int v, $core.String n) : super(v, n);
}

class LoginUserErrorReason extends $pb.ProtobufEnum {
  static const LoginUserErrorReason LOGIN_USER_ERROR_REASON_NO_ERROR = LoginUserErrorReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LOGIN_USER_ERROR_REASON_NO_ERROR');
  static const LoginUserErrorReason USER_MISSING_OR_PASSWORD_INCORRECT = LoginUserErrorReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER_MISSING_OR_PASSWORD_INCORRECT');
  static const LoginUserErrorReason LOGIN_USER_ERROR_REASON_INTERNAL_SERVER_ERROR = LoginUserErrorReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LOGIN_USER_ERROR_REASON_INTERNAL_SERVER_ERROR');

  static const $core.List<LoginUserErrorReason> values = <LoginUserErrorReason> [
    LOGIN_USER_ERROR_REASON_NO_ERROR,
    USER_MISSING_OR_PASSWORD_INCORRECT,
    LOGIN_USER_ERROR_REASON_INTERNAL_SERVER_ERROR,
  ];

  static final $core.Map<$core.int, LoginUserErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LoginUserErrorReason? valueOf($core.int value) => _byValue[value];

  const LoginUserErrorReason._($core.int v, $core.String n) : super(v, n);
}


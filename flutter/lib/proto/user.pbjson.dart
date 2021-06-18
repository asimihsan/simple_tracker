///
//  Generated code. Do not modify.
//  source: user.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use createUserErrorReasonDescriptor instead')
const CreateUserErrorReason$json = const {
  '1': 'CreateUserErrorReason',
  '2': const [
    const {'1': 'CREATE_USER_ERROR_REASON_NO_ERROR', '2': 0},
    const {'1': 'USER_ALREADY_EXISTS', '2': 1},
    const {'1': 'CREATE_USER_ERROR_REASON_INTERNAL_SERVER_ERROR', '2': 2},
  ],
};

/// Descriptor for `CreateUserErrorReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List createUserErrorReasonDescriptor = $convert.base64Decode('ChVDcmVhdGVVc2VyRXJyb3JSZWFzb24SJQohQ1JFQVRFX1VTRVJfRVJST1JfUkVBU09OX05PX0VSUk9SEAASFwoTVVNFUl9BTFJFQURZX0VYSVNUUxABEjIKLkNSRUFURV9VU0VSX0VSUk9SX1JFQVNPTl9JTlRFUk5BTF9TRVJWRVJfRVJST1IQAg==');
@$core.Deprecated('Use loginUserErrorReasonDescriptor instead')
const LoginUserErrorReason$json = const {
  '1': 'LoginUserErrorReason',
  '2': const [
    const {'1': 'LOGIN_USER_ERROR_REASON_NO_ERROR', '2': 0},
    const {'1': 'USER_MISSING_OR_PASSWORD_INCORRECT', '2': 1},
    const {'1': 'LOGIN_USER_ERROR_REASON_INTERNAL_SERVER_ERROR', '2': 2},
  ],
};

/// Descriptor for `LoginUserErrorReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List loginUserErrorReasonDescriptor = $convert.base64Decode('ChRMb2dpblVzZXJFcnJvclJlYXNvbhIkCiBMT0dJTl9VU0VSX0VSUk9SX1JFQVNPTl9OT19FUlJPUhAAEiYKIlVTRVJfTUlTU0lOR19PUl9QQVNTV09SRF9JTkNPUlJFQ1QQARIxCi1MT0dJTl9VU0VSX0VSUk9SX1JFQVNPTl9JTlRFUk5BTF9TRVJWRVJfRVJST1IQAg==');
@$core.Deprecated('Use createUserRequestDescriptor instead')
const CreateUserRequest$json = const {
  '1': 'CreateUserRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `CreateUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserRequestDescriptor = $convert.base64Decode('ChFDcmVhdGVVc2VyUmVxdWVzdBIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWUSGgoIcGFzc3dvcmQYAiABKAlSCHBhc3N3b3Jk');
@$core.Deprecated('Use createUserResponseDescriptor instead')
const CreateUserResponse$json = const {
  '1': 'CreateUserResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'error_reason', '3': 2, '4': 1, '5': 14, '6': '.simpletracker.CreateUserErrorReason', '10': 'errorReason'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'user_id', '3': 4, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `CreateUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createUserResponseDescriptor = $convert.base64Decode('ChJDcmVhdGVVc2VyUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxJHCgxlcnJvcl9yZWFzb24YAiABKA4yJC5zaW1wbGV0cmFja2VyLkNyZWF0ZVVzZXJFcnJvclJlYXNvblILZXJyb3JSZWFzb24SHQoKc2Vzc2lvbl9pZBgDIAEoCVIJc2Vzc2lvbklkEhcKB3VzZXJfaWQYBCABKAlSBnVzZXJJZA==');
@$core.Deprecated('Use loginUserRequestDescriptor instead')
const LoginUserRequest$json = const {
  '1': 'LoginUserRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginUserRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginUserRequestDescriptor = $convert.base64Decode('ChBMb2dpblVzZXJSZXF1ZXN0EhoKCHVzZXJuYW1lGAEgASgJUgh1c2VybmFtZRIaCghwYXNzd29yZBgCIAEoCVIIcGFzc3dvcmQ=');
@$core.Deprecated('Use loginUserResponseDescriptor instead')
const LoginUserResponse$json = const {
  '1': 'LoginUserResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'error_reason', '3': 2, '4': 1, '5': 14, '6': '.simpletracker.LoginUserErrorReason', '10': 'errorReason'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'user_id', '3': 4, '4': 1, '5': 9, '10': 'userId'},
  ],
};

/// Descriptor for `LoginUserResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginUserResponseDescriptor = $convert.base64Decode('ChFMb2dpblVzZXJSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEkYKDGVycm9yX3JlYXNvbhgCIAEoDjIjLnNpbXBsZXRyYWNrZXIuTG9naW5Vc2VyRXJyb3JSZWFzb25SC2Vycm9yUmVhc29uEh0KCnNlc3Npb25faWQYAyABKAlSCXNlc3Npb25JZBIXCgd1c2VyX2lkGAQgASgJUgZ1c2VySWQ=');

///
//  Generated code. Do not modify.
//  source: user.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const CreateUserErrorReason$json = const {
  '1': 'CreateUserErrorReason',
  '2': const [
    const {'1': 'USER_ALREADY_EXISTS', '2': 0},
    const {'1': 'INTERNAL_SERVER_ERROR', '2': 1},
  ],
};

const CreateUserRequest$json = const {
  '1': 'CreateUserRequest',
  '2': const [
    const {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    const {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

const CreateUserResponse$json = const {
  '1': 'CreateUserResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'error_reason', '3': 2, '4': 1, '5': 14, '6': '.simpletracker.CreateUserErrorReason', '10': 'errorReason'},
  ],
};


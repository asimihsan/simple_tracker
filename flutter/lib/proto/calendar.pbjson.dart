///
//  Generated code. Do not modify.
//  source: calendar.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const ListCalendarsRequest$json = const {
  '1': 'ListCalendarsRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'max_results', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Int32Value', '10': 'maxResults'},
    const {'1': 'next_token', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.BytesValue', '10': 'nextToken'},
  ],
};

const ListCalendarsRequestNextToken$json = const {
  '1': 'ListCalendarsRequestNextToken',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'next_token_inner', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.StringValue', '10': 'nextTokenInner'},
    const {'1': 'expiryEpochSeconds', '3': 5, '4': 1, '5': 5, '10': 'expiryEpochSeconds'},
  ],
};

const ListCalendarsResponse$json = const {
  '1': 'ListCalendarsResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'calendarSummaries', '3': 2, '4': 3, '5': 11, '6': '.simpletracker.CalendarSummary', '10': 'calendarSummaries'},
    const {'1': 'next_token', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.BytesValue', '10': 'nextToken'},
  ],
};

const CalendarSummary$json = const {
  '1': 'CalendarSummary',
  '2': const [
    const {'1': 'formatVersion', '3': 1, '4': 1, '5': 5, '10': 'formatVersion'},
    const {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'color', '3': 4, '4': 1, '5': 9, '10': 'color'},
    const {'1': 'version', '3': 5, '4': 1, '5': 5, '10': 'version'},
  ],
};

const CalendarDetail$json = const {
  '1': 'CalendarDetail',
  '2': const [
    const {'1': 'summary', '3': 1, '4': 1, '5': 11, '6': '.simpletracker.CalendarSummary', '10': 'summary'},
    const {'1': 'highlightedDays', '3': 2, '4': 3, '5': 9, '10': 'highlightedDays'},
  ],
};


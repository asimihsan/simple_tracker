///
//  Generated code. Do not modify.
//  source: calendar.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class ListCalendarsErrorReason extends $pb.ProtobufEnum {
  static const ListCalendarsErrorReason LIST_CALENDARS_ERROR_REASON_NO_ERROR = ListCalendarsErrorReason._(0, 'LIST_CALENDARS_ERROR_REASON_NO_ERROR');
  static const ListCalendarsErrorReason LIST_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR = ListCalendarsErrorReason._(1, 'LIST_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR');

  static const $core.List<ListCalendarsErrorReason> values = <ListCalendarsErrorReason> [
    LIST_CALENDARS_ERROR_REASON_NO_ERROR,
    LIST_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR,
  ];

  static final $core.Map<$core.int, ListCalendarsErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ListCalendarsErrorReason valueOf($core.int value) => _byValue[value];

  const ListCalendarsErrorReason._($core.int v, $core.String n) : super(v, n);
}


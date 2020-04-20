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
  static const ListCalendarsErrorReason LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR = ListCalendarsErrorReason._(2, 'LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR');

  static const $core.List<ListCalendarsErrorReason> values = <ListCalendarsErrorReason> [
    LIST_CALENDARS_ERROR_REASON_NO_ERROR,
    LIST_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR,
    LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR,
  ];

  static final $core.Map<$core.int, ListCalendarsErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ListCalendarsErrorReason valueOf($core.int value) => _byValue[value];

  const ListCalendarsErrorReason._($core.int v, $core.String n) : super(v, n);
}

class CreateCalendarErrorReason extends $pb.ProtobufEnum {
  static const CreateCalendarErrorReason CREATE_CALENDAR_ERROR_REASON_NO_ERROR = CreateCalendarErrorReason._(0, 'CREATE_CALENDAR_ERROR_REASON_NO_ERROR');
  static const CreateCalendarErrorReason CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR = CreateCalendarErrorReason._(1, 'CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR');
  static const CreateCalendarErrorReason CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR = CreateCalendarErrorReason._(2, 'CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR');

  static const $core.List<CreateCalendarErrorReason> values = <CreateCalendarErrorReason> [
    CREATE_CALENDAR_ERROR_REASON_NO_ERROR,
    CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR,
    CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR,
  ];

  static final $core.Map<$core.int, CreateCalendarErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CreateCalendarErrorReason valueOf($core.int value) => _byValue[value];

  const CreateCalendarErrorReason._($core.int v, $core.String n) : super(v, n);
}

class GetCalendarsErrorReason extends $pb.ProtobufEnum {
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_NO_ERROR = GetCalendarsErrorReason._(0, 'GET_CALENDARS_ERROR_REASON_NO_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR = GetCalendarsErrorReason._(1, 'GET_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR = GetCalendarsErrorReason._(2, 'GET_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR = GetCalendarsErrorReason._(3, 'GET_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR = GetCalendarsErrorReason._(4, 'GET_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR = GetCalendarsErrorReason._(5, 'GET_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR');

  static const $core.List<GetCalendarsErrorReason> values = <GetCalendarsErrorReason> [
    GET_CALENDARS_ERROR_REASON_NO_ERROR,
    GET_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR,
    GET_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR,
    GET_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR,
    GET_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR,
    GET_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR,
  ];

  static final $core.Map<$core.int, GetCalendarsErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GetCalendarsErrorReason valueOf($core.int value) => _byValue[value];

  const GetCalendarsErrorReason._($core.int v, $core.String n) : super(v, n);
}


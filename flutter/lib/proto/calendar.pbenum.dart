///
//  Generated code. Do not modify.
//  source: calendar.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class ListCalendarsErrorReason extends $pb.ProtobufEnum {
  static const ListCalendarsErrorReason LIST_CALENDARS_ERROR_REASON_NO_ERROR = ListCalendarsErrorReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LIST_CALENDARS_ERROR_REASON_NO_ERROR');
  static const ListCalendarsErrorReason LIST_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR = ListCalendarsErrorReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LIST_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR');
  static const ListCalendarsErrorReason LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR = ListCalendarsErrorReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR');

  static const $core.List<ListCalendarsErrorReason> values = <ListCalendarsErrorReason> [
    LIST_CALENDARS_ERROR_REASON_NO_ERROR,
    LIST_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR,
    LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR,
  ];

  static final $core.Map<$core.int, ListCalendarsErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ListCalendarsErrorReason? valueOf($core.int value) => _byValue[value];

  const ListCalendarsErrorReason._($core.int v, $core.String n) : super(v, n);
}

class CreateCalendarErrorReason extends $pb.ProtobufEnum {
  static const CreateCalendarErrorReason CREATE_CALENDAR_ERROR_REASON_NO_ERROR = CreateCalendarErrorReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CREATE_CALENDAR_ERROR_REASON_NO_ERROR');
  static const CreateCalendarErrorReason CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR = CreateCalendarErrorReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR');
  static const CreateCalendarErrorReason CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR = CreateCalendarErrorReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR');

  static const $core.List<CreateCalendarErrorReason> values = <CreateCalendarErrorReason> [
    CREATE_CALENDAR_ERROR_REASON_NO_ERROR,
    CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR,
    CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR,
  ];

  static final $core.Map<$core.int, CreateCalendarErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CreateCalendarErrorReason? valueOf($core.int value) => _byValue[value];

  const CreateCalendarErrorReason._($core.int v, $core.String n) : super(v, n);
}

class GetCalendarsErrorReason extends $pb.ProtobufEnum {
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_NO_ERROR = GetCalendarsErrorReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GET_CALENDARS_ERROR_REASON_NO_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR = GetCalendarsErrorReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GET_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR = GetCalendarsErrorReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GET_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR = GetCalendarsErrorReason._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GET_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR = GetCalendarsErrorReason._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GET_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR');
  static const GetCalendarsErrorReason GET_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR = GetCalendarsErrorReason._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'GET_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR');

  static const $core.List<GetCalendarsErrorReason> values = <GetCalendarsErrorReason> [
    GET_CALENDARS_ERROR_REASON_NO_ERROR,
    GET_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR,
    GET_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR,
    GET_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR,
    GET_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR,
    GET_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR,
  ];

  static final $core.Map<$core.int, GetCalendarsErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static GetCalendarsErrorReason? valueOf($core.int value) => _byValue[value];

  const GetCalendarsErrorReason._($core.int v, $core.String n) : super(v, n);
}

class UpdateCalendarActionType extends $pb.ProtobufEnum {
  static const UpdateCalendarActionType UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME = UpdateCalendarActionType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME');
  static const UpdateCalendarActionType UPDATE_CALENDAR_ACTION_TYPE_CHANGE_COLOR = UpdateCalendarActionType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDAR_ACTION_TYPE_CHANGE_COLOR');
  static const UpdateCalendarActionType UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME_AND_COLOR = UpdateCalendarActionType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME_AND_COLOR');
  static const UpdateCalendarActionType UPDATE_CALENDAR_ACTION_TYPE_ADD_HIGHLIGHTED_DAY = UpdateCalendarActionType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDAR_ACTION_TYPE_ADD_HIGHLIGHTED_DAY');
  static const UpdateCalendarActionType UPDATE_CALENDAR_ACTION_TYPE_REMOVE_HIGHLIGHTED_DAY = UpdateCalendarActionType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDAR_ACTION_TYPE_REMOVE_HIGHLIGHTED_DAY');

  static const $core.List<UpdateCalendarActionType> values = <UpdateCalendarActionType> [
    UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME,
    UPDATE_CALENDAR_ACTION_TYPE_CHANGE_COLOR,
    UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME_AND_COLOR,
    UPDATE_CALENDAR_ACTION_TYPE_ADD_HIGHLIGHTED_DAY,
    UPDATE_CALENDAR_ACTION_TYPE_REMOVE_HIGHLIGHTED_DAY,
  ];

  static final $core.Map<$core.int, UpdateCalendarActionType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UpdateCalendarActionType? valueOf($core.int value) => _byValue[value];

  const UpdateCalendarActionType._($core.int v, $core.String n) : super(v, n);
}

class UpdateCalendarsErrorReason extends $pb.ProtobufEnum {
  static const UpdateCalendarsErrorReason UPDATE_CALENDARS_ERROR_REASON_NO_ERROR = UpdateCalendarsErrorReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDARS_ERROR_REASON_NO_ERROR');
  static const UpdateCalendarsErrorReason UPDATE_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR = UpdateCalendarsErrorReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR');
  static const UpdateCalendarsErrorReason UPDATE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR = UpdateCalendarsErrorReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR');
  static const UpdateCalendarsErrorReason UPDATE_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR = UpdateCalendarsErrorReason._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR');
  static const UpdateCalendarsErrorReason UPDATE_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR = UpdateCalendarsErrorReason._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR');
  static const UpdateCalendarsErrorReason UPDATE_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR = UpdateCalendarsErrorReason._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'UPDATE_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR');

  static const $core.List<UpdateCalendarsErrorReason> values = <UpdateCalendarsErrorReason> [
    UPDATE_CALENDARS_ERROR_REASON_NO_ERROR,
    UPDATE_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR,
    UPDATE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR,
    UPDATE_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR,
    UPDATE_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR,
    UPDATE_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR,
  ];

  static final $core.Map<$core.int, UpdateCalendarsErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UpdateCalendarsErrorReason? valueOf($core.int value) => _byValue[value];

  const UpdateCalendarsErrorReason._($core.int v, $core.String n) : super(v, n);
}

class DeleteCalendarErrorReason extends $pb.ProtobufEnum {
  static const DeleteCalendarErrorReason DELETE_CALENDARS_ERROR_REASON_NO_ERROR = DeleteCalendarErrorReason._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DELETE_CALENDARS_ERROR_REASON_NO_ERROR');
  static const DeleteCalendarErrorReason DELETE_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR = DeleteCalendarErrorReason._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DELETE_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR');
  static const DeleteCalendarErrorReason DELETE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR = DeleteCalendarErrorReason._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DELETE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR');
  static const DeleteCalendarErrorReason DELETE_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR = DeleteCalendarErrorReason._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DELETE_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR');
  static const DeleteCalendarErrorReason DELETE_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR = DeleteCalendarErrorReason._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DELETE_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR');

  static const $core.List<DeleteCalendarErrorReason> values = <DeleteCalendarErrorReason> [
    DELETE_CALENDARS_ERROR_REASON_NO_ERROR,
    DELETE_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR,
    DELETE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR,
    DELETE_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR,
    DELETE_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR,
  ];

  static final $core.Map<$core.int, DeleteCalendarErrorReason> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DeleteCalendarErrorReason? valueOf($core.int value) => _byValue[value];

  const DeleteCalendarErrorReason._($core.int v, $core.String n) : super(v, n);
}


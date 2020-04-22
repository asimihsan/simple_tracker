///
//  Generated code. Do not modify.
//  source: calendar.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const ListCalendarsErrorReason$json = const {
  '1': 'ListCalendarsErrorReason',
  '2': const [
    const {'1': 'LIST_CALENDARS_ERROR_REASON_NO_ERROR', '2': 0},
    const {'1': 'LIST_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR', '2': 1},
    const {'1': 'LIST_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR', '2': 2},
  ],
};

const CreateCalendarErrorReason$json = const {
  '1': 'CreateCalendarErrorReason',
  '2': const [
    const {'1': 'CREATE_CALENDAR_ERROR_REASON_NO_ERROR', '2': 0},
    const {'1': 'CREATE_CALENDAR_ERROR_REASON_INTERNAL_SERVER_ERROR', '2': 1},
    const {'1': 'CREATE_CALENDAR_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR', '2': 2},
  ],
};

const GetCalendarsErrorReason$json = const {
  '1': 'GetCalendarsErrorReason',
  '2': const [
    const {'1': 'GET_CALENDARS_ERROR_REASON_NO_ERROR', '2': 0},
    const {'1': 'GET_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR', '2': 1},
    const {'1': 'GET_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR', '2': 2},
    const {'1': 'GET_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR', '2': 3},
    const {'1': 'GET_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR', '2': 4},
    const {'1': 'GET_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR', '2': 5},
  ],
};

const UpdateCalendarActionType$json = const {
  '1': 'UpdateCalendarActionType',
  '2': const [
    const {'1': 'UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME', '2': 0},
    const {'1': 'UPDATE_CALENDAR_ACTION_TYPE_CHANGE_COLOR', '2': 1},
    const {'1': 'UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME_AND_COLOR', '2': 2},
    const {'1': 'UPDATE_CALENDAR_ACTION_TYPE_ADD_HIGHLIGHTED_DAY', '2': 3},
    const {'1': 'UPDATE_CALENDAR_ACTION_TYPE_REMOVE_HIGHLIGHTED_DAY', '2': 4},
  ],
};

const UpdateCalendarsErrorReason$json = const {
  '1': 'UpdateCalendarsErrorReason',
  '2': const [
    const {'1': 'UPDATE_CALENDARS_ERROR_REASON_NO_ERROR', '2': 0},
    const {'1': 'UPDATE_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR', '2': 1},
    const {'1': 'UPDATE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR', '2': 2},
    const {'1': 'UPDATE_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR', '2': 3},
    const {'1': 'UPDATE_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR', '2': 4},
    const {'1': 'UPDATE_CALENDARS_ERROR_REASON_TOO_MANY_CALENDARS_ERROR', '2': 5},
  ],
};

const DeleteCalendarErrorReason$json = const {
  '1': 'DeleteCalendarErrorReason',
  '2': const [
    const {'1': 'DELETE_CALENDARS_ERROR_REASON_NO_ERROR', '2': 0},
    const {'1': 'DELETE_CALENDARS_ERROR_REASON_INTERNAL_SERVER_ERROR', '2': 1},
    const {'1': 'DELETE_CALENDARS_ERROR_REASON_COULD_NOT_VERIFY_SESSION_ERROR', '2': 2},
    const {'1': 'DELETE_CALENDARS_ERROR_REASON_DO_NOT_OWN_CALENDAR_ERROR', '2': 3},
    const {'1': 'DELETE_CALENDARS_ERROR_REASON_CALENDAR_NOT_FOUND_ERROR', '2': 4},
  ],
};

const ListCalendarsRequest$json = const {
  '1': 'ListCalendarsRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'max_results', '3': 3, '4': 1, '5': 3, '10': 'maxResults'},
    const {'1': 'next_token', '3': 4, '4': 1, '5': 11, '6': '.simpletracker.ListCalendarsRequestNextTokenOpaque', '10': 'nextToken'},
  ],
};

const ListCalendarsRequestNextTokenOpaque$json = const {
  '1': 'ListCalendarsRequestNextTokenOpaque',
  '2': const [
    const {'1': 'opaque_next_token', '3': 1, '4': 1, '5': 12, '10': 'opaqueNextToken'},
    const {'1': 'encryption_key_used', '3': 2, '4': 1, '5': 9, '10': 'encryptionKeyUsed'},
  ],
};

const ListCalendarsRequestNextToken$json = const {
  '1': 'ListCalendarsRequestNextToken',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 3, '10': 'version'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 3, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'dynamodb_next_token', '3': 4, '4': 3, '5': 11, '6': '.simpletracker.ListCalendarsRequestNextToken.DynamodbNextTokenEntry', '10': 'dynamodbNextToken'},
    const {'1': 'expiry_epoch_seconds', '3': 5, '4': 1, '5': 3, '10': 'expiryEpochSeconds'},
  ],
  '3': const [ListCalendarsRequestNextToken_DynamodbNextTokenEntry$json],
};

const ListCalendarsRequestNextToken_DynamodbNextTokenEntry$json = const {
  '1': 'DynamodbNextTokenEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

const ListCalendarsResponse$json = const {
  '1': 'ListCalendarsResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'error_reason', '3': 2, '4': 1, '5': 14, '6': '.simpletracker.ListCalendarsErrorReason', '10': 'errorReason'},
    const {'1': 'calendarSummaries', '3': 3, '4': 3, '5': 11, '6': '.simpletracker.CalendarSummary', '10': 'calendarSummaries'},
    const {'1': 'next_token', '3': 4, '4': 1, '5': 11, '6': '.simpletracker.ListCalendarsRequestNextTokenOpaque', '10': 'nextToken'},
  ],
};

const CalendarSummary$json = const {
  '1': 'CalendarSummary',
  '2': const [
    const {'1': 'formatVersion', '3': 1, '4': 1, '5': 3, '10': 'formatVersion'},
    const {'1': 'ownerUserid', '3': 2, '4': 1, '5': 9, '10': 'ownerUserid'},
    const {'1': 'id', '3': 3, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'color', '3': 5, '4': 1, '5': 9, '10': 'color'},
    const {'1': 'version', '3': 6, '4': 1, '5': 3, '10': 'version'},
  ],
};

const CalendarDetail$json = const {
  '1': 'CalendarDetail',
  '2': const [
    const {'1': 'summary', '3': 1, '4': 1, '5': 11, '6': '.simpletracker.CalendarSummary', '10': 'summary'},
    const {'1': 'highlighted_days', '3': 2, '4': 1, '5': 12, '10': 'highlightedDays'},
  ],
};

const ListOfStrings$json = const {
  '1': 'ListOfStrings',
  '2': const [
    const {'1': 'strings', '3': 1, '4': 3, '5': 9, '10': 'strings'},
  ],
};

const CreateCalendarRequest$json = const {
  '1': 'CreateCalendarRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'color', '3': 4, '4': 1, '5': 9, '10': 'color'},
  ],
};

const CreateCalendarResponse$json = const {
  '1': 'CreateCalendarResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'error_reason', '3': 2, '4': 1, '5': 14, '6': '.simpletracker.CreateCalendarErrorReason', '10': 'errorReason'},
    const {'1': 'calendar_detail', '3': 3, '4': 1, '5': 11, '6': '.simpletracker.CalendarDetail', '10': 'calendarDetail'},
  ],
};

const GetCalendarsRequest$json = const {
  '1': 'GetCalendarsRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'calendar_ids', '3': 3, '4': 3, '5': 9, '10': 'calendarIds'},
  ],
};

const GetCalendarsResponse$json = const {
  '1': 'GetCalendarsResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'error_reason', '3': 2, '4': 1, '5': 14, '6': '.simpletracker.GetCalendarsErrorReason', '10': 'errorReason'},
    const {'1': 'calendar_details', '3': 3, '4': 3, '5': 11, '6': '.simpletracker.CalendarDetail', '10': 'calendarDetails'},
  ],
};

const UpdateCalendarsRequest$json = const {
  '1': 'UpdateCalendarsRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'actions', '3': 3, '4': 3, '5': 11, '6': '.simpletracker.UpdateCalendarsRequest.ActionsEntry', '10': 'actions'},
  ],
  '3': const [UpdateCalendarsRequest_ActionsEntry$json],
};

const UpdateCalendarsRequest_ActionsEntry$json = const {
  '1': 'ActionsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.simpletracker.UpdateCalendarAction', '10': 'value'},
  ],
  '7': const {'7': true},
};

const UpdateCalendarAction$json = const {
  '1': 'UpdateCalendarAction',
  '2': const [
    const {'1': 'calendar_id', '3': 1, '4': 1, '5': 9, '10': 'calendarId'},
    const {'1': 'existing_version', '3': 2, '4': 1, '5': 3, '10': 'existingVersion'},
    const {'1': 'action_type', '3': 3, '4': 1, '5': 14, '6': '.simpletracker.UpdateCalendarActionType', '10': 'actionType'},
    const {'1': 'new_name', '3': 4, '4': 1, '5': 9, '10': 'newName'},
    const {'1': 'new_color', '3': 5, '4': 1, '5': 9, '10': 'newColor'},
    const {'1': 'add_highlighted_day', '3': 6, '4': 1, '5': 9, '10': 'addHighlightedDay'},
    const {'1': 'remove_highlighted_day', '3': 7, '4': 1, '5': 9, '10': 'removeHighlightedDay'},
  ],
};

const UpdateCalendarsResponse$json = const {
  '1': 'UpdateCalendarsResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'error_reason', '3': 2, '4': 1, '5': 14, '6': '.simpletracker.UpdateCalendarsErrorReason', '10': 'errorReason'},
    const {'1': 'calendar_details', '3': 3, '4': 3, '5': 11, '6': '.simpletracker.CalendarDetail', '10': 'calendarDetails'},
  ],
};

const DeleteCalendarRequest$json = const {
  '1': 'DeleteCalendarRequest',
  '2': const [
    const {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    const {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'calendar_id', '3': 3, '4': 1, '5': 9, '10': 'calendarId'},
  ],
};

const DeleteCalendarResponse$json = const {
  '1': 'DeleteCalendarResponse',
  '2': const [
    const {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    const {'1': 'error_reason', '3': 2, '4': 1, '5': 14, '6': '.simpletracker.DeleteCalendarErrorReason', '10': 'errorReason'},
  ],
};


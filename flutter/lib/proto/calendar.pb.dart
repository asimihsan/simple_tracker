///
//  Generated code. Do not modify.
//  source: calendar.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'calendar.pbenum.dart';

export 'calendar.pbenum.dart';

class ListCalendarsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListCalendarsRequest', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOS(1, 'userId')
    ..aOS(2, 'sessionId')
    ..aInt64(3, 'maxResults')
    ..aOM<ListCalendarsRequestNextTokenOpaque>(4, 'nextToken', subBuilder: ListCalendarsRequestNextTokenOpaque.create)
    ..hasRequiredFields = false
  ;

  ListCalendarsRequest._() : super();
  factory ListCalendarsRequest() => create();
  factory ListCalendarsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCalendarsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ListCalendarsRequest clone() => ListCalendarsRequest()..mergeFromMessage(this);
  ListCalendarsRequest copyWith(void Function(ListCalendarsRequest) updates) => super.copyWith((message) => updates(message as ListCalendarsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequest create() => ListCalendarsRequest._();
  ListCalendarsRequest createEmptyInstance() => create();
  static $pb.PbList<ListCalendarsRequest> createRepeated() => $pb.PbList<ListCalendarsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCalendarsRequest>(create);
  static ListCalendarsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get maxResults => $_getI64(2);
  @$pb.TagNumber(3)
  set maxResults($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxResults() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxResults() => clearField(3);

  @$pb.TagNumber(4)
  ListCalendarsRequestNextTokenOpaque get nextToken => $_getN(3);
  @$pb.TagNumber(4)
  set nextToken(ListCalendarsRequestNextTokenOpaque v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNextToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextToken() => clearField(4);
  @$pb.TagNumber(4)
  ListCalendarsRequestNextTokenOpaque ensureNextToken() => $_ensure(3);
}

class ListCalendarsRequestNextTokenOpaque extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListCalendarsRequestNextTokenOpaque', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'opaqueNextToken', $pb.PbFieldType.OY)
    ..aOS(2, 'encryptionKeyUsed')
    ..hasRequiredFields = false
  ;

  ListCalendarsRequestNextTokenOpaque._() : super();
  factory ListCalendarsRequestNextTokenOpaque() => create();
  factory ListCalendarsRequestNextTokenOpaque.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCalendarsRequestNextTokenOpaque.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ListCalendarsRequestNextTokenOpaque clone() => ListCalendarsRequestNextTokenOpaque()..mergeFromMessage(this);
  ListCalendarsRequestNextTokenOpaque copyWith(void Function(ListCalendarsRequestNextTokenOpaque) updates) => super.copyWith((message) => updates(message as ListCalendarsRequestNextTokenOpaque));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequestNextTokenOpaque create() => ListCalendarsRequestNextTokenOpaque._();
  ListCalendarsRequestNextTokenOpaque createEmptyInstance() => create();
  static $pb.PbList<ListCalendarsRequestNextTokenOpaque> createRepeated() => $pb.PbList<ListCalendarsRequestNextTokenOpaque>();
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequestNextTokenOpaque getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCalendarsRequestNextTokenOpaque>(create);
  static ListCalendarsRequestNextTokenOpaque _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get opaqueNextToken => $_getN(0);
  @$pb.TagNumber(1)
  set opaqueNextToken($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOpaqueNextToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpaqueNextToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get encryptionKeyUsed => $_getSZ(1);
  @$pb.TagNumber(2)
  set encryptionKeyUsed($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEncryptionKeyUsed() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncryptionKeyUsed() => clearField(2);
}

class ListCalendarsRequestNextToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListCalendarsRequestNextToken', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aInt64(1, 'version')
    ..aOS(2, 'userId')
    ..aOS(3, 'sessionId')
    ..m<$core.String, $core.String>(4, 'dynamodbNextToken', entryClassName: 'ListCalendarsRequestNextToken.DynamodbNextTokenEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('simpletracker'))
    ..aInt64(5, 'expiryEpochSeconds')
    ..hasRequiredFields = false
  ;

  ListCalendarsRequestNextToken._() : super();
  factory ListCalendarsRequestNextToken() => create();
  factory ListCalendarsRequestNextToken.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCalendarsRequestNextToken.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ListCalendarsRequestNextToken clone() => ListCalendarsRequestNextToken()..mergeFromMessage(this);
  ListCalendarsRequestNextToken copyWith(void Function(ListCalendarsRequestNextToken) updates) => super.copyWith((message) => updates(message as ListCalendarsRequestNextToken));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequestNextToken create() => ListCalendarsRequestNextToken._();
  ListCalendarsRequestNextToken createEmptyInstance() => create();
  static $pb.PbList<ListCalendarsRequestNextToken> createRepeated() => $pb.PbList<ListCalendarsRequestNextToken>();
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequestNextToken getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCalendarsRequestNextToken>(create);
  static ListCalendarsRequestNextToken _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get version => $_getI64(0);
  @$pb.TagNumber(1)
  set version($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sessionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sessionId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSessionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSessionId() => clearField(3);

  @$pb.TagNumber(4)
  $core.Map<$core.String, $core.String> get dynamodbNextToken => $_getMap(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get expiryEpochSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set expiryEpochSeconds($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExpiryEpochSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiryEpochSeconds() => clearField(5);
}

class ListCalendarsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListCalendarsResponse', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOB(1, 'success')
    ..e<ListCalendarsErrorReason>(2, 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: ListCalendarsErrorReason.LIST_CALENDARS_ERROR_REASON_NO_ERROR, valueOf: ListCalendarsErrorReason.valueOf, enumValues: ListCalendarsErrorReason.values)
    ..pc<CalendarSummary>(3, 'calendarSummaries', $pb.PbFieldType.PM, protoName: 'calendarSummaries', subBuilder: CalendarSummary.create)
    ..aOM<ListCalendarsRequestNextTokenOpaque>(4, 'nextToken', subBuilder: ListCalendarsRequestNextTokenOpaque.create)
    ..hasRequiredFields = false
  ;

  ListCalendarsResponse._() : super();
  factory ListCalendarsResponse() => create();
  factory ListCalendarsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCalendarsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ListCalendarsResponse clone() => ListCalendarsResponse()..mergeFromMessage(this);
  ListCalendarsResponse copyWith(void Function(ListCalendarsResponse) updates) => super.copyWith((message) => updates(message as ListCalendarsResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCalendarsResponse create() => ListCalendarsResponse._();
  ListCalendarsResponse createEmptyInstance() => create();
  static $pb.PbList<ListCalendarsResponse> createRepeated() => $pb.PbList<ListCalendarsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListCalendarsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCalendarsResponse>(create);
  static ListCalendarsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  ListCalendarsErrorReason get errorReason => $_getN(1);
  @$pb.TagNumber(2)
  set errorReason(ListCalendarsErrorReason v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorReason() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<CalendarSummary> get calendarSummaries => $_getList(2);

  @$pb.TagNumber(4)
  ListCalendarsRequestNextTokenOpaque get nextToken => $_getN(3);
  @$pb.TagNumber(4)
  set nextToken(ListCalendarsRequestNextTokenOpaque v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNextToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextToken() => clearField(4);
  @$pb.TagNumber(4)
  ListCalendarsRequestNextTokenOpaque ensureNextToken() => $_ensure(3);
}

class CalendarSummary extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CalendarSummary', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aInt64(1, 'formatVersion', protoName: 'formatVersion')
    ..aOS(2, 'ownerUserid', protoName: 'ownerUserid')
    ..aOS(3, 'id')
    ..aOS(4, 'name')
    ..aOS(5, 'color')
    ..aInt64(6, 'version')
    ..hasRequiredFields = false
  ;

  CalendarSummary._() : super();
  factory CalendarSummary() => create();
  factory CalendarSummary.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalendarSummary.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CalendarSummary clone() => CalendarSummary()..mergeFromMessage(this);
  CalendarSummary copyWith(void Function(CalendarSummary) updates) => super.copyWith((message) => updates(message as CalendarSummary));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CalendarSummary create() => CalendarSummary._();
  CalendarSummary createEmptyInstance() => create();
  static $pb.PbList<CalendarSummary> createRepeated() => $pb.PbList<CalendarSummary>();
  @$core.pragma('dart2js:noInline')
  static CalendarSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalendarSummary>(create);
  static CalendarSummary _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get formatVersion => $_getI64(0);
  @$pb.TagNumber(1)
  set formatVersion($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFormatVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormatVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get ownerUserid => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerUserid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOwnerUserid() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerUserid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(2);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(2);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get color => $_getSZ(4);
  @$pb.TagNumber(5)
  set color($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearColor() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get version => $_getI64(5);
  @$pb.TagNumber(6)
  set version($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => clearField(6);
}

class CalendarDetail extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CalendarDetail', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOM<CalendarSummary>(1, 'summary', subBuilder: CalendarSummary.create)
    ..a<$core.List<$core.int>>(2, 'highlightedDays', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CalendarDetail._() : super();
  factory CalendarDetail() => create();
  factory CalendarDetail.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalendarDetail.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CalendarDetail clone() => CalendarDetail()..mergeFromMessage(this);
  CalendarDetail copyWith(void Function(CalendarDetail) updates) => super.copyWith((message) => updates(message as CalendarDetail));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CalendarDetail create() => CalendarDetail._();
  CalendarDetail createEmptyInstance() => create();
  static $pb.PbList<CalendarDetail> createRepeated() => $pb.PbList<CalendarDetail>();
  @$core.pragma('dart2js:noInline')
  static CalendarDetail getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalendarDetail>(create);
  static CalendarDetail _defaultInstance;

  @$pb.TagNumber(1)
  CalendarSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(CalendarSummary v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => clearField(1);
  @$pb.TagNumber(1)
  CalendarSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get highlightedDays => $_getN(1);
  @$pb.TagNumber(2)
  set highlightedDays($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHighlightedDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearHighlightedDays() => clearField(2);
}

class ListOfStrings extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListOfStrings', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..pPS(1, 'strings')
    ..hasRequiredFields = false
  ;

  ListOfStrings._() : super();
  factory ListOfStrings() => create();
  factory ListOfStrings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListOfStrings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  ListOfStrings clone() => ListOfStrings()..mergeFromMessage(this);
  ListOfStrings copyWith(void Function(ListOfStrings) updates) => super.copyWith((message) => updates(message as ListOfStrings));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListOfStrings create() => ListOfStrings._();
  ListOfStrings createEmptyInstance() => create();
  static $pb.PbList<ListOfStrings> createRepeated() => $pb.PbList<ListOfStrings>();
  @$core.pragma('dart2js:noInline')
  static ListOfStrings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListOfStrings>(create);
  static ListOfStrings _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get strings => $_getList(0);
}

class CreateCalendarRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateCalendarRequest', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOS(1, 'userId')
    ..aOS(2, 'sessionId')
    ..aOS(3, 'name')
    ..aOS(4, 'color')
    ..hasRequiredFields = false
  ;

  CreateCalendarRequest._() : super();
  factory CreateCalendarRequest() => create();
  factory CreateCalendarRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCalendarRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CreateCalendarRequest clone() => CreateCalendarRequest()..mergeFromMessage(this);
  CreateCalendarRequest copyWith(void Function(CreateCalendarRequest) updates) => super.copyWith((message) => updates(message as CreateCalendarRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateCalendarRequest create() => CreateCalendarRequest._();
  CreateCalendarRequest createEmptyInstance() => create();
  static $pb.PbList<CreateCalendarRequest> createRepeated() => $pb.PbList<CreateCalendarRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateCalendarRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCalendarRequest>(create);
  static CreateCalendarRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get color => $_getSZ(3);
  @$pb.TagNumber(4)
  set color($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearColor() => clearField(4);
}

class CreateCalendarResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CreateCalendarResponse', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOB(1, 'success')
    ..e<CreateCalendarErrorReason>(2, 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: CreateCalendarErrorReason.CREATE_CALENDAR_ERROR_REASON_NO_ERROR, valueOf: CreateCalendarErrorReason.valueOf, enumValues: CreateCalendarErrorReason.values)
    ..aOM<CalendarDetail>(3, 'calendarDetail', subBuilder: CalendarDetail.create)
    ..hasRequiredFields = false
  ;

  CreateCalendarResponse._() : super();
  factory CreateCalendarResponse() => create();
  factory CreateCalendarResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCalendarResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CreateCalendarResponse clone() => CreateCalendarResponse()..mergeFromMessage(this);
  CreateCalendarResponse copyWith(void Function(CreateCalendarResponse) updates) => super.copyWith((message) => updates(message as CreateCalendarResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateCalendarResponse create() => CreateCalendarResponse._();
  CreateCalendarResponse createEmptyInstance() => create();
  static $pb.PbList<CreateCalendarResponse> createRepeated() => $pb.PbList<CreateCalendarResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateCalendarResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCalendarResponse>(create);
  static CreateCalendarResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  CreateCalendarErrorReason get errorReason => $_getN(1);
  @$pb.TagNumber(2)
  set errorReason(CreateCalendarErrorReason v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorReason() => clearField(2);

  @$pb.TagNumber(3)
  CalendarDetail get calendarDetail => $_getN(2);
  @$pb.TagNumber(3)
  set calendarDetail(CalendarDetail v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCalendarDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearCalendarDetail() => clearField(3);
  @$pb.TagNumber(3)
  CalendarDetail ensureCalendarDetail() => $_ensure(2);
}

class GetCalendarsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetCalendarsRequest', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOS(1, 'userId')
    ..aOS(2, 'sessionId')
    ..pPS(3, 'calendarIds')
    ..hasRequiredFields = false
  ;

  GetCalendarsRequest._() : super();
  factory GetCalendarsRequest() => create();
  factory GetCalendarsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCalendarsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GetCalendarsRequest clone() => GetCalendarsRequest()..mergeFromMessage(this);
  GetCalendarsRequest copyWith(void Function(GetCalendarsRequest) updates) => super.copyWith((message) => updates(message as GetCalendarsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCalendarsRequest create() => GetCalendarsRequest._();
  GetCalendarsRequest createEmptyInstance() => create();
  static $pb.PbList<GetCalendarsRequest> createRepeated() => $pb.PbList<GetCalendarsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCalendarsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCalendarsRequest>(create);
  static GetCalendarsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get calendarIds => $_getList(2);
}

class GetCalendarsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetCalendarsResponse', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOB(1, 'success')
    ..e<GetCalendarsErrorReason>(2, 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: GetCalendarsErrorReason.GET_CALENDARS_ERROR_REASON_NO_ERROR, valueOf: GetCalendarsErrorReason.valueOf, enumValues: GetCalendarsErrorReason.values)
    ..pc<CalendarDetail>(3, 'calendarDetails', $pb.PbFieldType.PM, subBuilder: CalendarDetail.create)
    ..hasRequiredFields = false
  ;

  GetCalendarsResponse._() : super();
  factory GetCalendarsResponse() => create();
  factory GetCalendarsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCalendarsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GetCalendarsResponse clone() => GetCalendarsResponse()..mergeFromMessage(this);
  GetCalendarsResponse copyWith(void Function(GetCalendarsResponse) updates) => super.copyWith((message) => updates(message as GetCalendarsResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCalendarsResponse create() => GetCalendarsResponse._();
  GetCalendarsResponse createEmptyInstance() => create();
  static $pb.PbList<GetCalendarsResponse> createRepeated() => $pb.PbList<GetCalendarsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCalendarsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCalendarsResponse>(create);
  static GetCalendarsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  GetCalendarsErrorReason get errorReason => $_getN(1);
  @$pb.TagNumber(2)
  set errorReason(GetCalendarsErrorReason v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorReason() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<CalendarDetail> get calendarDetails => $_getList(2);
}

class UpdateCalendarsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateCalendarsRequest', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOS(1, 'userId')
    ..aOS(2, 'sessionId')
    ..m<$core.String, UpdateCalendarAction>(3, 'actions', entryClassName: 'UpdateCalendarsRequest.ActionsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: UpdateCalendarAction.create, packageName: const $pb.PackageName('simpletracker'))
    ..hasRequiredFields = false
  ;

  UpdateCalendarsRequest._() : super();
  factory UpdateCalendarsRequest() => create();
  factory UpdateCalendarsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCalendarsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UpdateCalendarsRequest clone() => UpdateCalendarsRequest()..mergeFromMessage(this);
  UpdateCalendarsRequest copyWith(void Function(UpdateCalendarsRequest) updates) => super.copyWith((message) => updates(message as UpdateCalendarsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarsRequest create() => UpdateCalendarsRequest._();
  UpdateCalendarsRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateCalendarsRequest> createRepeated() => $pb.PbList<UpdateCalendarsRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCalendarsRequest>(create);
  static UpdateCalendarsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.Map<$core.String, UpdateCalendarAction> get actions => $_getMap(2);
}

class UpdateCalendarAction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateCalendarAction', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOS(1, 'calendarId')
    ..aInt64(2, 'existingVersion')
    ..e<UpdateCalendarActionType>(3, 'actionType', $pb.PbFieldType.OE, defaultOrMaker: UpdateCalendarActionType.UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME, valueOf: UpdateCalendarActionType.valueOf, enumValues: UpdateCalendarActionType.values)
    ..aOS(4, 'newName')
    ..aOS(5, 'newColor')
    ..aOS(6, 'addHighlightedDay')
    ..aOS(7, 'removeHighlightedDay')
    ..hasRequiredFields = false
  ;

  UpdateCalendarAction._() : super();
  factory UpdateCalendarAction() => create();
  factory UpdateCalendarAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCalendarAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UpdateCalendarAction clone() => UpdateCalendarAction()..mergeFromMessage(this);
  UpdateCalendarAction copyWith(void Function(UpdateCalendarAction) updates) => super.copyWith((message) => updates(message as UpdateCalendarAction));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarAction create() => UpdateCalendarAction._();
  UpdateCalendarAction createEmptyInstance() => create();
  static $pb.PbList<UpdateCalendarAction> createRepeated() => $pb.PbList<UpdateCalendarAction>();
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCalendarAction>(create);
  static UpdateCalendarAction _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get calendarId => $_getSZ(0);
  @$pb.TagNumber(1)
  set calendarId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCalendarId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCalendarId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get existingVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set existingVersion($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasExistingVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExistingVersion() => clearField(2);

  @$pb.TagNumber(3)
  UpdateCalendarActionType get actionType => $_getN(2);
  @$pb.TagNumber(3)
  set actionType(UpdateCalendarActionType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasActionType() => $_has(2);
  @$pb.TagNumber(3)
  void clearActionType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get newName => $_getSZ(3);
  @$pb.TagNumber(4)
  set newName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNewName() => $_has(3);
  @$pb.TagNumber(4)
  void clearNewName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get newColor => $_getSZ(4);
  @$pb.TagNumber(5)
  set newColor($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNewColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearNewColor() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get addHighlightedDay => $_getSZ(5);
  @$pb.TagNumber(6)
  set addHighlightedDay($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAddHighlightedDay() => $_has(5);
  @$pb.TagNumber(6)
  void clearAddHighlightedDay() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get removeHighlightedDay => $_getSZ(6);
  @$pb.TagNumber(7)
  set removeHighlightedDay($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRemoveHighlightedDay() => $_has(6);
  @$pb.TagNumber(7)
  void clearRemoveHighlightedDay() => clearField(7);
}

class UpdateCalendarsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UpdateCalendarsResponse', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOB(1, 'success')
    ..e<UpdateCalendarsErrorReason>(2, 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: UpdateCalendarsErrorReason.UPDATE_CALENDARS_ERROR_REASON_NO_ERROR, valueOf: UpdateCalendarsErrorReason.valueOf, enumValues: UpdateCalendarsErrorReason.values)
    ..pc<CalendarDetail>(3, 'calendarDetails', $pb.PbFieldType.PM, subBuilder: CalendarDetail.create)
    ..hasRequiredFields = false
  ;

  UpdateCalendarsResponse._() : super();
  factory UpdateCalendarsResponse() => create();
  factory UpdateCalendarsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCalendarsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  UpdateCalendarsResponse clone() => UpdateCalendarsResponse()..mergeFromMessage(this);
  UpdateCalendarsResponse copyWith(void Function(UpdateCalendarsResponse) updates) => super.copyWith((message) => updates(message as UpdateCalendarsResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarsResponse create() => UpdateCalendarsResponse._();
  UpdateCalendarsResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateCalendarsResponse> createRepeated() => $pb.PbList<UpdateCalendarsResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCalendarsResponse>(create);
  static UpdateCalendarsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  UpdateCalendarsErrorReason get errorReason => $_getN(1);
  @$pb.TagNumber(2)
  set errorReason(UpdateCalendarsErrorReason v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorReason() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<CalendarDetail> get calendarDetails => $_getList(2);
}

class DeleteCalendarRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeleteCalendarRequest', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOS(1, 'userId')
    ..aOS(2, 'sessionId')
    ..aOS(3, 'calendarId')
    ..hasRequiredFields = false
  ;

  DeleteCalendarRequest._() : super();
  factory DeleteCalendarRequest() => create();
  factory DeleteCalendarRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCalendarRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DeleteCalendarRequest clone() => DeleteCalendarRequest()..mergeFromMessage(this);
  DeleteCalendarRequest copyWith(void Function(DeleteCalendarRequest) updates) => super.copyWith((message) => updates(message as DeleteCalendarRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteCalendarRequest create() => DeleteCalendarRequest._();
  DeleteCalendarRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteCalendarRequest> createRepeated() => $pb.PbList<DeleteCalendarRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteCalendarRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCalendarRequest>(create);
  static DeleteCalendarRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get calendarId => $_getSZ(2);
  @$pb.TagNumber(3)
  set calendarId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCalendarId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCalendarId() => clearField(3);
}

class DeleteCalendarResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DeleteCalendarResponse', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOB(1, 'success')
    ..e<DeleteCalendarErrorReason>(2, 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: DeleteCalendarErrorReason.DELETE_CALENDARS_ERROR_REASON_NO_ERROR, valueOf: DeleteCalendarErrorReason.valueOf, enumValues: DeleteCalendarErrorReason.values)
    ..hasRequiredFields = false
  ;

  DeleteCalendarResponse._() : super();
  factory DeleteCalendarResponse() => create();
  factory DeleteCalendarResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCalendarResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  DeleteCalendarResponse clone() => DeleteCalendarResponse()..mergeFromMessage(this);
  DeleteCalendarResponse copyWith(void Function(DeleteCalendarResponse) updates) => super.copyWith((message) => updates(message as DeleteCalendarResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteCalendarResponse create() => DeleteCalendarResponse._();
  DeleteCalendarResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteCalendarResponse> createRepeated() => $pb.PbList<DeleteCalendarResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteCalendarResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCalendarResponse>(create);
  static DeleteCalendarResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);

  @$pb.TagNumber(2)
  DeleteCalendarErrorReason get errorReason => $_getN(1);
  @$pb.TagNumber(2)
  set errorReason(DeleteCalendarErrorReason v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorReason() => clearField(2);
}


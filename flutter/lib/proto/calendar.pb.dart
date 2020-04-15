///
//  Generated code. Do not modify.
//  source: calendar.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/wrappers.pb.dart' as $0;

class ListCalendarsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListCalendarsRequest', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOS(1, 'userId')
    ..aOS(2, 'sessionId')
    ..aOM<$0.Int32Value>(3, 'maxResults', subBuilder: $0.Int32Value.create)
    ..aOM<$0.BytesValue>(4, 'nextToken', subBuilder: $0.BytesValue.create)
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
  $0.Int32Value get maxResults => $_getN(2);
  @$pb.TagNumber(3)
  set maxResults($0.Int32Value v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxResults() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxResults() => clearField(3);
  @$pb.TagNumber(3)
  $0.Int32Value ensureMaxResults() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.BytesValue get nextToken => $_getN(3);
  @$pb.TagNumber(4)
  set nextToken($0.BytesValue v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNextToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextToken() => clearField(4);
  @$pb.TagNumber(4)
  $0.BytesValue ensureNextToken() => $_ensure(3);
}

class ListCalendarsRequestNextToken extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListCalendarsRequestNextToken', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..a<$core.int>(1, 'version', $pb.PbFieldType.O3)
    ..aOS(2, 'userId')
    ..aOS(3, 'sessionId')
    ..aOM<$0.StringValue>(4, 'nextTokenInner', subBuilder: $0.StringValue.create)
    ..a<$core.int>(5, 'expiryEpochSeconds', $pb.PbFieldType.O3, protoName: 'expiryEpochSeconds')
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
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setSignedInt32(0, v); }
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
  $0.StringValue get nextTokenInner => $_getN(3);
  @$pb.TagNumber(4)
  set nextTokenInner($0.StringValue v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNextTokenInner() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextTokenInner() => clearField(4);
  @$pb.TagNumber(4)
  $0.StringValue ensureNextTokenInner() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get expiryEpochSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set expiryEpochSeconds($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExpiryEpochSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiryEpochSeconds() => clearField(5);
}

class ListCalendarsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ListCalendarsResponse', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOB(1, 'success')
    ..pc<CalendarSummary>(2, 'calendarSummaries', $pb.PbFieldType.PM, protoName: 'calendarSummaries', subBuilder: CalendarSummary.create)
    ..aOM<$0.BytesValue>(3, 'nextToken', subBuilder: $0.BytesValue.create)
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
  $core.List<CalendarSummary> get calendarSummaries => $_getList(1);

  @$pb.TagNumber(3)
  $0.BytesValue get nextToken => $_getN(2);
  @$pb.TagNumber(3)
  set nextToken($0.BytesValue v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasNextToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextToken() => clearField(3);
  @$pb.TagNumber(3)
  $0.BytesValue ensureNextToken() => $_ensure(2);
}

class CalendarSummary extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CalendarSummary', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..a<$core.int>(1, 'formatVersion', $pb.PbFieldType.O3, protoName: 'formatVersion')
    ..aOS(2, 'id')
    ..aOS(3, 'name')
    ..aOS(4, 'color')
    ..a<$core.int>(5, 'version', $pb.PbFieldType.O3)
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
  $core.int get formatVersion => $_getIZ(0);
  @$pb.TagNumber(1)
  set formatVersion($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFormatVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearFormatVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

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

  @$pb.TagNumber(5)
  $core.int get version => $_getIZ(4);
  @$pb.TagNumber(5)
  set version($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => clearField(5);
}

class CalendarDetail extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CalendarDetail', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOM<CalendarSummary>(1, 'summary', subBuilder: CalendarSummary.create)
    ..pPS(2, 'highlightedDays', protoName: 'highlightedDays')
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
  $core.List<$core.String> get highlightedDays => $_getList(1);
}


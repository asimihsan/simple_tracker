///
//  Generated code. Do not modify.
//  source: calendar.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'calendar.pbenum.dart';

export 'calendar.pbenum.dart';

class ListCalendarsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListCalendarsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxResults')
    ..aOM<ListCalendarsRequestNextTokenOpaque>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nextToken', subBuilder: ListCalendarsRequestNextTokenOpaque.create)
    ..hasRequiredFields = false
  ;

  ListCalendarsRequest._() : super();
  factory ListCalendarsRequest({
    $core.String? userId,
    $core.String? sessionId,
    $fixnum.Int64? maxResults,
    ListCalendarsRequestNextTokenOpaque? nextToken,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (maxResults != null) {
      _result.maxResults = maxResults;
    }
    if (nextToken != null) {
      _result.nextToken = nextToken;
    }
    return _result;
  }
  factory ListCalendarsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCalendarsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListCalendarsRequest clone() => ListCalendarsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListCalendarsRequest copyWith(void Function(ListCalendarsRequest) updates) => super.copyWith((message) => updates(message as ListCalendarsRequest)) as ListCalendarsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequest create() => ListCalendarsRequest._();
  ListCalendarsRequest createEmptyInstance() => create();
  static $pb.PbList<ListCalendarsRequest> createRepeated() => $pb.PbList<ListCalendarsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCalendarsRequest>(create);
  static ListCalendarsRequest? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListCalendarsRequestNextTokenOpaque', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'opaqueNextToken', $pb.PbFieldType.OY)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encryptionKeyUsed')
    ..hasRequiredFields = false
  ;

  ListCalendarsRequestNextTokenOpaque._() : super();
  factory ListCalendarsRequestNextTokenOpaque({
    $core.List<$core.int>? opaqueNextToken,
    $core.String? encryptionKeyUsed,
  }) {
    final _result = create();
    if (opaqueNextToken != null) {
      _result.opaqueNextToken = opaqueNextToken;
    }
    if (encryptionKeyUsed != null) {
      _result.encryptionKeyUsed = encryptionKeyUsed;
    }
    return _result;
  }
  factory ListCalendarsRequestNextTokenOpaque.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCalendarsRequestNextTokenOpaque.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListCalendarsRequestNextTokenOpaque clone() => ListCalendarsRequestNextTokenOpaque()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListCalendarsRequestNextTokenOpaque copyWith(void Function(ListCalendarsRequestNextTokenOpaque) updates) => super.copyWith((message) => updates(message as ListCalendarsRequestNextTokenOpaque)) as ListCalendarsRequestNextTokenOpaque; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequestNextTokenOpaque create() => ListCalendarsRequestNextTokenOpaque._();
  ListCalendarsRequestNextTokenOpaque createEmptyInstance() => create();
  static $pb.PbList<ListCalendarsRequestNextTokenOpaque> createRepeated() => $pb.PbList<ListCalendarsRequestNextTokenOpaque>();
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequestNextTokenOpaque getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCalendarsRequestNextTokenOpaque>(create);
  static ListCalendarsRequestNextTokenOpaque? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListCalendarsRequestNextToken', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..m<$core.String, $core.String>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dynamodbNextToken', entryClassName: 'ListCalendarsRequestNextToken.DynamodbNextTokenEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('simpletracker'))
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiryEpochSeconds')
    ..hasRequiredFields = false
  ;

  ListCalendarsRequestNextToken._() : super();
  factory ListCalendarsRequestNextToken({
    $fixnum.Int64? version,
    $core.String? userId,
    $core.String? sessionId,
    $core.Map<$core.String, $core.String>? dynamodbNextToken,
    $fixnum.Int64? expiryEpochSeconds,
  }) {
    final _result = create();
    if (version != null) {
      _result.version = version;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (dynamodbNextToken != null) {
      _result.dynamodbNextToken.addAll(dynamodbNextToken);
    }
    if (expiryEpochSeconds != null) {
      _result.expiryEpochSeconds = expiryEpochSeconds;
    }
    return _result;
  }
  factory ListCalendarsRequestNextToken.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCalendarsRequestNextToken.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListCalendarsRequestNextToken clone() => ListCalendarsRequestNextToken()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListCalendarsRequestNextToken copyWith(void Function(ListCalendarsRequestNextToken) updates) => super.copyWith((message) => updates(message as ListCalendarsRequestNextToken)) as ListCalendarsRequestNextToken; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequestNextToken create() => ListCalendarsRequestNextToken._();
  ListCalendarsRequestNextToken createEmptyInstance() => create();
  static $pb.PbList<ListCalendarsRequestNextToken> createRepeated() => $pb.PbList<ListCalendarsRequestNextToken>();
  @$core.pragma('dart2js:noInline')
  static ListCalendarsRequestNextToken getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCalendarsRequestNextToken>(create);
  static ListCalendarsRequestNextToken? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListCalendarsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..e<ListCalendarsErrorReason>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: ListCalendarsErrorReason.LIST_CALENDARS_ERROR_REASON_NO_ERROR, valueOf: ListCalendarsErrorReason.valueOf, enumValues: ListCalendarsErrorReason.values)
    ..pc<CalendarSummary>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calendarSummaries', $pb.PbFieldType.PM, protoName: 'calendarSummaries', subBuilder: CalendarSummary.create)
    ..aOM<ListCalendarsRequestNextTokenOpaque>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nextToken', subBuilder: ListCalendarsRequestNextTokenOpaque.create)
    ..hasRequiredFields = false
  ;

  ListCalendarsResponse._() : super();
  factory ListCalendarsResponse({
    $core.bool? success,
    ListCalendarsErrorReason? errorReason,
    $core.Iterable<CalendarSummary>? calendarSummaries,
    ListCalendarsRequestNextTokenOpaque? nextToken,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (errorReason != null) {
      _result.errorReason = errorReason;
    }
    if (calendarSummaries != null) {
      _result.calendarSummaries.addAll(calendarSummaries);
    }
    if (nextToken != null) {
      _result.nextToken = nextToken;
    }
    return _result;
  }
  factory ListCalendarsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCalendarsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListCalendarsResponse clone() => ListCalendarsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListCalendarsResponse copyWith(void Function(ListCalendarsResponse) updates) => super.copyWith((message) => updates(message as ListCalendarsResponse)) as ListCalendarsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCalendarsResponse create() => ListCalendarsResponse._();
  ListCalendarsResponse createEmptyInstance() => create();
  static $pb.PbList<ListCalendarsResponse> createRepeated() => $pb.PbList<ListCalendarsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListCalendarsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCalendarsResponse>(create);
  static ListCalendarsResponse? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CalendarSummary', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'formatVersion', protoName: 'formatVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ownerUserid', protoName: 'ownerUserid')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'color')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version')
    ..hasRequiredFields = false
  ;

  CalendarSummary._() : super();
  factory CalendarSummary({
    $fixnum.Int64? formatVersion,
    $core.String? ownerUserid,
    $core.String? id,
    $core.String? name,
    $core.String? color,
    $fixnum.Int64? version,
  }) {
    final _result = create();
    if (formatVersion != null) {
      _result.formatVersion = formatVersion;
    }
    if (ownerUserid != null) {
      _result.ownerUserid = ownerUserid;
    }
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (color != null) {
      _result.color = color;
    }
    if (version != null) {
      _result.version = version;
    }
    return _result;
  }
  factory CalendarSummary.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalendarSummary.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalendarSummary clone() => CalendarSummary()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalendarSummary copyWith(void Function(CalendarSummary) updates) => super.copyWith((message) => updates(message as CalendarSummary)) as CalendarSummary; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CalendarSummary create() => CalendarSummary._();
  CalendarSummary createEmptyInstance() => create();
  static $pb.PbList<CalendarSummary> createRepeated() => $pb.PbList<CalendarSummary>();
  @$core.pragma('dart2js:noInline')
  static CalendarSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalendarSummary>(create);
  static CalendarSummary? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CalendarDetail', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOM<CalendarSummary>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'summary', subBuilder: CalendarSummary.create)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'highlightedDays', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CalendarDetail._() : super();
  factory CalendarDetail({
    CalendarSummary? summary,
    $core.List<$core.int>? highlightedDays,
  }) {
    final _result = create();
    if (summary != null) {
      _result.summary = summary;
    }
    if (highlightedDays != null) {
      _result.highlightedDays = highlightedDays;
    }
    return _result;
  }
  factory CalendarDetail.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalendarDetail.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalendarDetail clone() => CalendarDetail()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalendarDetail copyWith(void Function(CalendarDetail) updates) => super.copyWith((message) => updates(message as CalendarDetail)) as CalendarDetail; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CalendarDetail create() => CalendarDetail._();
  CalendarDetail createEmptyInstance() => create();
  static $pb.PbList<CalendarDetail> createRepeated() => $pb.PbList<CalendarDetail>();
  @$core.pragma('dart2js:noInline')
  static CalendarDetail getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalendarDetail>(create);
  static CalendarDetail? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListOfStrings', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'strings')
    ..hasRequiredFields = false
  ;

  ListOfStrings._() : super();
  factory ListOfStrings({
    $core.Iterable<$core.String>? strings,
  }) {
    final _result = create();
    if (strings != null) {
      _result.strings.addAll(strings);
    }
    return _result;
  }
  factory ListOfStrings.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListOfStrings.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListOfStrings clone() => ListOfStrings()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListOfStrings copyWith(void Function(ListOfStrings) updates) => super.copyWith((message) => updates(message as ListOfStrings)) as ListOfStrings; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListOfStrings create() => ListOfStrings._();
  ListOfStrings createEmptyInstance() => create();
  static $pb.PbList<ListOfStrings> createRepeated() => $pb.PbList<ListOfStrings>();
  @$core.pragma('dart2js:noInline')
  static ListOfStrings getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListOfStrings>(create);
  static ListOfStrings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get strings => $_getList(0);
}

class CreateCalendarRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateCalendarRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'color')
    ..hasRequiredFields = false
  ;

  CreateCalendarRequest._() : super();
  factory CreateCalendarRequest({
    $core.String? userId,
    $core.String? sessionId,
    $core.String? name,
    $core.String? color,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (name != null) {
      _result.name = name;
    }
    if (color != null) {
      _result.color = color;
    }
    return _result;
  }
  factory CreateCalendarRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCalendarRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateCalendarRequest clone() => CreateCalendarRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateCalendarRequest copyWith(void Function(CreateCalendarRequest) updates) => super.copyWith((message) => updates(message as CreateCalendarRequest)) as CreateCalendarRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateCalendarRequest create() => CreateCalendarRequest._();
  CreateCalendarRequest createEmptyInstance() => create();
  static $pb.PbList<CreateCalendarRequest> createRepeated() => $pb.PbList<CreateCalendarRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateCalendarRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCalendarRequest>(create);
  static CreateCalendarRequest? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateCalendarResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..e<CreateCalendarErrorReason>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: CreateCalendarErrorReason.CREATE_CALENDAR_ERROR_REASON_NO_ERROR, valueOf: CreateCalendarErrorReason.valueOf, enumValues: CreateCalendarErrorReason.values)
    ..aOM<CalendarDetail>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calendarDetail', subBuilder: CalendarDetail.create)
    ..hasRequiredFields = false
  ;

  CreateCalendarResponse._() : super();
  factory CreateCalendarResponse({
    $core.bool? success,
    CreateCalendarErrorReason? errorReason,
    CalendarDetail? calendarDetail,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (errorReason != null) {
      _result.errorReason = errorReason;
    }
    if (calendarDetail != null) {
      _result.calendarDetail = calendarDetail;
    }
    return _result;
  }
  factory CreateCalendarResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCalendarResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateCalendarResponse clone() => CreateCalendarResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateCalendarResponse copyWith(void Function(CreateCalendarResponse) updates) => super.copyWith((message) => updates(message as CreateCalendarResponse)) as CreateCalendarResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateCalendarResponse create() => CreateCalendarResponse._();
  CreateCalendarResponse createEmptyInstance() => create();
  static $pb.PbList<CreateCalendarResponse> createRepeated() => $pb.PbList<CreateCalendarResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateCalendarResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCalendarResponse>(create);
  static CreateCalendarResponse? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCalendarsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calendarIds')
    ..hasRequiredFields = false
  ;

  GetCalendarsRequest._() : super();
  factory GetCalendarsRequest({
    $core.String? userId,
    $core.String? sessionId,
    $core.Iterable<$core.String>? calendarIds,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (calendarIds != null) {
      _result.calendarIds.addAll(calendarIds);
    }
    return _result;
  }
  factory GetCalendarsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCalendarsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCalendarsRequest clone() => GetCalendarsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCalendarsRequest copyWith(void Function(GetCalendarsRequest) updates) => super.copyWith((message) => updates(message as GetCalendarsRequest)) as GetCalendarsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCalendarsRequest create() => GetCalendarsRequest._();
  GetCalendarsRequest createEmptyInstance() => create();
  static $pb.PbList<GetCalendarsRequest> createRepeated() => $pb.PbList<GetCalendarsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCalendarsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCalendarsRequest>(create);
  static GetCalendarsRequest? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCalendarsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..e<GetCalendarsErrorReason>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: GetCalendarsErrorReason.GET_CALENDARS_ERROR_REASON_NO_ERROR, valueOf: GetCalendarsErrorReason.valueOf, enumValues: GetCalendarsErrorReason.values)
    ..pc<CalendarDetail>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calendarDetails', $pb.PbFieldType.PM, subBuilder: CalendarDetail.create)
    ..hasRequiredFields = false
  ;

  GetCalendarsResponse._() : super();
  factory GetCalendarsResponse({
    $core.bool? success,
    GetCalendarsErrorReason? errorReason,
    $core.Iterable<CalendarDetail>? calendarDetails,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (errorReason != null) {
      _result.errorReason = errorReason;
    }
    if (calendarDetails != null) {
      _result.calendarDetails.addAll(calendarDetails);
    }
    return _result;
  }
  factory GetCalendarsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCalendarsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCalendarsResponse clone() => GetCalendarsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCalendarsResponse copyWith(void Function(GetCalendarsResponse) updates) => super.copyWith((message) => updates(message as GetCalendarsResponse)) as GetCalendarsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCalendarsResponse create() => GetCalendarsResponse._();
  GetCalendarsResponse createEmptyInstance() => create();
  static $pb.PbList<GetCalendarsResponse> createRepeated() => $pb.PbList<GetCalendarsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCalendarsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCalendarsResponse>(create);
  static GetCalendarsResponse? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCalendarsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..m<$core.String, UpdateCalendarAction>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actions', entryClassName: 'UpdateCalendarsRequest.ActionsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: UpdateCalendarAction.create, packageName: const $pb.PackageName('simpletracker'))
    ..hasRequiredFields = false
  ;

  UpdateCalendarsRequest._() : super();
  factory UpdateCalendarsRequest({
    $core.String? userId,
    $core.String? sessionId,
    $core.Map<$core.String, UpdateCalendarAction>? actions,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (actions != null) {
      _result.actions.addAll(actions);
    }
    return _result;
  }
  factory UpdateCalendarsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCalendarsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCalendarsRequest clone() => UpdateCalendarsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCalendarsRequest copyWith(void Function(UpdateCalendarsRequest) updates) => super.copyWith((message) => updates(message as UpdateCalendarsRequest)) as UpdateCalendarsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarsRequest create() => UpdateCalendarsRequest._();
  UpdateCalendarsRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateCalendarsRequest> createRepeated() => $pb.PbList<UpdateCalendarsRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCalendarsRequest>(create);
  static UpdateCalendarsRequest? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCalendarAction', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calendarId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'existingVersion')
    ..e<UpdateCalendarActionType>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'actionType', $pb.PbFieldType.OE, defaultOrMaker: UpdateCalendarActionType.UPDATE_CALENDAR_ACTION_TYPE_CHANGE_NAME, valueOf: UpdateCalendarActionType.valueOf, enumValues: UpdateCalendarActionType.values)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newName')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'newColor')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addHighlightedDay')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'removeHighlightedDay')
    ..hasRequiredFields = false
  ;

  UpdateCalendarAction._() : super();
  factory UpdateCalendarAction({
    $core.String? calendarId,
    $fixnum.Int64? existingVersion,
    UpdateCalendarActionType? actionType,
    $core.String? newName,
    $core.String? newColor,
    $core.String? addHighlightedDay,
    $core.String? removeHighlightedDay,
  }) {
    final _result = create();
    if (calendarId != null) {
      _result.calendarId = calendarId;
    }
    if (existingVersion != null) {
      _result.existingVersion = existingVersion;
    }
    if (actionType != null) {
      _result.actionType = actionType;
    }
    if (newName != null) {
      _result.newName = newName;
    }
    if (newColor != null) {
      _result.newColor = newColor;
    }
    if (addHighlightedDay != null) {
      _result.addHighlightedDay = addHighlightedDay;
    }
    if (removeHighlightedDay != null) {
      _result.removeHighlightedDay = removeHighlightedDay;
    }
    return _result;
  }
  factory UpdateCalendarAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCalendarAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCalendarAction clone() => UpdateCalendarAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCalendarAction copyWith(void Function(UpdateCalendarAction) updates) => super.copyWith((message) => updates(message as UpdateCalendarAction)) as UpdateCalendarAction; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarAction create() => UpdateCalendarAction._();
  UpdateCalendarAction createEmptyInstance() => create();
  static $pb.PbList<UpdateCalendarAction> createRepeated() => $pb.PbList<UpdateCalendarAction>();
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCalendarAction>(create);
  static UpdateCalendarAction? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateCalendarsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..e<UpdateCalendarsErrorReason>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: UpdateCalendarsErrorReason.UPDATE_CALENDARS_ERROR_REASON_NO_ERROR, valueOf: UpdateCalendarsErrorReason.valueOf, enumValues: UpdateCalendarsErrorReason.values)
    ..pc<CalendarDetail>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calendarDetails', $pb.PbFieldType.PM, subBuilder: CalendarDetail.create)
    ..hasRequiredFields = false
  ;

  UpdateCalendarsResponse._() : super();
  factory UpdateCalendarsResponse({
    $core.bool? success,
    UpdateCalendarsErrorReason? errorReason,
    $core.Iterable<CalendarDetail>? calendarDetails,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (errorReason != null) {
      _result.errorReason = errorReason;
    }
    if (calendarDetails != null) {
      _result.calendarDetails.addAll(calendarDetails);
    }
    return _result;
  }
  factory UpdateCalendarsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateCalendarsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateCalendarsResponse clone() => UpdateCalendarsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateCalendarsResponse copyWith(void Function(UpdateCalendarsResponse) updates) => super.copyWith((message) => updates(message as UpdateCalendarsResponse)) as UpdateCalendarsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarsResponse create() => UpdateCalendarsResponse._();
  UpdateCalendarsResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateCalendarsResponse> createRepeated() => $pb.PbList<UpdateCalendarsResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateCalendarsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateCalendarsResponse>(create);
  static UpdateCalendarsResponse? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteCalendarRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calendarId')
    ..hasRequiredFields = false
  ;

  DeleteCalendarRequest._() : super();
  factory DeleteCalendarRequest({
    $core.String? userId,
    $core.String? sessionId,
    $core.String? calendarId,
  }) {
    final _result = create();
    if (userId != null) {
      _result.userId = userId;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (calendarId != null) {
      _result.calendarId = calendarId;
    }
    return _result;
  }
  factory DeleteCalendarRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCalendarRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCalendarRequest clone() => DeleteCalendarRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCalendarRequest copyWith(void Function(DeleteCalendarRequest) updates) => super.copyWith((message) => updates(message as DeleteCalendarRequest)) as DeleteCalendarRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteCalendarRequest create() => DeleteCalendarRequest._();
  DeleteCalendarRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteCalendarRequest> createRepeated() => $pb.PbList<DeleteCalendarRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteCalendarRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCalendarRequest>(create);
  static DeleteCalendarRequest? _defaultInstance;

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteCalendarResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'success')
    ..e<DeleteCalendarErrorReason>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'errorReason', $pb.PbFieldType.OE, defaultOrMaker: DeleteCalendarErrorReason.DELETE_CALENDARS_ERROR_REASON_NO_ERROR, valueOf: DeleteCalendarErrorReason.valueOf, enumValues: DeleteCalendarErrorReason.values)
    ..hasRequiredFields = false
  ;

  DeleteCalendarResponse._() : super();
  factory DeleteCalendarResponse({
    $core.bool? success,
    DeleteCalendarErrorReason? errorReason,
  }) {
    final _result = create();
    if (success != null) {
      _result.success = success;
    }
    if (errorReason != null) {
      _result.errorReason = errorReason;
    }
    return _result;
  }
  factory DeleteCalendarResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteCalendarResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteCalendarResponse clone() => DeleteCalendarResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteCalendarResponse copyWith(void Function(DeleteCalendarResponse) updates) => super.copyWith((message) => updates(message as DeleteCalendarResponse)) as DeleteCalendarResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteCalendarResponse create() => DeleteCalendarResponse._();
  DeleteCalendarResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteCalendarResponse> createRepeated() => $pb.PbList<DeleteCalendarResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteCalendarResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteCalendarResponse>(create);
  static DeleteCalendarResponse? _defaultInstance;

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


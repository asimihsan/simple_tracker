///
//  Generated code. Do not modify.
//  source: app_preferences.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AppPreferences extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AppPreferences', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'simpletracker'), createEmptyInstance: create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isNotFirstLaunch', protoName: 'isNotFirstLaunch')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionId', protoName: 'sessionId')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userId', protoName: 'userId')
    ..hasRequiredFields = false
  ;

  AppPreferences._() : super();
  factory AppPreferences({
    $core.bool? isNotFirstLaunch,
    $core.String? sessionId,
    $core.String? userId,
  }) {
    final _result = create();
    if (isNotFirstLaunch != null) {
      _result.isNotFirstLaunch = isNotFirstLaunch;
    }
    if (sessionId != null) {
      _result.sessionId = sessionId;
    }
    if (userId != null) {
      _result.userId = userId;
    }
    return _result;
  }
  factory AppPreferences.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppPreferences.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AppPreferences clone() => AppPreferences()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AppPreferences copyWith(void Function(AppPreferences) updates) => super.copyWith((message) => updates(message as AppPreferences)) as AppPreferences; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AppPreferences create() => AppPreferences._();
  AppPreferences createEmptyInstance() => create();
  static $pb.PbList<AppPreferences> createRepeated() => $pb.PbList<AppPreferences>();
  @$core.pragma('dart2js:noInline')
  static AppPreferences getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppPreferences>(create);
  static AppPreferences? _defaultInstance;

  @$pb.TagNumber(3)
  $core.bool get isNotFirstLaunch => $_getBF(0);
  @$pb.TagNumber(3)
  set isNotFirstLaunch($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsNotFirstLaunch() => $_has(0);
  @$pb.TagNumber(3)
  void clearIsNotFirstLaunch() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(4)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(4)
  void clearSessionId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get userId => $_getSZ(2);
  @$pb.TagNumber(5)
  set userId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(5)
  $core.bool hasUserId() => $_has(2);
  @$pb.TagNumber(5)
  void clearUserId() => clearField(5);
}


///
//  Generated code. Do not modify.
//  source: app_preferences.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AppPreferences extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AppPreferences', package: const $pb.PackageName('simpletracker'), createEmptyInstance: create)
    ..aOS(1, 'username')
    ..aOS(2, 'password')
    ..aOB(3, 'isNotFirstLaunch', protoName: 'isNotFirstLaunch')
    ..aOS(4, 'sessionId', protoName: 'sessionId')
    ..aOS(5, 'userId', protoName: 'userId')
    ..hasRequiredFields = false
  ;

  AppPreferences._() : super();
  factory AppPreferences() => create();
  factory AppPreferences.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AppPreferences.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AppPreferences clone() => AppPreferences()..mergeFromMessage(this);
  AppPreferences copyWith(void Function(AppPreferences) updates) => super.copyWith((message) => updates(message as AppPreferences));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AppPreferences create() => AppPreferences._();
  AppPreferences createEmptyInstance() => create();
  static $pb.PbList<AppPreferences> createRepeated() => $pb.PbList<AppPreferences>();
  @$core.pragma('dart2js:noInline')
  static AppPreferences getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AppPreferences>(create);
  static AppPreferences _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isNotFirstLaunch => $_getBF(2);
  @$pb.TagNumber(3)
  set isNotFirstLaunch($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsNotFirstLaunch() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsNotFirstLaunch() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sessionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set sessionId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSessionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSessionId() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get userId => $_getSZ(4);
  @$pb.TagNumber(5)
  set userId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUserId() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserId() => clearField(5);
}


//
//  Generated code. Do not modify.
//  source: security.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'security.pbenum.dart';

export 'security.pbenum.dart';

/// Main message wrapper
class SecurityMessage extends $pb.GeneratedMessage {
  factory SecurityMessage({
    SecurityMessage_MsgType? msg,
    $core.List<$core.int>? payload,
  }) {
    final $result = create();
    if (msg != null) {
      $result.msg = msg;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  SecurityMessage._() : super();
  factory SecurityMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SecurityMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SecurityMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'esp_provisioning'), createEmptyInstance: create)
    ..e<SecurityMessage_MsgType>(1, _omitFieldNames ? '' : 'msg', $pb.PbFieldType.OE, defaultOrMaker: SecurityMessage_MsgType.TypeCmdGetStatus, valueOf: SecurityMessage_MsgType.valueOf, enumValues: SecurityMessage_MsgType.values)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SecurityMessage clone() => SecurityMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SecurityMessage copyWith(void Function(SecurityMessage) updates) => super.copyWith((message) => updates(message as SecurityMessage)) as SecurityMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SecurityMessage create() => SecurityMessage._();
  SecurityMessage createEmptyInstance() => create();
  static $pb.PbList<SecurityMessage> createRepeated() => $pb.PbList<SecurityMessage>();
  @$core.pragma('dart2js:noInline')
  static SecurityMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SecurityMessage>(create);
  static SecurityMessage? _defaultInstance;

  @$pb.TagNumber(1)
  SecurityMessage_MsgType get msg => $_getN(0);
  @$pb.TagNumber(1)
  set msg(SecurityMessage_MsgType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsg() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get payload => $_getN(1);
  @$pb.TagNumber(2)
  set payload($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPayload() => $_has(1);
  @$pb.TagNumber(2)
  void clearPayload() => clearField(2);
}

/// Authentication payload
class AuthPayload extends $pb.GeneratedMessage {
  factory AuthPayload({
    $core.String? username,
    $core.String? password,
  }) {
    final $result = create();
    if (username != null) {
      $result.username = username;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  AuthPayload._() : super();
  factory AuthPayload.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthPayload.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AuthPayload', package: const $pb.PackageName(_omitMessageNames ? '' : 'esp_provisioning'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AuthPayload clone() => AuthPayload()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AuthPayload copyWith(void Function(AuthPayload) updates) => super.copyWith((message) => updates(message as AuthPayload)) as AuthPayload;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AuthPayload create() => AuthPayload._();
  AuthPayload createEmptyInstance() => create();
  static $pb.PbList<AuthPayload> createRepeated() => $pb.PbList<AuthPayload>();
  @$core.pragma('dart2js:noInline')
  static AuthPayload getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthPayload>(create);
  static AuthPayload? _defaultInstance;

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
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

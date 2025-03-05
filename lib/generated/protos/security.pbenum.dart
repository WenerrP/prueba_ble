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

class SecurityMessage_MsgType extends $pb.ProtobufEnum {
  static const SecurityMessage_MsgType TypeCmdGetStatus = SecurityMessage_MsgType._(0, _omitEnumNames ? '' : 'TypeCmdGetStatus');
  static const SecurityMessage_MsgType TypeCmdSetConfig = SecurityMessage_MsgType._(1, _omitEnumNames ? '' : 'TypeCmdSetConfig');
  static const SecurityMessage_MsgType TypeCmdApplyConfig = SecurityMessage_MsgType._(2, _omitEnumNames ? '' : 'TypeCmdApplyConfig');
  static const SecurityMessage_MsgType TypeRespGetStatus = SecurityMessage_MsgType._(3, _omitEnumNames ? '' : 'TypeRespGetStatus');
  static const SecurityMessage_MsgType TypeRespSetConfig = SecurityMessage_MsgType._(4, _omitEnumNames ? '' : 'TypeRespSetConfig');
  static const SecurityMessage_MsgType TypeRespApplyConfig = SecurityMessage_MsgType._(5, _omitEnumNames ? '' : 'TypeRespApplyConfig');

  static const $core.List<SecurityMessage_MsgType> values = <SecurityMessage_MsgType> [
    TypeCmdGetStatus,
    TypeCmdSetConfig,
    TypeCmdApplyConfig,
    TypeRespGetStatus,
    TypeRespSetConfig,
    TypeRespApplyConfig,
  ];

  static final $core.Map<$core.int, SecurityMessage_MsgType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SecurityMessage_MsgType? valueOf($core.int value) => _byValue[value];

  const SecurityMessage_MsgType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');

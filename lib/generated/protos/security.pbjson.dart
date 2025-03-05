//
//  Generated code. Do not modify.
//  source: security.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use securityMessageDescriptor instead')
const SecurityMessage$json = {
  '1': 'SecurityMessage',
  '2': [
    {'1': 'msg', '3': 1, '4': 1, '5': 14, '6': '.esp_provisioning.SecurityMessage.MsgType', '10': 'msg'},
    {'1': 'payload', '3': 2, '4': 1, '5': 12, '10': 'payload'},
  ],
  '4': [SecurityMessage_MsgType$json],
};

@$core.Deprecated('Use securityMessageDescriptor instead')
const SecurityMessage_MsgType$json = {
  '1': 'MsgType',
  '2': [
    {'1': 'TypeCmdGetStatus', '2': 0},
    {'1': 'TypeCmdSetConfig', '2': 1},
    {'1': 'TypeCmdApplyConfig', '2': 2},
    {'1': 'TypeRespGetStatus', '2': 3},
    {'1': 'TypeRespSetConfig', '2': 4},
    {'1': 'TypeRespApplyConfig', '2': 5},
  ],
};

/// Descriptor for `SecurityMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List securityMessageDescriptor = $convert.base64Decode(
    'Cg9TZWN1cml0eU1lc3NhZ2USOwoDbXNnGAEgASgOMikuZXNwX3Byb3Zpc2lvbmluZy5TZWN1cm'
    'l0eU1lc3NhZ2UuTXNnVHlwZVIDbXNnEhgKB3BheWxvYWQYAiABKAxSB3BheWxvYWQilAEKB01z'
    'Z1R5cGUSFAoQVHlwZUNtZEdldFN0YXR1cxAAEhQKEFR5cGVDbWRTZXRDb25maWcQARIWChJUeX'
    'BlQ21kQXBwbHlDb25maWcQAhIVChFUeXBlUmVzcEdldFN0YXR1cxADEhUKEVR5cGVSZXNwU2V0'
    'Q29uZmlnEAQSFwoTVHlwZVJlc3BBcHBseUNvbmZpZxAF');

@$core.Deprecated('Use authPayloadDescriptor instead')
const AuthPayload$json = {
  '1': 'AuthPayload',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `AuthPayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authPayloadDescriptor = $convert.base64Decode(
    'CgtBdXRoUGF5bG9hZBIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWUSGgoIcGFzc3dvcmQYAi'
    'ABKAlSCHBhc3N3b3Jk');


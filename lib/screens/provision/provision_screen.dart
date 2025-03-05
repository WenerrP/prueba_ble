import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:prueba_ble/generated/protos/security.pb.dart';

// Constants from ESP32 WiFi Provisioning
const SERVICE_UUID = "021a9004-0382-4aea-bff4-6b3f1c5adfb4";
const PROV_INIT_UUID = "021aff51-0382-4aea-bff4-6b3f1c5adfb4";
const PROV_CONFIG_UUID = "021aff52-0382-4aea-bff4-6b3f1c5adfb4";

// Command constants
const PROTO_VER = 0x00;
const CMD_GET_STATUS = 0x01;
const CMD_SET_CONFIG = 0x02;
const CMD_APPLY_CONFIG = 0x03;

class ProvisionScreen extends StatefulWidget {
  final BluetoothDevice device;

  const ProvisionScreen({super.key, required this.device});

  @override
  State<ProvisionScreen> createState() => _ProvisionScreenState();
}

class _ProvisionScreenState extends State<ProvisionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isProvisioning = false;

  @override
  void dispose() {
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _startProvisioning() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isProvisioning = true);

      try {
        // Find provisioning service
        final services = await widget.device.discoverServices();
        final provService = services.firstWhere(
          (s) => s.uuid.toString().toLowerCase() == SERVICE_UUID.toLowerCase(),
        );

        // Get init and config characteristics
        final initChar = provService.characteristics.firstWhere(
          (c) =>
              c.uuid.toString().toLowerCase() == PROV_INIT_UUID.toLowerCase(),
        );

        final configChar = provService.characteristics.firstWhere(
          (c) =>
              c.uuid.toString().toLowerCase() == PROV_CONFIG_UUID.toLowerCase(),
        );

        // Step 1: Initialize provisioning
        print('Initializing provisioning...');
        await _initializeProvisioning(initChar);

        // Step 2: Send WiFi configuration
        print('Sending WiFi configuration...');
        await _sendWiFiConfig(configChar);

        // Step 3: Apply configuration
        print('Applying configuration...');
        await _applyConfig(configChar);

        // Step 4: Wait for status
        print('Waiting for status...');
        final success = await _waitForProvisioningStatus(configChar);

        if (success) {
          Get.snackbar(
            'Success',
            'Device provisioned successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          if (mounted) Get.back(result: true);
        } else {
          throw Exception('Provisioning failed');
        }
      } catch (e) {
        print('Provisioning error: $e');
        Get.snackbar(
          'Error',
          'Provisioning failed: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } finally {
        setState(() => _isProvisioning = false);
      }
    }
  }

  Future<void> _initializeProvisioning(BluetoothCharacteristic char) async {
    final initMsg =
        SecurityMessage()
          ..msg =
              SecurityMessage_MsgType
                  .TypeCmdGetStatus // Updated enum value
          ..payload = Uint8List.fromList([PROTO_VER]);

    await char.write(initMsg.writeToBuffer(), withoutResponse: false);
  }

  Future<void> _sendWiFiConfig(BluetoothCharacteristic char) async {
    final configMsg =
        SecurityMessage()
          ..msg =
              SecurityMessage_MsgType
                  .TypeCmdSetConfig // Updated enum value
          ..payload = Uint8List.fromList([
            CMD_SET_CONFIG,
            ...utf8.encode(_ssidController.text),
            0x00, // null terminator for SSID
            ...utf8.encode(_passwordController.text),
            0x00, // null terminator for password
          ]);

    await char.write(configMsg.writeToBuffer(), withoutResponse: false);
  }

  Future<void> _applyConfig(BluetoothCharacteristic char) async {
    final applyMsg =
        SecurityMessage()
          ..msg =
              SecurityMessage_MsgType
                  .TypeCmdApplyConfig // Updated enum value
          ..payload = Uint8List.fromList([CMD_APPLY_CONFIG]);

    await char.write(applyMsg.writeToBuffer(), withoutResponse: false);
  }

  Future<bool> _waitForProvisioningStatus(BluetoothCharacteristic char) async {
    try {
      await char.setNotifyValue(true);

      final statusMsg =
          SecurityMessage()
            ..msg = SecurityMessage_MsgType.TypeCmdGetStatus
            ..payload = Uint8List.fromList([CMD_GET_STATUS]);

      await char.write(statusMsg.writeToBuffer(), withoutResponse: false);

      final response = await char.value.first.timeout(
        const Duration(seconds: 30),
      );

      final responseMsg = SecurityMessage.fromBuffer(response);
      return responseMsg.payload[0] == 0x00; // Success status
    } finally {
      await char.setNotifyValue(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provision ${widget.device.platformName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _ssidController,
                decoration: const InputDecoration(
                  labelText: 'WiFi SSID',
                  hintText: 'Enter WiFi network name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter WiFi SSID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'WiFi Password',
                  hintText: 'Enter WiFi password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter WiFi password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isProvisioning ? null : _startProvisioning,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isProvisioning
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text(
                          'START PROVISIONING',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

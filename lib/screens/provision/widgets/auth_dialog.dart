import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:prueba_ble/generated/protos/security.pb.dart';

const String PROV_SERVICE_UUID = "021a9004-0382-4aea-bff4-6b3f1c5adfb4";
const String PROV_INIT_UUID = "021aff51-0382-4aea-bff4-6b3f1c5adfb4";
const String PROV_CONFIG_UUID = "021aff52-0382-4aea-bff4-6b3f1c5adfb4";

class AuthDialog extends StatefulWidget {
  final BluetoothDevice device;

  const AuthDialog({super.key, required this.device});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isAuthenticating = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isAuthenticating = true);

      try {
        // Connection setup with MTU negotiation
        if (await widget.device.connectionState.first !=
            BluetoothConnectionState.connected) {
          print('Connecting to device...');
          await widget.device.connect(timeout: const Duration(seconds: 15));
          await Future.delayed(const Duration(milliseconds: 1000));

          // Request MTU update
          await widget.device.requestMtu(512);
          await Future.delayed(const Duration(milliseconds: 500));
        }

        print('Discovering services...');
        final services = await widget.device.discoverServices();

        final provService = services.firstWhere(
          (s) =>
              s.uuid.toString().toLowerCase() ==
              PROV_SERVICE_UUID.toLowerCase(),
        );
        print('Found provisioning service: ${provService.uuid}');

        final initChar = provService.characteristics.firstWhere(
          (c) =>
              c.uuid.toString().toLowerCase() == PROV_INIT_UUID.toLowerCase(),
        );
        print('Found init characteristic: ${initChar.uuid}');

        // Create smaller auth message
        print('Creating auth message...');
        final authPayload =
            AuthPayload()
              ..username = _usernameController.text
              ..password = _passwordController.text;

        final message =
            SecurityMessage()
              ..msg = SecurityMessage_MsgType.TypeCmdSetConfig
              ..payload = authPayload.writeToBuffer();

        final bytes = message.writeToBuffer();
        print('Message size: ${bytes.length} bytes');

        // Split message if needed
        final chunkSize = 20; // BLE standard MTU - overhead
        for (var i = 0; i < bytes.length; i += chunkSize) {
          final end =
              (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
          final chunk = bytes.sublist(i, end);

          bool writeSuccess = false;
          for (int retry = 0; retry < 3; retry++) {
            try {
              await initChar.write(
                chunk,
                withoutResponse: true, // Changed to write without response
              );
              writeSuccess = true;
              break;
            } catch (e) {
              print('Write attempt ${retry + 1} failed: $e');
              await Future.delayed(const Duration(milliseconds: 500));

              // Try to reconnect if disconnected
              if (await widget.device.connectionState.first !=
                  BluetoothConnectionState.connected) {
                await widget.device.connect();
                await Future.delayed(const Duration(milliseconds: 500));
              }
            }
          }

          if (!writeSuccess) {
            throw Exception('Failed to write chunk ${i ~/ chunkSize}');
          }

          // Small delay between chunks
          await Future.delayed(const Duration(milliseconds: 100));
        }

        print('Auth message sent successfully');
        Get.back(result: true);
      } catch (e) {
        print('Authentication error: $e');
        Get.snackbar(
          'Error',
          'Authentication failed: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } finally {
        setState(() => _isAuthenticating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Connect to ${widget.device.platformName}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'Enter username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
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
                  return 'Please enter password';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAuthenticating ? null : () => Get.back(result: false),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _isAuthenticating ? null : _handleSubmit,
          child:
              _isAuthenticating
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('CONNECT'),
        ),
      ],
    );
  }
}

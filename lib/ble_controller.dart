import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class BleController extends GetxController {
  Timer? _scanTimer;
  bool _isScanning = false;
  bool _isConnected = false;
  final List<ScanResult> _scanResults = [];
  final int _scanInterval = 10; // seconds between scans

  // Getters
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  List<ScanResult> get scanResults => _scanResults;

  @override
  void onInit() {
    super.onInit();
    // Start automatic scanning when controller initializes
    startAutoScan();
  }

  @override
  void onClose() {
    stopAutoScan();
    super.onClose();
  }

  Future<void> startAutoScan() async {
    if (_scanTimer != null) return;

    // Initial scan
    if (await checkPermissions()) {
      await scanDevices();
    }

    // Setup periodic scan
    _scanTimer = Timer.periodic(Duration(seconds: _scanInterval), (
      timer,
    ) async {
      if (await checkPermissions() && !_isScanning) {
        await scanDevices();
      }
    });
  }

  void stopAutoScan() {
    _scanTimer?.cancel();
    _scanTimer = null;
    FlutterBluePlus.stopScan();
  }

  Future<bool> checkPermissions() async {
    try {
      // Check platform support first
      if (!await FlutterBluePlus.isSupported) {
        print("Bluetooth not supported");
        return false;
      }

      // Check Bluetooth adapter state
      if (await FlutterBluePlus.adapterState.first !=
          BluetoothAdapterState.on) {
        print("Bluetooth is not turned on");
        return false;
      }

      // Request all required permissions at once
      var status =
          await [
            Permission.bluetoothScan,
            Permission.bluetoothConnect,
            Permission.location,
          ].request();

      // Debug print each permission status
      status.forEach((permission, status) {
        print('$permission: $status');
      });

      // Check if all permissions are granted
      if (status.values.every((status) => status.isGranted)) {
        print("All permissions granted");
        return true;
      } else {
        print("Some permissions were denied");
        return false;
      }
    } catch (e) {
      print("Error checking permissions: $e");
      return false;
    }
  }

  Future<void> scanDevices() async {
    if (_isScanning ||
        (_isConnected && (_scanTimer == null || !_scanTimer!.isActive)))
      return;

    try {
      _isScanning = true;
      _scanResults.clear();
      update();

      // Ensure scanning is stopped before starting a new scan
      if (await FlutterBluePlus.isScanning.first) {
        await FlutterBluePlus.stopScan();
      }

      print("Starting scan...");

      // Start scanning with a subscription
      var subscription = FlutterBluePlus.scanResults.listen(
        (results) {
          print("Found ${results.length} devices");
          _scanResults.clear();
          _scanResults.addAll(results);
          update();
        },
        onError: (error) {
          print("Error scanning: $error");
          _isScanning = false;
          update();
        },
      );

      // Start the actual scan
      await FlutterBluePlus.startScan(
            timeout: const Duration(seconds: 4),
            androidUsesFineLocation: true,
          )
          .then((_) {
            print("Scan completed");
            _isScanning = false;
            subscription.cancel();
            update();
          })
          .catchError((error) {
            print("Error starting scan: $error");
            _isScanning = false;
            subscription.cancel();
            update();
          });
    } catch (e) {
      print("Exception during scan: $e");
      _isScanning = false;
      update();
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      // Stop auto scanning
      stopAutoScan();

      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      device.connectionState.listen((BluetoothConnectionState state) {
        switch (state) {
          case BluetoothConnectionState.connected:
            print('Device connected: ${device.platformName}');
            _isConnected = true;
            update();
            break;
          case BluetoothConnectionState.disconnected:
            print('Device disconnected: ${device.platformName}');
            _isConnected = false;
            // Restart auto scanning when device disconnects
            startAutoScan();
            update();
            break;
          case BluetoothConnectionState.connecting:
            print('Device connecting: ${device.platformName}');
            break;
          case BluetoothConnectionState.disconnecting:
            print('Device disconnecting: ${device.platformName}');
            break;
        }
      });
    } catch (e) {
      print('Error connecting to device: $e');
      _isConnected = false;
      // Restart auto scanning if connection fails
      startAutoScan();
      update();
    }
  }
}

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prueba_ble/ble_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Changed from MaterialApp to GetMaterialApp
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BleController controller = Get.put(BleController());

  @override
  void initState() {
    super.initState();
    // Start auto-scanning when the page loads
    controller.startAutoScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("BLE SCANNER"),
      ),
      body: GetBuilder<BleController>(
        // Wrap with GetBuilder for automatic updates
        builder:
            (controller) => Column(
              children: [
                // Scanning Indicator
                StreamBuilder<bool>(
                  stream: FlutterBluePlus.isScanning,
                  initialData: false,
                  builder: (c, snapshot) {
                    if (snapshot.data == true) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox(height: 8.0);
                  },
                ),

                // Device List
                Expanded(
                  child: StreamBuilder<List<ScanResult>>(
                    stream: FlutterBluePlus.scanResults,
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No devices found',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final result = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            child: ListTile(
                              title: Text(
                                result.device.platformName.isEmpty
                                    ? 'Unknown Device'
                                    : result.device.platformName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'ID: ${result.device.remoteId.str}',
                              ),
                              trailing: Text('${result.rssi} dBm'),
                              onTap:
                                  () =>
                                      controller.connectToDevice(result.device),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Single Scan Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed:
                        controller.isScanning || controller.isConnected
                            ? null
                            : () => controller.scanDevices(),
                    child: Text(
                      controller.isConnected
                          ? "CONNECTED"
                          : (controller.isScanning
                              ? "SCANNING..."
                              : "SCAN DEVICES"),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  @override
  void dispose() {
    controller.stopAutoScan(); // Clean up when the page is disposed
    super.dispose();
  }
}

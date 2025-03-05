import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/ble_controller.dart';
import '../provision/provision_screen.dart';
import 'widgets/device_list.dart';
import 'widgets/scanning_indicator.dart';
import '../provision/widgets/auth_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BleController controller = Get.put(BleController());

  @override
  void initState() {
    super.initState();
    controller.startAutoScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("ESP32 Provisioning"),
        actions: [
          GetBuilder<BleController>(
            builder:
                (controller) => IconButton(
                  icon: const Icon(Icons.search),
                  onPressed:
                      controller.isScanning ? null : controller.scanDevices,
                ),
          ),
        ],
      ),
      body: GetBuilder<BleController>(
        builder:
            (controller) => Column(
              children: [
                const ScanningIndicator(),
                Expanded(
                  child: DeviceList(
                    controller: controller,
                    onDeviceSelected: (device) async {
                      bool? authenticated = await Get.dialog<bool>(
                        AuthDialog(device: device),
                        barrierDismissible: false,
                      );

                      if (authenticated == true) {
                        Get.to(() => ProvisionScreen(device: device));
                      }
                    },
                  ),
                ),
              ],
            ),
      ),
    );
  }

  @override
  void dispose() {
    controller.stopAutoScan();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../controllers/ble_controller.dart';

class DeviceList extends StatelessWidget {
  final BleController controller;
  final Function(BluetoothDevice) onDeviceSelected;

  const DeviceList({
    super.key,
    required this.controller,
    required this.onDeviceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanResult>>(
      stream: FlutterBluePlus.scanResults,
      initialData: const [],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No devices found', style: TextStyle(fontSize: 16)),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final result = snapshot.data![index];
            final isDeviceConnected = controller.isDeviceConnected(
              result.device,
            );

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        result.device.platformName.isEmpty
                            ? 'Unknown Device'
                            : result.device.platformName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDeviceConnected ? Colors.blue : null,
                        ),
                      ),
                    ),
                    if (isDeviceConnected)
                      const Text(
                        'Connected',
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                  ],
                ),
                subtitle: Text('ID: ${result.device.remoteId.str}'),
                trailing: Text('${result.rssi} dBm'),
                onTap: () => onDeviceSelected(result.device),
              ),
            );
          },
        );
      },
    );
  }
}

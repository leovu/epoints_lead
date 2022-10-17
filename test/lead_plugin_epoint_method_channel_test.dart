import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lead_plugin_epoint/lead_plugin_epoint_method_channel.dart';

void main() {
  MethodChannelLeadPluginEpoint platform = MethodChannelLeadPluginEpoint();
  const MethodChannel channel = MethodChannel('lead_plugin_epoint');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

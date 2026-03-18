import 'package:flutter_test/flutter_test.dart';
import 'package:lead_plugin_epoint/lead_plugin_epoint.dart';
import 'package:lead_plugin_epoint/lead_plugin_epoint_platform_interface.dart';
import 'package:lead_plugin_epoint/lead_plugin_epoint_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLeadPluginEpointPlatform
    with MockPlatformInterfaceMixin
    implements LeadPluginEpointPlatform {

  @override
  Future<String> getPlatformVersion() => Future.value('42');
}

void main() {
  final LeadPluginEpointPlatform initialPlatform = LeadPluginEpointPlatform.instance;

  test('$MethodChannelLeadPluginEpoint is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLeadPluginEpoint>());
  });

  test('getPlatformVersion', () async {
    LeadPluginEpoint leadPluginEpointPlugin = LeadPluginEpoint();
    MockLeadPluginEpointPlatform fakePlatform = MockLeadPluginEpointPlatform();
    LeadPluginEpointPlatform.instance = fakePlatform;

    expect(await leadPluginEpointPlugin.getPlatformVersion(), '42');
  });
}

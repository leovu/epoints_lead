import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'lead_plugin_epoint_platform_interface.dart';

/// An implementation of [LeadPluginEpointPlatform] that uses method channels.
class MethodChannelLeadPluginEpoint extends LeadPluginEpointPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('lead_plugin_epoint');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'lead_plugin_epoint_method_channel.dart';

abstract class LeadPluginEpointPlatform extends PlatformInterface {
  /// Constructs a LeadPluginEpointPlatform.
  LeadPluginEpointPlatform() : super(token: _token);

  static final Object _token = Object();

  static LeadPluginEpointPlatform _instance = MethodChannelLeadPluginEpoint();

  /// The default instance of [LeadPluginEpointPlatform] to use.
  ///
  /// Defaults to [MethodChannelLeadPluginEpoint].
  static LeadPluginEpointPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LeadPluginEpointPlatform] when
  /// they register themselves.
  static set instance(LeadPluginEpointPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

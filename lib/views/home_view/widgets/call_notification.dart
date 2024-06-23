import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_chat_room/core/keys.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallNotification extends ConsumerWidget {
  const CallNotification({
    super.key,
    required this.child,
    required this.username,
  });

  final Widget child;
  final String username;
  @override
  Widget build(BuildContext context, ref) {
    return ZegoUIKitPrebuiltCall(
      callID: username,
      appID: StaticKeys.appID,
      appSign: StaticKeys.appSign,
      userID: username,
      userName: username,
      plugins: [ZegoUIKitSignalingPlugin()],
      config: ZegoUIKitPrebuiltCallConfig(),
    );
  }
}

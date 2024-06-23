import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_chat_room/core/keys.dart';
import 'package:zego_chat_room/viewmodels/auth_view_model.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallView extends ConsumerWidget {
  const CallView({
    required this.callID,
    super.key,
  });

  final String callID;
  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(authViewModelProvider);
    return ZegoUIKitPrebuiltCall(
      appID: StaticKeys.appID,
      appSign: StaticKeys.appSign,
      callID: callID,
      userID: user!.email,
      userName: user.email,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
}

import 'package:zego_chat_room/core/keys.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class VoiceChatModel {
  VoiceChatModel({
    required this.appID,
    required this.appSign,
    required this.callID,
    this.userID,
    this.userName,
  });

  final int appID;
  final String appSign;
  final String callID;
  final String? userID;
  final String? userName;

  void init() {
    ZegoUIKitPrebuiltCall(
      appID: StaticKeys.appID,
      appSign: StaticKeys.appSign,
      callID: callID,
      userID: userID ?? 'random',
      userName: userName ?? 'random',
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
}

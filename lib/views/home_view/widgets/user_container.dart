import 'package:flutter/material.dart';
import 'package:zego_chat_room/core/keys.dart';
import 'package:zego_chat_room/core/services/auth_service.dart';
import 'package:zego_chat_room/models/user_model.dart';
import 'package:zego_chat_room/viewmodels/auth_view_model.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class UserContainer extends StatefulWidget {
  const UserContainer({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  State<UserContainer> createState() => _UserContainerState();
}

class _UserContainerState extends State<UserContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.05),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 25,
              child: Center(
                child: Text(
                  widget.user.username!.substring(0, 1).toUpperCase(),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              widget.user.username!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            // audio call button
            SizedBox(
              width: 50,
              child: actionButton(false),
            ),
            // video call button
            SizedBox(
              width: 50,
              child: actionButton(true),
            ),
          ],
        ),
      ),
    );
  }

  ZegoSendCallInvitationButton actionButton(bool isVideo) {
    Future<void> onUserLogin() async {
      ZegoUIKitSignalingPlugin signaling = ZegoUIKitSignalingPlugin();
      await signaling.init(
        appID: StaticKeys.appID,
        appSign: StaticKeys.appSign,
      );
      ZIMCallInviteConfig callInviteConfig = ZIMCallInviteConfig();
      callInviteConfig.timeout = 200;
      ZIMPushConfig pushConfig = ZIMPushConfig();
      pushConfig.title = "your title";
      pushConfig.content = "your content";
      pushConfig.payload = "your payload";
      //config.pushConfig = pushConfig;

      ZIM
          .getInstance()!
          .callInvite([widget.user.username!], callInviteConfig)
          .then((value) {})
          .catchError(
            (onError) {},
          );

      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: StaticKeys.appID,
        appSign: StaticKeys.appSign,
        userID: AuthViewModel().currentUser.id.toString(),
        userName: AuthViewModel().currentUser.username!,
        plugins: [
          signaling,
        ],
        invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(),
        config: ZegoCallInvitationConfig(
          /// Remember to set this to true here.
          canInvitingInCalling: true,
        ),
      );
    }

    onUserLogin();
    return ZegoSendCallInvitationButton(
      iconSize: const Size(50, 50),
      isVideoCall: isVideo,
      resourceID: "zegouikit_call",
      invitees: [
        ZegoUIKitUser(
          id: widget.user.username!,
          name: widget.user.username!,
        ),
      ],
      onPressed: (code, message, p2) {},
    );
  }
}

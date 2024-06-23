import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_chat_room/viewmodels/auth_view_model.dart';
import 'package:zego_chat_room/views/auth_view/login_view.dart';
import 'package:zego_chat_room/views/home_view/home_view.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthViewModel.setupFirebase();

  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [
        ZegoUIKitSignalingPlugin(),
      ],
    );

    runApp(
      const ProviderScope(
        child: ZegoApp(),
      ),
    );
  });
}

class ZegoApp extends ConsumerWidget {
  const ZegoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData.dark(),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({
    super.key,
  });
  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(authViewModelProvider);
    return user == null ? LoginView() : HomeView();
  }
}

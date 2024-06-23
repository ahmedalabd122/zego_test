import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_chat_room/core/keys.dart';
import 'package:zego_chat_room/models/user_model.dart';
import 'package:zego_chat_room/models/voice_chat_model.dart';

final voiceChatProvider =
    Provider.family<VoiceChatViewModel, Map<String,UserModel> >((ref, data) {
  return VoiceChatViewModel(
    VoiceChatModel(
      appID: StaticKeys.appID,
      appSign: StaticKeys.appSign,
      callID: data.keys.first,
      userID: data.values.first.username,
      userName: data.values.first.username,
    ),
  );
});

class VoiceChatViewModel {
  final VoiceChatModel _voiceChatModel;

  VoiceChatViewModel(this._voiceChatModel);

  void initialize() {
    _voiceChatModel.init();
  }
}

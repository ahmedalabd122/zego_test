import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zego_chat_room/models/user_model.dart';
import 'package:zego_chat_room/viewmodels/auth_view_model.dart';
import 'package:zego_chat_room/viewmodels/call_view_model.dart';
import 'package:zego_chat_room/views/call_view/call_view.dart';
import 'package:zego_chat_room/views/home_view/widgets/user_container.dart';

class HomeView extends ConsumerWidget {
  HomeView({super.key});
  final joinFormKey = GlobalKey<FormState>(debugLabel: 'joinFormKey');
  final code = TextEditingController();
  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(authViewModelProvider);
    final currentUser = UserModel(
      email: user!.email,
      id: user.id,
      username: user.username,
    );
    VoiceChatViewModel viewModel = ref.watch(voiceChatProvider({
      code.text: currentUser,
    }));
    final authViewModel = ref.watch(authViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome back,${user.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authViewModel.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Text('join with code'),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: joinFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: code,
                    keyboardType: TextInputType.emailAddress,
                    keyboardAppearance: Brightness.dark,
                    decoration: InputDecoration(
                      labelText: 'code',
                      hintText: '123123',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      viewModel =
                          ref.read(voiceChatProvider({code.text: currentUser}));
                      viewModel.initialize();
                      if (joinFormKey.currentState!.validate()) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CallView(
                              callID: code.text,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Join'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('call with contact'),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: authViewModel.buildViews,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<QueryDocumentSnapshot>? docs = snapshot.data?.docs;
                  if (docs == null || docs.isEmpty) {
                    return const Text('No data');
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final model = UserModel.fromJson(
                        docs[index].data() as Map<String, dynamic>,
                      );
                      if (model.username != user!.username) {
                        return UserContainer(user: model);
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

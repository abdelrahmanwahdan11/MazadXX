import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/services/format_service.dart';
import '../../domain/entities/entities.dart';
import '../controllers/messages_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final MessagesController controller = Get.find<MessagesController>();
  final FormatService formatService = Get.find<FormatService>();
  final TextEditingController composerController = TextEditingController();
  final RxList<Message> messages = <Message>[].obs;
  String? _threadId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = Get.parameters['id'];
    if (id != null && id != _threadId) {
      _threadId = id;
      controller.loadMessages(id).then(messages.assignAll);
    }
  }

  @override
  void dispose() {
    composerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('chat'.tr)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (messages.isEmpty) {
                  return Center(child: Text('no_messages_yet'.tr));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(24),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == 'u_01';
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
                              : Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message.text),
                            const SizedBox(height: 4),
                            Text(
                              formatService.dateTimeShort(message.time),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: composerController,
                      decoration: InputDecoration(labelText: 'type_message'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _send,
                    child: Text('send'.tr),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final text = composerController.text.trim();
    final threadId = _threadId;
    if (text.isEmpty || threadId == null) {
      return;
    }
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      threadId: threadId,
      senderId: 'u_01',
      text: text,
      image: null,
      time: DateTime.now(),
    );
    messages.insert(0, message);
    composerController.clear();
    await controller.sendMessage(threadId, message);
  }
}

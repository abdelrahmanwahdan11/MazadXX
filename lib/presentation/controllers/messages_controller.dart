import 'package:get/get.dart';

import '../../application/services/action_log.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/usecases.dart';

class MessagesController extends GetxController {
  MessagesController({
    required this.getThreadsUseCase,
    required this.getMessagesUseCase,
    required this.addMessageUseCase,
    required this.actionLog,
  });

  final GetThreadsUseCase getThreadsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final AddMessageUseCase addMessageUseCase;
  final ActionLog actionLog;

  final RxList<ChatThread> threads = <ChatThread>[].obs;
  final RxBool isLoading = false.obs;
  final RxSet<String> unreadThreads = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadThreads();
  }

  Future<void> loadThreads() async {
    isLoading.value = true;
    final data = await getThreadsUseCase();
    threads.assignAll(data);
    unreadThreads.addAll(data.map((ChatThread e) => e.id));
    isLoading.value = false;
  }

  Future<List<Message>> loadMessages(String threadId) async {
    unreadThreads.remove(threadId);
    return getMessagesUseCase(threadId);
  }

  Future<void> sendMessage(String threadId, Message message) async {
    await addMessageUseCase(threadId, message);
    actionLog.add('chat:$threadId');
  }
}

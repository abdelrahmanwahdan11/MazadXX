import '../../domain/entities/entities.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_thread_model.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl();

  final List<ChatThreadModel> _threads = <ChatThreadModel>[
    ChatThreadModel(
      id: 't_01',
      users: const <String>['u_01', 'u_02'],
      lastMessage: 'Ready to ship tomorrow!',
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatThreadModel(
      id: 't_02',
      users: const <String>['u_03', 'u_05'],
      lastMessage: 'Can you share more photos?',
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  final Map<String, List<MessageModel>> _messages = <String, List<MessageModel>>{
    't_01': <MessageModel>[
      MessageModel(
        id: 'm_01',
        threadId: 't_01',
        senderId: 'u_02',
        text: 'Interested in the iPhone, is it still available?',
        image: null,
        time: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      MessageModel(
        id: 'm_02',
        threadId: 't_01',
        senderId: 'u_01',
        text: 'Yes, ready to ship tomorrow!',
        image: null,
        time: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ],
    't_02': <MessageModel>[
      MessageModel(
        id: 'm_03',
        threadId: 't_02',
        senderId: 'u_03',
        text: 'Looking for additional photos please.',
        image: null,
        time: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
  };

  @override
  Future<List<ChatThread>> fetchThreads() async {
    _threads.sort((ChatThreadModel a, ChatThreadModel b) => b.updatedAt.compareTo(a.updatedAt));
    return List<ChatThread>.unmodifiable(_threads);
  }

  @override
  Future<List<Message>> fetchMessages(String threadId) async {
    final list = _messages.putIfAbsent(threadId, () => <MessageModel>[]);
    list.sort((MessageModel a, MessageModel b) => a.time.compareTo(b.time));
    return List<Message>.unmodifiable(list);
  }

  @override
  Future<void> addMessage(String threadId, Message message) async {
    final list = _messages.putIfAbsent(threadId, () => <MessageModel>[]);
    final model = message is MessageModel
        ? message
        : MessageModel(
            id: message.id,
            threadId: threadId,
            senderId: message.senderId,
            text: message.text,
            image: message.image,
            time: message.time,
          );
    list.add(model);
    final index = _threads.indexWhere((ChatThreadModel element) => element.id == threadId);
    if (index >= 0) {
      final thread = _threads[index];
      _threads[index] = ChatThreadModel(
        id: thread.id,
        users: thread.users,
        lastMessage: model.text,
        updatedAt: model.time,
      );
    }
  }
}

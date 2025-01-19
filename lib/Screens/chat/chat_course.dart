import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/chat/chat_bubble.dart';
import '../../Components/chat/file_selector_dialog.dart';
import '../../Models/Canvas/course.dart';
import '../../Providers/chat/chat_provider.dart';
import '../../Providers/http_provider.dart';

class ChatCourse extends StatefulWidget {
  final Course course;

  const ChatCourse({super.key, required this.course});

  @override
  State<ChatCourse> createState() => _ChatCourseState();
}

class _ChatCourseState extends State<ChatCourse> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().loadMessages(widget.course.id);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
        actions: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return DropdownButton<ChatModel>(
                value: chatProvider.currentModel,
                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                style: Theme.of(context).textTheme.bodyMedium,
                underline: Container(),
                items: ChatModel.values.map((ChatModel model) {
                  return DropdownMenuItem<ChatModel>(
                    value: model,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        model.name.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (ChatModel? newValue) {
                  if (newValue != null) {
                    final themeProvider = HttpProvider().themeProvider;
                    if (newValue == ChatModel.openai &&
                        themeProvider.settingsData.openAiApiKey == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please set OpenAI API key in settings'),
                        ),
                      );
                      return;
                    }
                    if (newValue == ChatModel.gemini &&
                        themeProvider.settingsData.geminiApiKey == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please set Gemini API key in settings'),
                        ),
                      );
                      return;
                    }
                    chatProvider.setModel(newValue);
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => FileSelectorDialog(
                  chatId: widget.course.id,
                  courseId: widget.course.id,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                final messages =
                    chatProvider.chatSenders[widget.course.id]?.messages ?? [];

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom();
                });

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet\nStart a conversation!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: messages[index]);
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<ChatProvider>(
                    builder: (context, provider, child) {
                      final files =
                          provider.chatSenders[widget.course.id]?.files ?? {};
                      if (files.isEmpty) return const SizedBox.shrink();

                      return Container(
                        height: 40,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: files.keys.map(
                            (fileName) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      fileName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () => provider.clearFile(
                                          fileName, widget.course.id),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context
                              .read<ChatProvider>()
                              .clearChat(widget.course.id);
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              context.read<ChatProvider>().addMessage(
                                    value,
                                    widget.course.id,
                                  );
                              _controller.clear();
                              _scrollToBottom();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            context.read<ChatProvider>().addMessage(
                                  _controller.text,
                                  widget.course.id,
                                );
                            _controller.clear();
                            _scrollToBottom();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

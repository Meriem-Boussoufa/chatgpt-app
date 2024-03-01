import 'dart:developer';
import 'package:chatgpt_app/constants/constants.dart';
import 'package:chatgpt_app/providers/models_rpovider.dart';
import 'package:chatgpt_app/services/api_service.dart';
import 'package:chatgpt_app/services/assets_manager.dart';
import 'package:chatgpt_app/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../models/chat.dart';
import '../providers/chats_provider.dart';
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ScrollController _listScrollController;
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<Chat> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatsProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.openaiLogo),
          ),
          title: const Text(
            'ChatGPT',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await Services.showModalSheet(context: context);
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        body: SafeArea(
            child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatsProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatsProvider.getChatList[index].msg,
                    chatIndex: chatsProvider.getChatList[index].chatIndex,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(height: 15),
            Material(
              color: cardColor,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    focusNode: focusNode,
                    style: const TextStyle(color: Colors.white),
                    controller: textEditingController,
                    onSubmitted: (value) async {
                      await sendMessageFCT(
                        modelsProvider: modelsProvider,
                        chatsProvider: chatsProvider,
                      );
                    },
                    decoration: const InputDecoration.collapsed(
                        hintText: "How can i help you ?",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        )),
                  )),
                  IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                          modelsProvider: modelsProvider,
                          chatsProvider: chatsProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ))
                ],
              ),
            )
          ],
        )));
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatsProvider}) async {
    try {
      setState(() {
        _isTyping = true;
        //chatList.add(Chat(msg: textEditingController.text, chatIndex: 0));
        chatsProvider.addUserMessage(msg: textEditingController.text);
        textEditingController.clear();
        focusNode.unfocus();
      });
      log("Request has been sent");
      await chatsProvider.sendMessageAndGetAnswers(
          msg: textEditingController.text,
          chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (e) {
      log("error : $e");
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}

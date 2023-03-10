import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:template/src/screens/chat/bloc/chat_cubit.dart';
import 'package:template/src/screens/chat/widgets/bottom_text_field.dart';
import 'package:template/src/screens/chat/widgets/message_item.dart';

import '../../../global/style/app_images.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _controller = ScrollController();

  void _sendMessage(String text) {
    context.read<ChatCubit>().sendMessage(text);
  }

  void _scrollToBottom() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff454654),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (previous, current) {
                  return (current is ChatDataState);
                },
                builder: (context, state) {
                  return state.message.isEmpty ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        padding: const EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          AppImages.iUser,
                          color: Colors.white30,
                        ),
                      ),
                      const Text(
                        'Say something!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white30,
                        ),
                      )
                    ],
                  ) : ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return MessageItem(
                        message: state.message[index],
                      );
                    },
                    itemCount: state.message.length,
                  );
                },
              ),
            ),
            BottomChatField(
              onSend: (text) => _sendMessage(text),
              scrollToBottom: () => _scrollToBottom(),
            ),
          ],
        ),
      ),
    );
  }
}

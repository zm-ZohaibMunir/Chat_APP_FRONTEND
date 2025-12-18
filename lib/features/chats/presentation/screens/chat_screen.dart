import 'package:chat_app/core/theme/custom_text_styles.dart';
import 'package:chat_app/core/theme/custom_theme_provider.dart';
import 'package:chat_app/core/widgets/custom_loader.dart';
import 'package:chat_app/features/home/presentation/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/theme_colors.dart';
import '../../../../core/utils/utils.dart';
import '../../../settings/presentation/providers/profile_provider.dart';
import '../../domain/entities/message_entity.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatProvider _chatProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This is safe and runs before the widget is fully built
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
  }


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callFunctions();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ChatProvider>().fetchHistory(
        partnerId: widget.userId,
        isLoadMore: true,
      );
    }
  }

  @override
  void dispose() {
    _chatProvider.stopPolling();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSend() async {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;

    try {
      await context.read<ChatProvider>().sendMessage(
        partnerId: widget.userId,
        text: text,
      );
      _messageController.clear();
    } catch (e) {
      if (!mounted) return;
      showError(context, e.toString());
    }
  }

  void callFunctions() async {
    _chatProvider.clearMessages();
    await _chatProvider.fetchHistory(partnerId: widget.userId);
    _chatProvider.startPolling(widget.userId);
    await _chatProvider.markAsRead(partnerId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Consumer2<UsersProvider, CustomThemeProvider>(
          builder: (context, up, ctp, child) {
            bool isDarkMode = ctp.isDarkMode;
            // Find the user by ID
            final user = up.users.firstWhere(
              (u) => u.id == widget.userId,
              orElse: () => throw Exception("User not found in provider"),
            );
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles().medium2Text(isDarkMode: isDarkMode),
                ),
                Text(
                  DateTime.now().difference(user.lastSeen).inMinutes < 1
                      ? "Online"
                      : formatLastSeen(user.lastSeen),
                  style: CustomTextStyles().small2Text(
                    isDarkMode: isDarkMode,
                    isSuccess:
                        DateTime.now().difference(user.lastSeen).inMinutes < 1,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer2<ChatProvider, CustomThemeProvider>(
                builder: (context, chatProvider, ctp, child) {
                  final isDarkMode = ctp.isDarkMode;

                  final messages = chatProvider.messages;

                  if (chatProvider.isLoadingHistory && messages.isEmpty) {
                    return CustomDataLoader(
                      strokeWidth: 3,
                      loaderColor: isDarkMode
                          ? DarkThemeColors.primaryColor
                          : LightThemeColors.primaryColor,
                      height: 50.h,
                      width: 50.w,
                    );
                  }

                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        "No messages yet. Say hi!",
                        style: CustomTextStyles().small2Text(
                          isDarkMode: isDarkMode,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    itemCount:
                        messages.length +
                        (chatProvider.isLoadingHistory ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == messages.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: CustomDataLoader(
                              strokeWidth: 3,
                              loaderColor: isDarkMode
                                  ? DarkThemeColors.primaryColor
                                  : LightThemeColors.primaryColor,
                              height: 50.h,
                              width: 50.w,
                            ),
                          ),
                        );
                      }

                      final message = messages[index];
                      // Replace this with your Message Bubble Widget later
                      return _buildMessageBubble(message, isDarkMode);
                    },
                  );
                },
              ),
            ), // Messages list will go here
            Consumer<ProfileProvider>(
              builder: (context, pp, child) {
                return _buildInputArea(pp.user?.isAllowed ?? false);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(bool isAllowed) {
    if (isAllowed) {
      return Consumer2<CustomThemeProvider, ChatProvider>(
        builder: (context, ctp, cp, child) {
          bool isDarkMode = ctp.isDarkMode;

          // Resolve colors based on theme
          Color mainTextColor = isDarkMode
              ? DarkThemeColors.mainTextColor
              : LightThemeColors.mainTextColor;
          Color hintColor = isDarkMode
              ? DarkThemeColors.lightTextColor
              : LightThemeColors.lightTextColor;
          Color primaryColor = isDarkMode
              ? DarkThemeColors.primaryColor
              : LightThemeColors.primaryColor;
          Color surfaceColor = isDarkMode
              ? DarkThemeColors.surfaceColor
              : LightThemeColors.surfaceColor;
          Color borderColor = isDarkMode
              ? DarkThemeColors.inputBorderColor
              : LightThemeColors.inputBorderColor;
          Color focusedBorderColor = isDarkMode
              ? DarkThemeColors.inputFocusedBorderColor
              : LightThemeColors.inputFocusedBorderColor;

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            color: surfaceColor, // Matching surface color from your theme
            child: TextFormField(
              controller: _messageController,
              enabled: isAllowed,
              style: TextStyle(color: mainTextColor),
              decoration: InputDecoration(
                hintText: isAllowed ? "Type a message..." : "You are blocked",
                hintStyle: TextStyle(color: hintColor),
                filled: true,
                fillColor: isDarkMode
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF1F3F4),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(color: focusedBorderColor, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide(
                    color: borderColor.withValues(alpha: 0.5),
                  ),
                ),

                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: cp.isSending
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: primaryColor,
                            ),
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.send_rounded,
                            color: isAllowed ? primaryColor : hintColor,
                          ),
                          onPressed: isAllowed ? _handleSend : null,
                        ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Consumer<CustomThemeProvider>(
        builder: (context, ctp, child) {
          bool isDarkMode = ctp.isDarkMode;
          return Container(
            padding: EdgeInsets.all(8.w),
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? DarkThemeColors.appbarBackground
                  : LightThemeColors.appbarBackground,
              border: Border.all(
                color: isDarkMode
                    ? DarkThemeColors.primaryColor
                    : LightThemeColors.primaryColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.h)),
            ),
            child: Text(
              "You are blocked by admin and cannot send or receive any messages.",
              textAlign: TextAlign.center,
              style: CustomTextStyles().medium3Text(
                isDarkMode: isDarkMode,
                isLight: true,
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildMessageBubble(MessageEntity message, bool isDarkMode) {
    bool isMe = message.sender != widget.userId;

    // Resolve Colors
    Color bubbleColor = isMe
        ? (isDarkMode
              ? DarkThemeColors.sentMessageBubble
              : LightThemeColors.sentMessageBubble)
        : (isDarkMode
              ? DarkThemeColors.receivedMessageBubble
              : LightThemeColors.receivedMessageBubble);

    Color textColor = isDarkMode
        ? DarkThemeColors.mainTextColor
        : LightThemeColors.mainTextColor;

    // Tick Color Logic
    Color tickColor = message.isRead
        ? (isDarkMode
              ? DarkThemeColors.primaryColor
              : LightThemeColors.primaryColor) // "Blue" tick
        : (isDarkMode
              ? DarkThemeColors.lightTextColor
              : LightThemeColors.lightTextColor); // "Gray" tick

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end, // Aligns ticks/time to bottom right
              children: [
                Text(
                  message.text,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatTimeOnly(message.createdAt), // e.g., "10:30 PM"
                      style: TextStyle(
                        color: isDarkMode
                            ? DarkThemeColors.lightTextColor
                            : LightThemeColors.lightTextColor,
                        fontSize: 10,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.done_all_rounded, size: 16, color: tickColor),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

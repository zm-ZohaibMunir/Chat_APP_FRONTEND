import 'package:chat_app/core/theme/theme_colors.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/custom_theme_provider.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../providers/presence_provider.dart';
import '../providers/users_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PresenceProvider>().startSystem();
      context.read<UsersProvider>().fetchUsers(isRefresh: true);
    });
  }

  void _onScroll() {
    final up = context.read<UsersProvider>();
    // Trigger when user is 200 pixels from the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (up.hasNextPage && !up.isFetchingMore) {
        up.fetchUsers(); // Fetches the next page automatically
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<CustomThemeProvider>(
        builder: (context, ctp, child) {
          bool isDarkMode = ctp.isDarkMode;
          return Consumer<UsersProvider>(
            builder: (context, up, child) {
              if (up.isLoading && up.users.isEmpty) {
                return Center(
                  child: CustomDataLoader(
                    strokeWidth: 3,
                    loaderColor: isDarkMode
                        ? DarkThemeColors.primaryColor
                        : LightThemeColors.primaryColor,
                    height: 50.h,
                    width: 50.h,
                  ),
                );
              } else {
                return RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: isDarkMode
                      ? DarkThemeColors.primaryColor
                      : LightThemeColors.primaryColor,
                  strokeWidth: 3.0,
                  displacement: 40.0,
                  edgeOffset: 20.0,
                  onRefresh: () async {
                    await up.fetchUsers(isRefresh: true);
                  },
                  child: up.errorMessage != null && up.users.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            CustomErrorWidget(
                              msg: up.errorMessage ?? "",
                              isDarkMode: isDarkMode,
                              isWarning: false,
                              isError: true,
                            ),
                          ],
                        )
                      : up.users.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            CustomErrorWidget(
                              msg: "No Users Found",
                              isDarkMode: isDarkMode,
                              isWarning: true,
                              isError: false,
                            ),
                          ],
                        )
                      : ListView.separated(
                          // If fetching more, add 1 extra slot for the bottom loader
                          itemCount: up.isFetchingMore
                              ? up.users.length + 1
                              : up.users.length,

                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _scrollController,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            // If index is equal to length, it means we are at the "extra" slot
                            if (index == up.users.length) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: CustomDataLoader(
                                    strokeWidth: 2,
                                    loaderColor: isDarkMode
                                        ? DarkThemeColors.primaryColor
                                        : LightThemeColors.primaryColor,
                                    height: 30.h,
                                    width: 30.h,
                                  ),
                                ),
                              );
                            }
                            final user = up.users[index];
                            return ListTile(
                              onTap: user.isAllowed
                                  ? () {
                                      Navigator.pushNamed(
                                        context,
                                        "/chat",
                                        arguments: user.id,
                                      );
                                    }
                                  : null,
                              leading: CircleAvatar(
                                backgroundColor: user.isAllowed
                                    ? isDarkMode
                                          ? DarkThemeColors.primaryColor
                                          : LightThemeColors.primaryColor
                                    : isDarkMode
                                    ? DarkThemeColors.lightTextColor
                                    : LightThemeColors.lightTextColor,
                                child: Text(
                                  user.name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: user.isAllowed
                                      ? isDarkMode
                                            ? DarkThemeColors.mainTextColor
                                            : LightThemeColors.mainTextColor
                                      : isDarkMode
                                      ? DarkThemeColors.lightTextColor
                                      : LightThemeColors.lightTextColor,
                                  decoration: user.isAllowed
                                      ? null
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      user.isAllowed
                                          ? user.lastMessageText != null
                                                ? user.lastMessageText!
                                                : "Tap to chat"
                                          : "User Blocked",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: user.isAllowed
                                            ? isDarkMode
                                                  ? DarkThemeColors.successColor
                                                  : LightThemeColors
                                                        .successColor
                                            : isDarkMode
                                            ? DarkThemeColors.errorColor
                                            : LightThemeColors.errorColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    user.lastMessageTime != null
                                        ? formatLastSeen(user.lastMessageTime!)
                                        : "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkMode
                                          ? DarkThemeColors.lightTextColor
                                          : LightThemeColors.lightTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.circle,
                                size: 12,
                                color:
                                    DateTime.now()
                                            .difference(user.lastSeen)
                                            .inMinutes <
                                        1
                                    ? isDarkMode
                                          ? DarkThemeColors.successColor
                                          : LightThemeColors.successColor
                                    : Colors.transparent,
                              ),
                            );
                          },
                        ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

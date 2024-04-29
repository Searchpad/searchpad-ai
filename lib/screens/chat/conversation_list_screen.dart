import 'dart:async';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/model/conversation_model.dart';
import 'package:booking_system_flutter/screens/chat/admin_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../component/back_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../network/rest_apis.dart';
import '../../utils/constant.dart';

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Future<ConversationModel>? getConversation;
  List<Data>? conversations = [];

  getConverList() async {
    getConversation = getConversations(_perPage, _currentPage);

    if (getConversation != null) {
      ConversationModel? chatRef = await getConversation;
      for (var element in chatRef!.data!) {
        conversations?.add(element);
      }
    }
    setState(() {});
  }

  ScrollController _scrollController = ScrollController();

  int _currentPage = 1;
  int _perPage = 10;
  int? _totalPage = 0;

  bool _isLoading = false;

  @override
  void initState() {
    setState(() {
      initFunction();
      appStore.setLoading(true);
    });
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _currentPage = 1;
    _perPage = 10;
    _totalPage = 0;
    _isLoading = false;
    conversations = [];
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_hasMoreConversations() || _isLoading) {
      return;
    }
    if (_isEndOfListView) {
      // Load more conversations when the end of the list is reached
      loadMoreConversations();
    }
  }

  bool _hasMoreConversations() {
    // Replace this condition with your own logic for determining if there are more conversations to load
    return _currentPage < 3;
  }

  bool get _isEndOfListView {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = 100.0; // Adjust this value as needed
    return maxScroll - currentScroll < delta;
  }

  initFunction() async {
    await getConverList();

    appStore.setLoading(false);
  }

  void loadMoreConversations() {
    // Simulate loading more conversations from an API
    setState(() {
      _isLoading = true;
    });

    var page = _totalPage! / _perPage;

    if (_currentPage < page) {
      _perPage = conversations?.length ?? 10;
      _currentPage = _currentPage + 1;
      getConverList();
    }

    Future.delayed(Duration(seconds: 2), () {
      // Simulate the API call
      setState(() {
        _isLoading = false;
      });
    });

    Future.delayed(Duration(seconds: 2), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(
          "",
          backWidget: BackWidget(iconColor: white),
          color: context.primaryColor,
          systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: context.primaryColor,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.light),
          titleWidget: Text(
            language.lblChat,
            style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
          ),
        ),
        body: SnapHelperWidget<ConversationModel>(
          future: getConversation,
          onSuccess: (dd) {
            _totalPage = dd.totalSize;
            return Padding(
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      conversations!.length + (_hasMoreConversations() ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < conversations!.length) {
                      final conversation = conversations![index];
                      return Container(
                        decoration: BoxDecoration(
                            color: grey.withOpacity(.2),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          onTap: () {
                            AdminChatScreen(
                              callBack: () {
                                conversations = [];
                                _currentPage = 1;
                                _perPage = 10;
                                getConverList();
                              },
                              conversastionId: conversation.id ?? 0,
                              senderId: conversation.sender?.id.toString() ==
                                      appStore.userId.toString()
                                  ? conversation.receiver?.id ?? 1
                                  : conversation.sender?.id ?? 1,
                              receiverId: conversation.sender?.id.toString() !=
                                      appStore.userId.toString()
                                  ? conversation.sender?.id ?? 1
                                  : conversation.receiver?.id ?? 1,
                              senderName: conversation.sender?.id.toString() ==
                                      appStore.userId.toString()
                                  ? conversation.receiver?.name ?? ''
                                  : conversation.sender?.name ?? '',
                            ).launch(context);
                          },
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                conversation.sender?.id.toString() ==
                                        appStore.userId.toString()
                                    ? conversation.receiver?.avatar ?? ''
                                    : conversation.sender?.avatar ?? ''),
                          ),
                          title: Text(
                              conversation.sender?.id.toString() ==
                                      appStore.userId.toString()
                                  ? conversation.receiver?.name ?? ''
                                  : conversation.sender?.name ?? '',
                              style: primaryTextStyle()),
                          subtitle: Text(
                              conversation.lastMessage?.message.toString() ??
                                  '',
                              style: primaryTextStyle()),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  formatTimeAgo(DateTime.parse(
                                    conversation.lastMessage?.createdAt == ""
                                        ? '2023-09-16T11:12:55.000000Z'
                                        : conversation.lastMessage?.createdAt ??
                                            '2023-09-16T11:12:55.000000Z',
                                  ).toLocal()),
                                  style: secondaryTextStyle()),
                              if (conversation.unreadMessageCount! > 0)
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    conversation.unreadMessageCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    } else if (_isLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return SizedBox(
                          height: 60); // Placeholder for loading indicator
                    }
                  },
                ));
          },
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              imageWidget: ErrorStateWidget(),
              retryText: language.reload,
              onRetry: () {
                _currentPage = 1;
                appStore.setLoading(true);

                getConverList();
                setState(() {});
              },
            );
          },
          loadingWidget: LoaderWidget(),
        ));
  }
}

String formatTimeAgo(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else {
    return 'on ${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}';
  }
}

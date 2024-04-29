import 'dart:async';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../component/back_widget.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../model/admin_chat_model.dart';
import '../../network/rest_apis.dart';
import '../../utils/colors.dart';
import '../../utils/common.dart';
import '../../utils/constant.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen(
      {super.key,
      required this.senderId,
      required this.receiverId,
      required this.senderName,
      required this.conversastionId,
      required this.callBack});
  final int senderId;
  final int receiverId;
  final int conversastionId;
  final String senderName;
  final Function() callBack;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

FocusNode messageFocus = FocusNode();
TextEditingController messageCont = TextEditingController();

class _ChatScreenState extends State<AdminChatScreen> {
  Future<AdminChatModel>? adminChat;
  List<Data>? adminChatList = [];
  int? conersationId;

  getChat() async {
    adminChat = getChatList(_perPage, _currentPage, conersationId);

    if (adminChat != null) {
      AdminChatModel? chatRef = await adminChat;
      for (var element in chatRef!.data!) {
        adminChatList?.add(element);
      }
    }
    setState(() {});
  }

  ScrollController _scrollController = ScrollController();
  Timer? timer;
  int _currentPage = 1;
  int _perPage = 10;
  int? _totalPage = 0;
  bool _isLoading = false;

  @override
  void initState() {
    conersationId = widget.conversastionId;
    setState(() {
      if (conersationId != 0) {
        initFunction();
      } else {
        getChat();
      }
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
    timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      // The user has scrolled to the top of the list
      setState(() {
        _isLoading = true;
      });
      var page = _totalPage! / _perPage;

      if (_currentPage < page) {
        _perPage = adminChatList?.length ?? 10;
        _currentPage = _currentPage + 1;
        getChat();
      }

      Future.delayed(Duration(seconds: 2), () {
        // Simulate the API call
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  initFunction() async {
    await getChat();
    _startTimer();
    appStore.setLoading(false);
  }

  sendMessage(message) async {
    var resp = await sendAdminMessage({
      "conversation_id": conersationId,
      "id": widget.receiverId,
      "message": message
    });
    widget.callBack.call();

    if (resp != null) {
      if (conersationId == 0) {
        conersationId = resp['conversation_id'];
        initFunction();
      }
      messageCont.clear();
    }
  }

  getLatestMessage() async {
    AdminChatModel resp =
        await getLatestAdminMessage(conersationId, adminChatList?.first.id);

    AdminChatModel? chatRef = resp;
    if (chatRef.data != null) {
      for (var element in chatRef.data!) {
        adminChatList?.insert(0, element);
      }
    }

    setState(() {});
  }

  // Start the timer
  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      getLatestMessage(); // Call your function every 5 seconds
    });
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
            widget.senderName,
            style: boldTextStyle(color: white, size: APP_BAR_TEXT_SIZE),
          ),
        ),
        body: SnapHelperWidget<AdminChatModel>(
          future: adminChat,
          onSuccess: (dd) {
            _totalPage = dd.totalSize;
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse:
                          true, // Display messages in reverse order for chat
                      itemCount: adminChatList!.length +
                          (_isLoading ? 1 : 0), // +1 for loading indicator
                      itemBuilder: (BuildContext context, int index) {
                        if (index == adminChatList!.length) {
                          if (_isLoading) {
                            // Display a loading indicator at the top while loading more data
                            return Center(child: CircularProgressIndicator());
                          } else {
                            // Display a divider to separate older messages
                            return Divider();
                          }
                        } else {
                          final message = adminChatList![index];
                          final senderName = message.sender?.name ?? '';
                          final senderId = message.sender?.id ?? 0;
                          final messageText = message.message ?? '';
                          final isSeen = message.isSeen == 1;
                          final image = message.sender?.avatar ?? '';

                          ///

                          final dateString = message.createdAt ?? '';

                          DateTime dateTime = DateTime.parse(dateString);
                          DateTime istDateTime = dateTime.toLocal();

                          return ChatTile(
                            senderName: senderName,
                            message: messageText,
                            isSeen: isSeen,
                            isMe: senderId == 1 ? false : true,
                            showImage: true,
                            image: image,
                            dateString: istDateTime,
                          );
                        }
                      },
                    ),
                  ),
                  _buildChatFieldWidget(widget.senderId),
                ],
              ),
            );
          },
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              imageWidget: ErrorStateWidget(),
              retryText: language.reload,
              onRetry: () {
                _currentPage = 1;
                appStore.setLoading(true);

                getChat();
                setState(() {});
              },
            );
          },
          loadingWidget: LoaderWidget(),
        ));
  }

  //region Widget
  Widget _buildChatFieldWidget(lastChatId) {
    return Row(
      children: [
        AppTextField(
          textFieldType: TextFieldType.OTHER,
          controller: messageCont,
          textStyle: primaryTextStyle(),
          minLines: 1,
          focus: messageFocus,
          cursorHeight: 20,
          maxLines: 5,
          cursorColor: appStore.isDarkMode ? Colors.white : Colors.black,
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.multiline,
          decoration: inputDecoration(context).copyWith(
              hintText: language.message, hintStyle: secondaryTextStyle()),
        ).expand(),
        8.width,
        Container(
          decoration: boxDecorationDefault(
              borderRadius: radius(80), color: primaryColor),
          child: IconButton(
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: () {
              if (messageCont.text.isNotEmpty) {
                sendMessage(messageCont.text);
              }
            },
          ),
        )
      ],
    );
  }
}

class ChatTile extends StatelessWidget {
  final String message;
  final bool isMe;
  final bool isSeen;
  final bool showImage;
  final String senderName;
  final String image;
  final DateTime dateString;

  ChatTile({
    required this.message,
    required this.isMe,
    this.isSeen = false,
    this.showImage = false,
    required this.senderName,
    required this.image,
    required this.dateString,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 16.0 : 0),
            topRight: Radius.circular(isMe ? 0 : 16.0),
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(image),
                ),
                SizedBox(width: 8.0),
                Text(
                  senderName,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatTimeAgo(dateString),
                  style: TextStyle(
                      color: isMe ? Colors.white : Colors.black, fontSize: 12),
                ),
                SizedBox(
                  width: 10,
                ),
                if (isMe)
                  Text(
                    isSeen ? '✓✓' : '✓',
                    style: TextStyle(
                      color: isSeen ? Colors.green : Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
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

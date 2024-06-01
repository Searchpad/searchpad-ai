import 'package:booking_system_flutter/component/back_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/user_data_model.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/chat/widget/user_item_widget.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/base_scaffold_body.dart';
import '../../component/empty_error_state_widget.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  void loginInFirebase() async {
    appStore.setLoading(true);

    appStore.setUId(
        await authService.signInWithEmailPassword(email: appStore.userEmail));

    log(FirebaseAuth.instance.currentUser);
    appStore.setLoading(false);
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblChat,
        textColor: white,
        showBack: Navigator.canPop(context),
        textSize: APP_BAR_TEXT_SIZE,
        elevation: 3.0,
        backWidget: BackWidget(),
        color: context.primaryColor,
      ),
      body: Body(
        child: Stack(
          children: [
            SnapHelperWidget(
              future: Future.value(FirebaseAuth.instance.currentUser != null &&
                  appStore.uid.isNotEmpty),
              onSuccess: (isLoggedIn) {
                if (!isLoggedIn) {
                  return NoDataWidget(
                    title: 'You are not connected with Chat Server',
                    subTitle:
                        'Tap below button to connect with our Chat Server',
                    onRetry: () {
                      if (!appStore.isLoggedIn) {
                        SignInScreen().launch(context);
                      } else {
                        loginInFirebase();
                      }
                    },
                    retryText: language.connect,
                    imageWidget: EmptyStateWidget(),
                  ).paddingSymmetric(horizontal: 16);
                } else {
                  return FirestorePagination(
                    query:
                        chatServices.fetchChatListQuery(userId: appStore.uid),
                    physics: AlwaysScrollableScrollPhysics(),
                    isLive: true,
                    shrinkWrap: true,
                    itemBuilder: (context, snap, index) {
                      UserData contact = UserData.fromJson(
                          snap.data() as Map<String, dynamic>);
                      return UserItemWidget(userUid: contact.uid.validate());
                    },
                    initialLoader: LoaderWidget(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 10),
                    padding:
                        EdgeInsets.only(left: 0, top: 8, right: 0, bottom: 0),
                    limit: PER_PAGE_CHAT_LIST_COUNT,
                    separatorBuilder: (_, i) => Divider(
                        height: 0, indent: 82, color: context.dividerColor),
                    viewType: ViewType.list,
                    onEmpty: NoDataWidget(
                      title: language.noConversation,
                      subTitle: language.noConversationSubTitle,
                      imageWidget: EmptyStateWidget(),
                    ).paddingSymmetric(horizontal: 16),
                  );
                }
              },
              loadingWidget: LoaderWidget(),
              errorBuilder: (p0) {
                return NoDataWidget(
                  title: p0,
                  imageWidget: ErrorStateWidget(),
                );
              },
            ),
            Observer(
                builder: (context) =>
                    LoaderWidget().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}

Map dd = {
  "status": true,
  "total_size": 1,
  "limit": 10,
  "offset": 1,
  "data": [
    {
      "id": 1,
      "unread_message_count": 0,
      "sender": {
        "id": 1,
        "name": "Fahad Burwaih",
        "email": "fahod892009@gmail.com",
        "avatar": "https://munasbat.thtbh.com/images/user/user.png",
        "user_type": "admin"
      },
      "receiver": {
        "id": 3,
        "name": "User Demo",
        "email": "demo@user.com",
        "avatar": "https://munasbat.thtbh.com/images/user/user.png",
        "user_type": "user"
      },
      "last_message": {
        "id": 2,
        "conversation_id": 1,
        "sender_id": 3,
        "message": "Hi",
        "file": [],
        "is_seen": 1,
        "is_branch_seen": 0,
        "is_admin_seen": 0,
        "sos_id": 0,
        "created_at": "2023-09-27T11:39:37.000000Z",
        "updated_at": "2023-09-27T11:41:28.000000Z"
      },
      "last_message_sender": {
        "id": 3,
        "name": "User Demo",
        "email": "demo@user.com",
        "avatar": "https://munasbat.thtbh.com/images/user/user.png",
        "user_type": "user"
      }
    }
  ]
};

Map ss = {
  "status": false,
  "total_size": 0,
  "limit": 0,
  "offset": 0,
  "data": []
};

class ConversationModel {
  bool? status;
  int? totalSize;
  int? limit;
  int? offset;
  List<Data>? data;

  ConversationModel(
      {this.status, this.totalSize, this.limit, this.offset, this.data});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_size'] = this.totalSize;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? unreadMessageCount;
  Sender? sender;
  Sender? receiver;
  LastMessage? lastMessage;
  Sender? lastMessageSender;

  Data(
      {this.id,
      this.unreadMessageCount,
      this.sender,
      this.receiver,
      this.lastMessage,
      this.lastMessageSender});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unreadMessageCount = json['unread_message_count'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? new Sender.fromJson(json['receiver']) : null;
    lastMessage = json['last_message'] != null
        ? new LastMessage.fromJson(json['last_message'])
        : null;
    lastMessageSender = json['last_message_sender'] != null
        ? new Sender.fromJson(json['last_message_sender'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unread_message_count'] = this.unreadMessageCount;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver!.toJson();
    }
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage!.toJson();
    }
    if (this.lastMessageSender != null) {
      data['last_message_sender'] = this.lastMessageSender!.toJson();
    }
    return data;
  }
}

class Sender {
  int? id;
  String? name;
  String? email;
  String? avatar;
  String? userType;

  Sender({this.id, this.name, this.email, this.avatar, this.userType});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['user_type'] = this.userType;
    return data;
  }
}

class LastMessage {
  int? id;
  int? conversationId;
  int? senderId;
  dynamic message;
  List<String>? file;
  int? isSeen;
  int? isBranchSeen;
  int? isAdminSeen;
  int? sosId;
  String? createdAt;
  String? updatedAt;

  LastMessage(
      {this.id,
      this.conversationId,
      this.senderId,
      this.message,
      this.file,
      this.isSeen,
      this.isBranchSeen,
      this.isAdminSeen,
      this.sosId,
      this.createdAt,
      this.updatedAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    message = json['message'];
    file = json['file'].cast<String>();
    isSeen = json['is_seen'];
    isBranchSeen = json['is_branch_seen'];
    isAdminSeen = json['is_admin_seen'];
    sosId = json['sos_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conversation_id'] = this.conversationId;
    data['sender_id'] = this.senderId;
    data['message'] = this.message;
    data['file'] = this.file;
    data['is_seen'] = this.isSeen;
    data['is_branch_seen'] = this.isBranchSeen;
    data['is_admin_seen'] = this.isAdminSeen;
    data['sos_id'] = this.sosId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

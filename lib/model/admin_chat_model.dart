class AdminChatModel {
  bool? status;
  int? totalSize;
  int? limit;
  int? offset;
  List<Data>? data;

  AdminChatModel(
      {this.status, this.totalSize, this.limit, this.offset, this.data});

  AdminChatModel.fromJson(Map<String, dynamic> json) {
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
  Sender? sender;
  String? message;
  List<String>? file;
  int? isSeen;
  String? createdAt;

  Data(
      {this.id,
      this.sender,
      this.message,
      this.file,
      this.isSeen,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender =
        json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    message = json['message'];
    file = json['file'].cast<String>();
    isSeen = json['is_seen'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    data['message'] = this.message;
    data['file'] = this.file;
    data['is_seen'] = this.isSeen;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Sender {
  int? id;
  String? name;
  String? email;
  String? avatar;

  Sender({this.id, this.name, this.email, this.avatar});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    return data;
  }
}

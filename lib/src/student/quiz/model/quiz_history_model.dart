class QuizHistoryModel {
  final int? status;
  final Data? data;
  final String? message;

  QuizHistoryModel({
    this.status,
    this.data,
    this.message,
  });

  QuizHistoryModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'status' : status,
    'data' : data?.toJson(),
    'message' : message
  };
}

class Data {
  final List<HistoryData>? data;
  final Links? links;
  final Meta? meta;

  Data({
    this.data,
    this.links,
    this.meta,
  });

  Data.fromJson(Map<String, dynamic> json)
      : data = (json['data'] as List?)?.map((dynamic e) => HistoryData.fromJson(e as Map<String,dynamic>)).toList(),
        links = (json['links'] as Map<String,dynamic>?) != null ? Links.fromJson(json['links'] as Map<String,dynamic>) : null,
        meta = (json['meta'] as Map<String,dynamic>?) != null ? Meta.fromJson(json['meta'] as Map<String,dynamic>) : null;

  Map<String, dynamic> toJson() => {
    'data' : data?.map((e) => e.toJson()).toList(),
    'links' : links?.toJson(),
    'meta' : meta?.toJson()
  };
}

class HistoryData {
  final int? id;
  final int? time;
  final int? gameCode;
  final Subject? subject;
  final Level? level;
  final List<Participants>? participants;
  final int? coins;

  HistoryData({
    this.id,
    this.time,
    this.gameCode,
    this.subject,
    this.level,
    this.participants,
    this.coins,
  });

  HistoryData.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        time = json['time'] as int?,
        gameCode = json['game_code'] as int?,
        subject = (json['subject'] as Map<String,dynamic>?) != null ? Subject.fromJson(json['subject'] as Map<String,dynamic>) : null,
        level = (json['level'] as Map<String,dynamic>?) != null ? Level.fromJson(json['level'] as Map<String,dynamic>) : null,
        participants = (json['participants'] as List?)?.map((dynamic e) => Participants.fromJson(e as Map<String,dynamic>)).toList(),
        coins = json['coins'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'time' : time,
    'game_code' : gameCode,
    'subject' : subject?.toJson(),
    'level' : level?.toJson(),
    'participants' : participants?.map((e) => e.toJson()).toList(),
    'coins' : coins
  };
}

class Subject {
  final int? id;
  final dynamic title;
  final dynamic heading;
  final dynamic image;

  Subject({
    this.id,
    this.title,
    this.heading,
    this.image,
  });

  Subject.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'],
        heading = json['heading'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title?.toJson(),
    'heading' : heading?.toJson(),
    'image' : image?.toJson()
  };
}

class Level {
  final int? id;
  final dynamic title;
  final int? points;

  Level({
    this.id,
    this.title,
    this.points,
  });

  Level.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'],
        points = json['points'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'title' : title?.toJson(),
    'points' : points
  };
}

class Participants {
  final int? id;
  final int? status;
  final User? user;
  final String? createdAt;

  Participants({
    this.id,
    this.status,
    this.user,
    this.createdAt,
  });

  Participants.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        status = json['status'] as int?,
        user = (json['user'] as Map<String,dynamic>?) != null ? User.fromJson(json['user'] as Map<String,dynamic>) : null,
        createdAt = json['created_at'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'status' : status,
    'user' : user?.toJson(),
    'created_at' : createdAt
  };
}

class User {
  final int? id;
  final String? name;
  final dynamic email;
  final String? mobileNo;
  final dynamic username;
  final School? school;
  final String? state;
  final dynamic profileImage;

  User({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.username,
    this.school,
    this.state,
    this.profileImage,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        email = json['email'],
        mobileNo = json['mobile_no'] as String?,
        username = json['username'],
        school = (json['school'] as Map<String,dynamic>?) != null ? School.fromJson(json['school'] as Map<String,dynamic>) : null,
        state = json['state'] as String?,
        profileImage = json['profile_image'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'email' : email,
    'mobile_no' : mobileNo,
    'username' : username,
    'school' : school?.toJson(),
    'state' : state,
    'profile_image' : profileImage
  };
}

class School {
  final int? id;
  final String? name;
  final String? state;
  final String? city;

  School({
    this.id,
    this.name,
    this.state,
    this.city,
  });

  School.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        state = json['state'] as String?,
        city = json['city'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'state' : state,
    'city' : city
  };
}

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final String? next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  Links.fromJson(Map<String, dynamic> json)
      : first = json['first'] as String?,
        last = json['last'] as String?,
        prev = json['prev'],
        next = json['next'] as String?;

  Map<String, dynamic> toJson() => {
    'first' : first,
    'last' : last,
    'prev' : prev,
    'next' : next
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<MetaLinks>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  Meta.fromJson(Map<String, dynamic> json)
      : currentPage = json['current_page'] as int?,
        from = json['from'] as int?,
        lastPage = json['last_page'] as int?,
        links = (json['links'] as List?)?.map((dynamic e) => MetaLinks.fromJson(e as Map<String,dynamic>)).toList(),
        path = json['path'] as String?,
        perPage = json['per_page'] as int?,
        to = json['to'] as int?,
        total = json['total'] as int?;

  Map<String, dynamic> toJson() => {
    'current_page' : currentPage,
    'from' : from,
    'last_page' : lastPage,
    'links' : links?.map((e) => e.toJson()).toList(),
    'path' : path,
    'per_page' : perPage,
    'to' : to,
    'total' : total
  };
}

class MetaLinks {
  final dynamic url;
  final String? label;
  final bool? active;

  MetaLinks({
    this.url,
    this.label,
    this.active,
  });

  MetaLinks.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        label = json['label'] as String?,
        active = json['active'] as bool?;

  Map<String, dynamic> toJson() => {
    'url' : url,
    'label' : label,
    'active' : active
  };
}
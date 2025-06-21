// To parse this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';


DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  int? status;
  Data? data;
  String? message;
  

  DashboardModel({
    this.status,
    this.data,
    this.message,
    
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  User? user;

  Data({
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user": user?.toJson(),
  };
}

class User {
  int? id;
  dynamic studentId;
  School? school;
  Grade? section;
  String? name;
  String? guardianName;
  dynamic username;
  String? mobileNo;
  dynamic dob;
  
  String? la_board_id;
  String? board_name;
  int? gender;
  Grade? grade;
  String? city;
  String? state;
  dynamic address;
  dynamic imagePath;
  dynamic profileImage;
  int? missionCompletes;
  int? quiz;
  int? friends;
  int? earnCoins;
  dynamic subjects;
  int? userRank;
  String? mentorCode;
  String? unreadNotificationCount;
  BaloonCarMission? baloonCarMission;
  List<LaTeacherGrade>? laTeacherGrades;

  User({
    this.id,
    this.studentId,
    this.school,
    this.section,
    this.name,
    this.guardianName,
    this.username,
    this.mobileNo,
    this.dob,
    
    this.la_board_id,
    this.board_name,
    this.gender,
    this.grade,
    this.city,
    this.state,
    this.address,
    this.imagePath,
    this.profileImage,
    this.missionCompletes,
    this.quiz,
    this.friends,
    this.earnCoins,
    this.subjects,
    this.userRank,
    this.mentorCode,
    this.unreadNotificationCount,
    this.baloonCarMission,
    this.laTeacherGrades,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    studentId: json["student_id"],
    school: json["school"] == null ? null : School.fromJson(json["school"]),
    section: json["section"] == null ? null : Grade.fromJson(json["section"]),
    name: json["name"],
    guardianName: json["guardian_name"],
    username: json["username"],
    mobileNo: json["mobile_no"],
    dob: json["dob"],
    
    la_board_id: json['la_board_id']?.toString(),
    board_name: json['board_name']?.toString(),
    gender: json["gender"],
    grade: json["grade"] == null ? null : Grade.fromJson(json["grade"]),
    city: json["city"],
    state: json["state"],
    address: json["address"],
    imagePath: json["image_path"],
    profileImage: json["profile_image"],
    missionCompletes: json["mission_completes"],
    quiz: json["quiz"],
    friends: json["friends"],
    earnCoins: json["earn_coins"],
    subjects: json["subjects"],
    userRank: json["user_rank"],
    mentorCode: json["mentor_code"],
    unreadNotificationCount: (json["unread_notification_count"] ?? 0).toString(),
    baloonCarMission: json["baloonCarMission"] == null ? null : BaloonCarMission.fromJson(json["baloonCarMission"]),
    laTeacherGrades: json["la_teacher_grades"] == null ? [] : List<LaTeacherGrade>.from(json["la_teacher_grades"]!.map((x) => LaTeacherGrade.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "school": school?.toJson(),
    "section": section?.toJson(),
    "name": name,
    "guardian_name": guardianName,
    "username": username,
    "mobile_no": mobileNo,
    "dob": dob,
    
    "la_board_id": la_board_id,
    "board_name": board_name,
    "gender": gender,
    "grade": grade?.toJson(),
    "city": city,
    "state": state,
    "address": address,
    "image_path": imagePath,
    "profile_image": profileImage,
    "mission_completes": missionCompletes,
    "quiz": quiz,
    "friends": friends,
    "earn_coins": earnCoins,
    "subjects": subjects,
    "user_rank": userRank,
    "mentor_code": mentorCode,
    "unread_notification_count": unreadNotificationCount,
    "baloonCarMission": baloonCarMission?.toJson(),
    "la_teacher_grades": laTeacherGrades == null ? [] : List<dynamic>.from(laTeacherGrades!.map((x) => x.toJson())),
  };
}

class BaloonCarMission {
  int? id;
  Level? level;
  List<dynamic>? topic;
  int? type;
  String? title;
  String? description;
  ImageData? image;
  dynamic document;
  String? question;
  Subject? subject;
  List<Resource>? resources;
  Submission? submission;

  BaloonCarMission({
    this.id,
    this.level,
    this.topic,
    this.type,
    this.title,
    this.description,
    this.image,
    this.document,
    this.question,
    this.subject,
    this.resources,
    this.submission,
  });

  factory BaloonCarMission.fromJson(Map<String, dynamic> json) => BaloonCarMission(
    id: json["id"],
    level: json["level"] == null ? null : Level.fromJson(json["level"]),
    topic: json["topic"] == null ? [] : List<dynamic>.from(json["topic"]!.map((x) => x)),
    type: json["type"],
    title: json["title"],
    description: json["description"],
    image: json["image"] == null ? null : ImageData.fromJson(json["image"]),
    document: json["document"],
    question: json["question"],
    subject: json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    resources: json["resources"] == null ? [] : List<Resource>.from(json["resources"]!.map((x) => Resource.fromJson(x))),
    submission: json["submission"] == null ? null : Submission.fromJson(json["submission"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "level": level?.toJson(),
    "topic": topic == null ? [] : List<dynamic>.from(topic!.map((x) => x)),
    "type": type,
    "title": title,
    "description": description,
    "image": image?.toJson(),
    "document": document,
    "question": question,
    "subject": subject?.toJson(),
    "resources": resources == null ? [] : List<dynamic>.from(resources!.map((x) => x.toJson())),
    "submission": submission?.toJson(),
  };
}

class ImageData {
  int? id;
  String? name;
  String? url;

  ImageData({
    this.id,
    this.name,
    this.url,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    id: json["id"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
  };
}

class Level {
  int? id;
  String? title;
  String? description;
  int? missionPoints;
  int? quizPoints;
  int? riddlePoints;
  int? puzzlePoints;
  int? jigyasaPoints;
  int? pragyaPoints;
  int? quizTime;
  int? riddleTime;
  int? puzzleTime;
  int? unlock;

  Level({
    this.id,
    this.title,
    this.description,
    this.missionPoints,
    this.quizPoints,
    this.riddlePoints,
    this.puzzlePoints,
    this.jigyasaPoints,
    this.pragyaPoints,
    this.quizTime,
    this.riddleTime,
    this.puzzleTime,
    this.unlock,
  });

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    missionPoints: json["mission_points"],
    quizPoints: json["quiz_points"],
    riddlePoints: json["riddle_points"],
    puzzlePoints: json["puzzle_points"],
    jigyasaPoints: json["jigyasa_points"],
    pragyaPoints: json["pragya_points"],
    quizTime: json["quiz_time"],
    riddleTime: json["riddle_time"],
    puzzleTime: json["puzzle_time"],
    unlock: json["unlock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "mission_points": missionPoints,
    "quiz_points": quizPoints,
    "riddle_points": riddlePoints,
    "puzzle_points": puzzlePoints,
    "jigyasa_points": jigyasaPoints,
    "pragya_points": pragyaPoints,
    "quiz_time": quizTime,
    "riddle_time": riddleTime,
    "puzzle_time": puzzleTime,
    "unlock": unlock,
  };
}

class Resource {
  int? id;
  String? title;
  ImageData? media;
  String? locale;

  Resource({
    this.id,
    this.title,
    this.media,
    this.locale,
  });

  factory Resource.fromJson(Map<String, dynamic> json) => Resource(
    id: json["id"],
    title: json["title"],
    media: json["media"] == null ? null : ImageData.fromJson(json["media"]),
    locale: json["locale"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "media": media?.toJson(),
    "locale": locale,
  };
}

class Subject {
  int? id;
  String? title;
  String? heading;
  ImageData? image;
  bool? isCouponAvailable;
  bool? couponCodeUnlock;

  Subject({
    this.id,
    this.title,
    this.heading,
    this.image,
    this.isCouponAvailable,
    this.couponCodeUnlock,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json["id"],
    title: json["title"],
    heading: json["heading"],
    image: json["image"] == null ? null : ImageData.fromJson(json["image"]),
    isCouponAvailable: json["is_coupon_available"],
    couponCodeUnlock: json["coupon_code_unlock"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "heading": heading,
    "image": image?.toJson(),
    "is_coupon_available": isCouponAvailable,
    "coupon_code_unlock": couponCodeUnlock,
  };
}

class Submission {
  int? id;
  SubmissionUser? user;
  dynamic title;
  ImageData? media;
  String? description;
  String? comments;
  DateTime? approvedAt;
  dynamic rejectedAt;
  int? points;
  dynamic timing;

  Submission({
    this.id,
    this.user,
    this.title,
    this.media,
    this.description,
    this.comments,
    this.approvedAt,
    this.rejectedAt,
    this.points,
    this.timing,
  });

  factory Submission.fromJson(Map<String, dynamic> json) => Submission(
    id: json["id"],
    user: json["user"] == null ? null : SubmissionUser.fromJson(json["user"]),
    title: json["title"],
    media: json["media"] == null ? null : ImageData.fromJson(json["media"]),
    description: json["description"],
    comments: json["comments"],
    approvedAt: json["approved_at"] == null ? null : DateTime.parse(json["approved_at"]),
    rejectedAt: json["rejected_at"],
    points: json["points"],
    timing: json["timing"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "title": title,
    "media": media?.toJson(),
    "description": description,
    "comments": comments,
    "approved_at": approvedAt?.toIso8601String(),
    "rejected_at": rejectedAt,
    "points": points,
    "timing": timing,
  };
}

class SubmissionUser {
  int? id;
  String? name;
  dynamic email;
  String? mobileNo;
  String? username;
  School? school;
  String? state;
  String? profileImage;

  SubmissionUser({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.username,
    this.school,
    this.state,
    this.profileImage,
  });

  factory SubmissionUser.fromJson(Map<String, dynamic> json) => SubmissionUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    username: json["username"],
    school: json["school"] == null ? null : School.fromJson(json["school"]),
    state: json["state"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "username": username,
    "school": school?.toJson(),
    "state": state,
    "profile_image": profileImage,
  };
}

class Grade {
  int? id;
  String? name;

  Grade({
    this.id,
    this.name,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => Grade(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}


class Document {
  int? id;
  String? name;
  String? url;

  Document({
    this.id,
    this.name,
    this.url,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    id: json["id"],
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "url": url,
  };
}

class School {
  int? id;
  String? name;
  String? state;
  String? city;
  int? code;

  School({
    this.id,
    this.name,
    this.state,
    this.city,
    this.code,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
    id: json["id"],
    name: json["name"],
    state: json["state"],
    city: json["city"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "state": state,
    "city": city,
    "code": code,
  };
}

class LaTeacherGrade {
  int? id;
  Grade? grade;
  Subject? subject;
  Grade? section;

  LaTeacherGrade({
    this.id,
    this.grade,
    this.subject,
    this.section,
  });

  factory LaTeacherGrade.fromJson(Map<String, dynamic> json) => LaTeacherGrade(
    id: json["id"],
    grade: json["grade"] == null ? null : Grade.fromJson(json["grade"]),
    subject: json["subject"] == null ? null : Subject.fromJson(json["subject"]),
    section: json["section"] == null ? null : Grade.fromJson(json["section"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "grade": grade?.toJson(),
    "subject": subject?.toJson(),
    "section": section?.toJson(),
  };
}
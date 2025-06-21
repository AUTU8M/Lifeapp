class ResultModel {
  final int? status;
  final List<Data>? data;
  final String? message;

  ResultModel({
    this.status,
    this.data,
    this.message,
  });

  ResultModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as int?,
        data = (json['data'] as List?)?.map((dynamic e) => Data.fromJson(e as Map<String,dynamic>)).toList(),
        message = json['message'] as String?;

  Map<String, dynamic> toJson() => {
    'status' : status,
    'data' : data?.map((e) => e.toJson()).toList(),
    'message' : message
  };
}

class Data {
  final int? id;
  final User? user;
  final int? totalQuestions;
  final int? totalCorrectAnswers;
  final int? totalWrongAnswers;
  final int? coins;

  Data({
    this.id,
    this.user,
    this.totalQuestions,
    this.totalCorrectAnswers,
    this.totalWrongAnswers,
    this.coins,
  });

  Data.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        user = (json['user'] as Map<String,dynamic>?) != null ? User.fromJson(json['user'] as Map<String,dynamic>) : null,
        totalQuestions = json['total_questions'] as int?,
        totalCorrectAnswers = json['total_correct_answers'] as int?,
        totalWrongAnswers = json['total_wrong_answers'] as int?,
        coins = json['coins'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'user' : user?.toJson(),
    'total_questions' : totalQuestions,
    'total_correct_answers' : totalCorrectAnswers,
    'total_wrong_answers' : totalWrongAnswers,
    'coins' : coins
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
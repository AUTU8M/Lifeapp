// import '../../../config/environment.dart';
class ApiHelper {
  ApiHelper._();

  // static String get baseUrl {
  //   switch (EnvironmentConfig().environment) {
  //     case Environment.aws:
  //       return "https://api.gappubobo.com";
  //     case Environment.digitalOcean:
  //       return "https://api.life-lab.org";
  //   }
  // }

  static const String baseUrl = "https://api.life-lab.org";
  
  // static const String baseUrl = "https://api.gappubobo.com";

  // static const String baseUrl = "http://10.0.2.2:8000";

  // static const String baseUrl= "http://192.168.29.143:8000";

  // static const String baseUrl = "https://stg.gappubobo.com";

  // static const String imgBaseUrl = "https://media.gappubobo.com/";

  static const String imgBaseUrl = "https://lifeappmedia.blr1.digitaloceanspaces.com/";

  static const String chatGptToken =
      "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";

  /// [Student]
  static const String sendOtp = "/v3/otp/send";
  static const String verifyOtp = "/v3/otp/verify";
  static const String getSchoolList = "/v3/schools";
  static const String getSectionList = "/v3/sections";
  static const String getGradesList = "/v3/grades";
  static const String getStateList = "/api/v1/states/India";
  static const String verifySchoolCode = "/v3/school/code-verify";
  static const String register = "/v3/register";
  static const String dashboard = "/v3/dashboard";
  static const String subjects = "/v3/subjects";
  static const String levels = "/v3/levels";
  static const String mission = "/v3/mission";
  static const String topic = "/v3/topics";
  static const String coinHistory = "/v3/coin-history";
  static const String searchFriend = "/v3/users?search=";
  static const String sendRequest = "/v3/friend-requests/send";
  static const String unfriend = "/v3/friends/";
  static const String getMyFriends = "/v3/friends";
  static const String getSentFriends = "/v3/friend-requests/invite";
  static const String getFriendReq = "/v3/friend-requests";
  static const String acceptFriendReq = "/v3/friend-requests/";
  static const String getHallOfFame = "/v3/hall-of-fame";
  static const String completeMission = "/v3/mission/complete";
  static const String getMissionDetails = "/v3/mission/";
  static const String getQue = "/v3/quiz-games/";
  static const String addQuiz = "/v3/quiz-games";
  static const String submitQuiz = "/v3/quiz-games/";
  static const String quizHistory = "/v3/quiz-games";
  static const String couponList = "/v3/coupon/list";
  static const String redeemCoupon = "/v3/coupon/";
  static const String notification = "/v3/notifications";
  static const String clearNotification = "/v3/notifications/clear";
  static const String tracker = "/v3/game-reports";
  static const String logout = "/api/v1/users/logout";
  static const String uploadImage = "/v3/profile/image";
  static const String uploadProfile = "/v3/profile";
  static const String uploadTeacherProfile = "/v3/profile/teacher";
  static const String updateMentorProfile = "/v3/mentor-profile";
  static const String createSession = "/v3/sessions/create";
  static const String upcomingSession = "/v3/sessions/upcoming";
  static const String sessionDetails = "/v3/sessions/";
  static const String attendSession = "/v3/sessions/attended";
  static const String mySession = "/v3/sessions";
  static const String subscribeCode = "/v3/game-enrollments";
  static const String checkSubscription = "/v3/check-game-enrollments";
  static const String getBoard = "/v3/boards";
  static const String getCompetency = "/v3/competencies";
  static const String getConceptCartoon = "/v3/concept-cartoons";
  static const String getConceptCartoonHeader = "/v3/concept-cartoon-header";
  static const String getAssessment = "/v3/assessments";
  static const String getWorksheet = "/v3/work-sheets";
  static const String lessonLanguage = "/v3/lession-plan-languages";
  static const String lessonPlan = "/v3/lession-plans";
  static const String getClassStudent = "/v3/teachers/class-students";
  static const String getAllStudent = "/v3/reports/all-students";
  static const String assignMission = "/v3/teachers/assign-missions";
  static const String assignTopic = "/v3/teachers/assign-topics";
  static const String teachersGrade = "/v3/teachers/grade-sections";
  static const String classStudent = "/v3/reports/class-students/";
  static const String getTeacherMission = "/v3/teachers/missions";
  static const String getTeacherMissionParticipant =
      "/v3/teachers/mission-participants/";
  static const String teacherMissionApproveReject = "/v3/teachers/submission/";
  static const String getStudentMissions = "/v3/mission/submission";
  static const String storeToken = "/api/v1/device-token";
}

import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lifelab3/src/common/helper/color_code.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/mentor/code/provider/mentor_code_provider.dart';
import 'package:lifelab3/src/mentor/mentor_create_session/provider/mentor_create_session_provider.dart';
import 'package:lifelab3/src/mentor/mentor_home/presentations/pages/mentor_home_page.dart';
import 'package:lifelab3/src/mentor/mentor_home/provider/mentor_home_provider.dart';
import 'package:lifelab3/src/mentor/mentor_my_session_list/provider/mentor_my_session_list_provider_page.dart';
import 'package:lifelab3/src/mentor/mentor_profile/provider/mentor_profile_provider.dart';
import 'package:lifelab3/src/student/connect/provider/connect_provider.dart';
import 'package:lifelab3/src/student/friend/provider/friend_provider.dart';
import 'package:lifelab3/src/student/hall_of_fame/provider/hall_of_fame_provider.dart';
import 'package:lifelab3/src/student/home/provider/dashboard_provider.dart';
import 'package:lifelab3/src/student/mission/presentations/pages/mission_page.dart';
import 'package:lifelab3/src/student/mission/provider/mission_provider.dart';
import 'package:lifelab3/src/student/nav_bar/presentations/pages/nav_bar_page.dart';
import 'package:lifelab3/src/student/profile/provider/profile_provider.dart';
import 'package:lifelab3/src/student/puzzle/provider/puzzle_provider.dart';
import 'package:lifelab3/src/student/questions/provider/question_provider.dart';
import 'package:lifelab3/src/student/quiz/provider/quiz_provider.dart';
import 'package:lifelab3/src/student/riddles/provider/riddle_provider.dart';
import 'package:lifelab3/src/student/sign_up/provider/sign_up_provider.dart';
import 'package:lifelab3/src/student/student_login/provider/student_login_provider.dart';
import 'package:lifelab3/src/student/subject_level_list/provider/subject_level_provider.dart';
import 'package:lifelab3/src/student/subject_list/provider/subject_list_provider.dart';
import 'package:lifelab3/src/student/tracker/provider/tracker_provider.dart';
import 'package:lifelab3/src/student/vision/presentations/vision_page.dart';
import 'package:lifelab3/src/teacher/student_progress/provider/student_progress_provider.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/presentations/pages/teacher_dashboard_page.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';
import 'package:lifelab3/src/teacher/teacher_login/provider/teacher_login_provider.dart';
import 'package:lifelab3/src/teacher/teacher_profile/provider/teacher_profile_provider.dart';
import 'package:lifelab3/src/teacher/teacher_sign_up/provider/teacher_sign_up_provider.dart';
import 'package:lifelab3/src/teacher/teacher_tool/provider/tool_provider.dart';
import 'package:lifelab3/src/utils/storage_utils.dart';
import 'package:lifelab3/src/welcome/presentation/page/welcome_page.dart';
import 'package:provider/provider.dart';
import 'package:lifelab3/src/student/vision/providers/vision_provider.dart';

import 'src/common/widgets/common_navigator.dart';

import 'package:lifelab3/src/common/utils/version_check_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  var data = jsonDecode(notificationResponse.payload!);
  navigateToScreen(data);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
  debugPrint(
      'Handling a background message ${message.notification?.android?.channelId ?? "NA"}');
  debugPrint("PayLoad ${message.data}");
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final navKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set white system bars with dark icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Optional: show content under status/nav bars (edge-to-edge)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: SystemUiOverlay.values);

  await StorageUtil.getInstance();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'lifelab', 'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (Platform.isIOS) {
    const InitializationSettings initializationSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  runApp(const MyApp());
}

class VersionCheckWrapper extends StatefulWidget {
  final Widget child;

  const VersionCheckWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<VersionCheckWrapper> createState() => _VersionCheckWrapperState();
}



class _VersionCheckWrapperState extends State<VersionCheckWrapper> {
  final VersionCheckService _versionCheckService = VersionCheckService();

  @override
  void initState() {
    super.initState();
    // Delay version check to ensure MaterialApp is fully initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _versionCheckService.checkAndPromptUpdate(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isLogin;
  bool isMentor = false;
  bool isTeacher = false;



  getFcmToken() async {
    await FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((value) {
      StorageUtil.putString(StringHelper.fcmToken, value!);
      debugPrint("Fcm Token: $value");
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint(message.notification?.title);
        Future.delayed(const Duration(milliseconds: 3000), () {
          navigateToScreen(message.data);
        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("LISTEN${message.data.toString()}");
      RemoteNotification? notification = message.notification;

      AndroidNotification? android = message.notification?.android;
      debugPrint(
          "LISTEN${(message.notification?.android?.channelId ?? "NA").toString()}");
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@drawable/launch_background');

      // var initializationSettingsIOs = const IOSInitializationSettings();
      DarwinInitializationSettings iosInitializationSettings =
          const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      var initSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: iosInitializationSettings);
      flutterLocalNotificationsPlugin.initialize(initSettings,
          onDidReceiveNotificationResponse: notificationTapBackground,
          onDidReceiveBackgroundNotificationResponse:
              notificationTapBackground);

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: 'launch_background',
              ),
            ),
            payload: jsonEncode(message.data));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigateToScreen(message.data);
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      await Firebase.initializeApp();
      navigateToScreen(message.data);
    });
  }

  @override
  void initState() {
    getFcmToken();
    isLogin = StorageUtil.getBool(StringHelper.isLoggedIn);
    isMentor = StorageUtil.getBool(StringHelper.isMentor);
    isTeacher = StorageUtil.getBool(StringHelper.isTeacher);
    debugPrint("Is Logged In: $isLogin");
    debugPrint("Is Mentor: $isMentor");
    debugPrint("Is Teacher: $isTeacher");
    super.initState();

  }

   Widget _buildHomeScreen() {
    Widget homeWidget = isLogin!
        ? const NavBarPage(currentIndex: 0)
        : isMentor
            ? const MentorHomePage()
            : isTeacher
                ? const TeacherDashboardPage()
                : const WelComePage();

    return VersionCheckWrapper(child: homeWidget);
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentLoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => TrackerProvider()),
        ChangeNotifierProvider(create: (_) => ConnectProvider()),
        ChangeNotifierProvider(create: (_) => SubjectListProvider()),
        ChangeNotifierProvider(create: (_) => SubjectLevelProvider()),
        ChangeNotifierProvider(create: (_) => MissionProvider()),
        ChangeNotifierProvider(create: (_) => RiddleProvider()),
        ChangeNotifierProvider(create: (_) => PuzzleProvider()),
        ChangeNotifierProvider(create: (_) => MentorOtpProvider()),
        ChangeNotifierProvider(create: (_) => MentorHomeProvider()),
        ChangeNotifierProvider(create: (_) => MentorCreateSessionProvider()),
        ChangeNotifierProvider(create: (_) => MentorMySessionListProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => TeacherLoginProvider()),
        ChangeNotifierProvider(create: (_) => TeacherDashboardProvider()),
        ChangeNotifierProvider(create: (_) => TeacherSignUpProvider()),
        ChangeNotifierProvider(create: (_) => StudentProgressProvider()),
        ChangeNotifierProvider(create: (_) => FriendProvider()),
        ChangeNotifierProvider(create: (_) => HallOfFameProvider()),
        ChangeNotifierProvider(create: (_) => QuestionProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => MentorProfileProvider()),
        ChangeNotifierProvider(create: (_) => ToolProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProfileProvider()),
        ChangeNotifierProvider(create: (_) => VisionProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navKey,
        title: 'Life App',
        debugShowCheckedModeBanner: false,

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        supportedLocales: const [
          Locale('en', ''), // English

        ],

         builder: (context, child) {
          return MaterialApp(
            // Remove the title and navigatorKey as they're in the parent MaterialApp
            debugShowCheckedModeBanner: false,
            home: Material(
              type: MaterialType.transparency,
              child: child!,
            ),
            theme: Theme.of(context), // Inherit theme from parent
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },

        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: ColorCode.defaultBgColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            elevation: 0,
            titleSpacing: 0,
            centerTitle: false,
            backgroundColor: ColorCode.defaultBgColor,
            scrolledUnderElevation: 0,
          ),
          scaffoldBackgroundColor: ColorCode.defaultBgColor,
          primaryColor: ColorCode.defaultBgColor,
          fontFamily: "Avenir",
          textTheme: const TextTheme().apply(displayColor: Colors.white),
        ),

          home: _buildHomeScreen(),

      ),
    );
  }
}


void navigateToScreen(var data) {
  debugPrint("Not Data: $data");
  if (data["action"].toString() == "6") {
    try {
      push(
        page: const NavBarPage(currentIndex: 2),
        withNavbar: true,
        context: navKey.currentState!.context,
      );
    } catch (e) {
      print("Navigation Error: $e");
    }
  } else if (data["action"].toString() == "2") {
    if (data["la_subject_id"] != null && data["la_level_id"] != null) {
      Map<String, dynamic> missionData = {
        "type": 1,
        "la_subject_id": data["la_subject_id"].toString(),
        "la_level_id": data["la_level_id"].toString(),
      };
      Provider.of<SubjectLevelProvider>(navKey.currentState!.context,
              listen: false)
          .getMission(missionData)
          .whenComplete(() {
        push(
          context: navKey.currentState!.context,
          page: MissionPage(
            missionListModel: Provider.of<SubjectLevelProvider>(
                    navKey.currentState!.context,
                    listen: false)
                .missionListModel!,
            levelId: data["la_level_id"],
            subjectId: data["la_subject_id"],
          ),
        );
      });
    }
  }
}

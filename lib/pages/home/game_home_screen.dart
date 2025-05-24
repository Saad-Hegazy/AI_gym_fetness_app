import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:grip/extensions/extension_util/int_extensions.dart';
import 'package:grip/extensions/extension_util/widget_extensions.dart';
import 'package:grip/extensions/system_utils.dart';
import 'package:grip/extensions/text_styles.dart';
import 'package:grip/main.dart';
import 'package:grip/pages/LeaderboardBottomSheet.dart';
import 'package:grip/routes.dart';
import 'package:grip/utils/app_colors.dart';
import 'package:grip/utils/app_images.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GameHomeScreen extends StatefulWidget {
  GameHomeScreen({Key? key}) : super(key: key);

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> {
  final buttonStyle = ElevatedButton.styleFrom(padding: EdgeInsets.fromLTRB(75, 5, 75, 5));

  var  colorizeColors = [
    Colors.black,
    Colors.blue,
    Colors.orange,
    Colors.red,
  ];

  var colorizeTextStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  final AudioPlayer _audioPlayer = AudioPlayer();
  final now = DateTime.now();

  Future<void> _playSound(String filePath) async {
    await _audioPlayer.play(AssetSource(filePath));
    Navigator.of(context).push(Routes.createRoute(context));
  }

  Future<void> _saveClickTime() async {
    final now = DateTime.now();
    await sharedPreferences.setString('lastClickTime', now.toIso8601String());
    print("----------73>>>Saved: $now");
  }

  Future<bool> _canClick() async {
    final lastClickTimeString = sharedPreferences.getString('lastClickTime');

    if (lastClickTimeString == null) {
      return true;
    }

    final lastClickTime = DateTime.parse(lastClickTimeString);
    final now = DateTime.now();
    final difference = now.difference(lastClickTime);
    final hours = difference.inMinutes / 60;

    return hours >= 24;
  }




  Future<double?> _getHoursSinceLastClick() async {
    final lastClickTimeString = sharedPreferences.getString('lastClickTime');

    if (lastClickTimeString != null) {
      final lastClickTime = DateTime.parse(lastClickTimeString);
      final now = DateTime.now();
      final difference = now.difference(lastClickTime);
      final hours = difference.inMinutes / 60;
      return hours;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? socialBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: appStore.isDarkMode ? socialBackground : Colors.white,
        title: Text(
          'Mighty brain workout',
          style: TextStyle(fontWeight: FontWeight.bold, color: appStore.isDarkMode ? Colors.white : scaffoldColorDark, fontSize: 18),
        ),
        leading: GestureDetector(
          onTap: () {
            finish(context);
          },
          child: Icon(
            Octicons.chevron_left,
            color: primaryColor,
            size: 28,
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                showLeaderboardBottomSheet(context);
              },
              child: Image.asset(scoreboard, height: 30, width: 30,color:appStore.isDarkMode ? Colors.white : scaffoldColorDark)).paddingSymmetric(horizontal: 10),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                child: AnimatedTextKit(
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Find a different color to check brain workout',
                      textStyle: colorizeTextStyle,
                      textAlign:TextAlign.center ,
                      colors: colorizeColors,
                    ),
                  ],
                ),
              ),
            //  Text('Find a different color to check brain workout', textAlign: TextAlign.center, style: primaryTextStyle(size: 25)),
              Lottie.asset('assets/mindgif.json', width: 300, height: 300),
              50.height,
              ElevatedButton(
                child: Text('Start', style: primaryTextStyle(weight: FontWeight.bold, size: 18, color: appStore.isDarkMode ? Colors.white : scaffoldColorDark)),
                onPressed: () async {
                  final canClick = await _canClick();
                  if (canClick) {
                    await _saveClickTime();
                    _playSound('sounds/startplay.mp3');
                  } else {
                    final hoursSinceLastClick = await _getHoursSinceLastClick();
                    final hoursRemaining = 24 - (hoursSinceLastClick ?? 0);
                    print("---------121>>>${hoursRemaining}");
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.success(
                        backgroundColor: primaryColor,
                        message:
                        "Please wait ${hoursRemaining.floor()} hours after play again.",
                      ),
                    );
                  }
                },
                style: buttonStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

  void showLeaderboardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const LeaderboardBottomSheet(),
    );
  }
}

//region App Name
import 'package:grip/utils/app_images.dart';

import '../main.dart';

const APP_NAME = "GRIP Fitness Center";
//endregion
var initialSteps = 0;

//region baseurl
/// Note: /Add your domain is www.abc.com
const mBackendURL = "https://gripbh.org/grip";



//endregion
//region Default Language Code
const DEFAULT_LANGUAGE = 'en';
//endregion

//region Change Walk Through Text
String WALK1_TITLE = languages.lblWalkTitle1;
String WALK2_TITLE = languages.lblWalkTitle2;
String WALK3_TITLE = languages.lblWalkTitle3;
//endregion

//region onesignal
const mOneSignalID = '4dadc3b7-3321-4cf7-881b-36f9b0fc5689';
//endregion

//region country

String? countryCode = "+973";
String? countryDail = "BH";
//endregion

//region logins
const ENABLE_SOCIAL_LOGIN = true;
const ENABLE_GOOGLE_SIGN_IN = true;
const ENABLE_OTP = true;
const ENABLE_APPLE_SIGN_IN = true;
//endregion

//region perPage value
const EQUIPMENT_PER_PAGE = 10;
const LEVEL_PER_PAGE = 10;
const WORKOUT_TYPE_PAGE = 10;
//endregion

//region payment description and identifier
const mRazorDescription = 'YOUR_PAYMENT_DESCRIPTION';
const mStripeIdentifier = 'YOUR_PAYMENT_IDENTIFIER';
//endregion

//region urls
const mBaseUrl = '$mBackendURL/api/';
//endregion

//region Manage Ads
// const showAdOnDietDetail = false;
// const showAdOnBlogDetail = false;
// const showAdOnExerciseDetail = false;
// const showAdOnProductDetail = false;
// const showAdOnWorkoutDetail = false;
// const showAdOnProgressDetail = false;

// const showBannerAdOnDiet = false;
// const showBannerOnProduct = false;
// const showBannerOnBodyPart = false;
// const showBannerOnEquipment = false;
// const showBannerOnLevel = false;
// const showBannerOnWorkouts = false;
//endregion



const List<String> firstTitles = ['Build muscle', 'Keep Fit', 'Lose weight'];
const List<String> firstDescriptions = [
  'Lower weight with higher reps and work on medium and small muscles',
  'Start with basic muscle workout plans and keep your muscles fit and toned',
  'Lower weight with higher reps and shorter rest times with cardio exercises',
];
final List<String> firstIcons = [
  ic_build,
  ic_keep,
  ic_lose,
];


const List<String> secondTitles = ['Totally newbie', 'beginner', 'Intermediate', 'Advanced'];
const List<String> secondDescriptions = [
  'I never workedout before',
  'I worked out before but not seriously',
  'I worked out before',
  'I have been working out for years',
];
final List<String> secondIcons = [
  empty_graph,
  one_graph,
  two_graph,
  full_graph,

];



const List<String> thirdTitles = ['No Equipment', 'Dumbbells', 'Garage Gym', 'Full Gym', 'Custom'];
const List<String> thirdDescriptions = [
  'Home workouts with body weight exercises',
  'Only exercises with dumbbell and body weight',
  'Exercises with barbell,dumbbell and body weight',
  'All exercises with machines,barbell and all',
  'Choose the equipments you have or wish to use',
];
final List<String> thirdIcons = [
  ic_noequpment,
  ic_dumbbell,
  garage_gym,
  full_gym,
  custom,
];



const mOneSignalAppId = '4dadc3b7-3321-4cf7-881b-36f9b0fc5689';
const mOneSignalRestKey = 'fn76tzatfe7efbjnydvxep7dx';
const mOneSignalChannelId = 'cd5f8181-121a-4417-bfc0-de3a9555d532';

//firebase keys
const FIREBASE_KEY = "AIzaSyC85SMXdVX3XLmTmxS23riDmYu4UE5kNbk";
const FIREBASE_APP_ID = "1:779709684006:android:0d97957f728af0ecce49e7";
const FIREBASE_MESSAGE_SENDER_ID = "779709684006";
const FIREBASE_PROJECT_ID = "grip-f77d3";
const FIREBASE_STORAGE_BUCKET_ID = "gs://grip-f77d3.firebasestorage.app";


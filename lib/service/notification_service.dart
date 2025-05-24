import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
import 'package:grip/extensions/extension_util/int_extensions.dart';
import 'package:grip/extensions/extension_util/string_extensions.dart';

import '../extensions/constants.dart';
import '../main.dart';
import '../utils/app_config.dart';

class NotificationService {
  Future<void> sendPushNotifications(String title, String content,
      {String? recevierUid,
      String? id,
      String? image,
      String? receiverPlayerId}) async {
    Map? req;
    var header = {
      HttpHeaders.authorizationHeader: 'Basic ${mOneSignalAppId}',
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      'Content-Type': 'application/json'
    };
    if (!recevierUid.isEmptyOrNull) {
      await chatMessageService.getUserPlayerId(uid: recevierUid).then((value) {
        try {
          req = {
            'headings': {
              'en': title,
            },
            'contents': {
              'en': content,
            },
            'data': {
              'id': recevierUid.validate(),
            },
            'big_picture': image.validate().isNotEmpty ? image.validate() : '',
            'large_icon': image.validate().isNotEmpty ? image.validate() : '',
            'app_id': mOneSignalAppId,
            'android_channel_id': mOneSignalChannelId,
            'include_player_ids': [value.playerId.validate()],
            'android_group': APP_NAME,
          };
        } catch (e) {
          print("=======catch${e.toString()}");
        }
      });
    } else {
      req = {
        'headings': {
          'en': title,
        },
        'contents': {
          'en': content,
        },
        'big_picture': image.validate().isNotEmpty ? image.validate() : '',
        'large_icon': image.validate().isNotEmpty ? image.validate() : '',
        'app_id': mOneSignalAppId,
        'android_channel_id': mOneSignalChannelId,
        'include_player_ids': [receiverPlayerId],
        'android_group': APP_NAME,
      };
    }

    log('======Notification request $req');

    Response res = await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      body: jsonEncode(req),
      headers: header,
    );

    if (res.statusCode.isSuccessful()) {
    } else {
      throw errorSomethingWentWrong;
    }
  }
}

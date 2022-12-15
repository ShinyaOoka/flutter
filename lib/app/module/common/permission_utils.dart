import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../generated/locale_keys.g.dart';

abstract class PermissionUtils {
  static Future<bool> storage() async {
    final status = await Permission.storage.status;

    if (status != PermissionStatus.granted) {
      if (await Permission.storage.shouldShowRequestRationale) {
        await Get.defaultDialog(
          content: Text(
            LocaleKeys.msg_storage_permission_explain.tr,
          ),
          onConfirm: () {
            Get.back(result: true);
          },
          onCancel: () {
            Get.back(result: false);
          }
        );
      } else {
        final newStatus = await Permission.storage.request();
        if (newStatus == PermissionStatus.granted) {
          return true;
        }
      }

      return false;
    }

    return true;
  }


  static Future<bool> camera() async {
    final status = await Permission.camera.status;

    if (status != PermissionStatus.granted) {
      if (await Permission.camera.shouldShowRequestRationale) {
        await Get.defaultDialog(
          content: Text(
            LocaleKeys.msg_camera_permission_explain.tr,
          ),
          onConfirm: () {
            Get.back(result: true);
          },
          onCancel: () {
            Get.back(result: false);
          }
        );

      } else {
        final newStatus = await Permission.camera.request();
        if (newStatus == PermissionStatus.granted) {
          return true;
        }
      }

      return false;
    }

    return true;
  }

  static Future<bool> microphone() async {
    final status = await Permission.microphone.status;

    if (status != PermissionStatus.granted) {
      if (await Permission.microphone.shouldShowRequestRationale) {
        // await Get.defaultDialog(
        //     content: Text(
        //       LocaleKeys.msg_microphone_permission_explain.tr,
        //     ),
        //     onConfirm: () {
        //       Get.back(result: true);
        //     },
        //     onCancel: () {
        //       Get.back(result: false);
        //     }
        // );
      } else {
        final newStatus = await Permission.microphone.request();
        if (newStatus == PermissionStatus.granted) {
          return true;
        }
      }

      return false;
    }

    return true;
  }
}

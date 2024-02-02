import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
const String BASE_URL="http://10.0.2.2:5000";

    // "https://photofrenzy-flask-backend.vercel.app";

void shareText(BuildContext context, String text) async {
  await Share.share(
    text,
  );
}

Future<XFile> getImageFileFromUrl(String imageUrl) async {
  try {
    final response = await Dio().get(
        imageUrl, options: Options(responseType: ResponseType.bytes));

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    final File file = File('$tempPath/temp_image.jpg');
    await file.writeAsBytes(response.data);

    return XFile(file.path);
  } catch (e) {
    print('Error downloading image: $e');
    return XFile("");
  }
}

void shareImage(BuildContext context, String text, String image) async {
  await Share.shareXFiles(
    [await getImageFileFromUrl(image)],
    text: text,
  );
}

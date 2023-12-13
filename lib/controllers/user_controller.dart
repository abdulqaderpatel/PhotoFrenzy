import 'package:get/get.dart';

import '../models/image_post.dart';
import '../models/text_post.dart';

class UserController extends GetxController {
  RxInt index = 0.obs;

  RxList<TextPost> textposts = <TextPost>[].obs;
  RxList<ImagePost> imageposts = <ImagePost>[].obs;

  void addTextPost(TextPost textPost) {
    textposts.add(textPost);
  }

  void addImagePost(ImagePost imagePost) {
    imageposts.add(imagePost);
  }
}

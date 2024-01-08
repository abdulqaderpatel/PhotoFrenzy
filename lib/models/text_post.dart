class TextPost {
  final String? creator_id;
  final String? creator_name;
  final String? creator_profile_picture;
  final String? creator_username;
  final String? post_id;
  final String? text;
  final String? type;
  int likes;
  List<dynamic> likers;
  int comments;
  List<dynamic> happy;
  List<dynamic> sad;
  List<dynamic> fear;
  List<dynamic> anger;
  List<dynamic> digust;
  List<dynamic> surprise;

  TextPost(
      this.creator_id,
      this.creator_name,
      this.creator_profile_picture,
      this.creator_username,
      this.post_id,
      this.text,
      this.type,
      this.likes,
      this.likers,
      this.comments,
      this.happy,
      this.sad,
      this.fear,
      this.anger,
      this.digust,
      this.surprise);
}

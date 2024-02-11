class BillModel {
  final String competition_name;
  final String competition_image;
  final String competition_id;
  final String start_time;
  final String end_time;
  final String id;
  final String image;
  final String name;
  final String creator;
  final int prize_money;
  final int votes;

  BillModel({
    required this.competition_name,
    required this.competition_image,
    required this.competition_id,
    required this.start_time,
    required this.end_time,
    required this.id,
    required this.image,
    required this.name,
    required this.creator,
    required this.prize_money,
    required this.votes,
  });
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../global/theme_mode.dart';

class UserCompetitionParticipationDetails extends StatefulWidget {
  final Map<String, dynamic> competitionSubmission;

  const UserCompetitionParticipationDetails(
      {required this.competitionSubmission, super.key});

  @override
  State<UserCompetitionParticipationDetails> createState() =>
      _UserCompetitionParticipationDetailsState();
}

class _UserCompetitionParticipationDetailsState
    extends State<UserCompetitionParticipationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Your Submission"),centerTitle: true,),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue,
                        width: 0.5),
                    borderRadius:
                    const BorderRadius.all(
                        Radius.circular(10))),
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.all(
                      Radius.circular(10)),
                  child: Image.network(
                    widget.competitionSubmission["image"],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                "Votes: ${widget.competitionSubmission["votes"]}",
                style: TextStyle(
                    color: isDark(context) ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

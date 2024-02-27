import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:photofrenzy/PDF/PDF_preview.dart';
import 'package:photofrenzy/models/bill.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Submission"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: Get.width,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 0.5),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    widget.competitionSubmission["image"],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Votes: ${widget.competitionSubmission["votes"]}",
                style: TextStyle(
                    color: isDark(context) ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: Size(Get.width, 40),

                  textStyle: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                  // Background color
                ),
                onPressed: () {
                  Get.to(
                    PdfPreviewPage(
                        bill: BillModel(
                            competition_name: widget
                                .competitionSubmission["competition_name"],
                            competition_image: widget
                                .competitionSubmission["competition_image"],
                            competition_id:
                                widget.competitionSubmission["competition_id"],
                            start_time:
                                widget.competitionSubmission["start_time"],
                            end_time: widget.competitionSubmission["end_time"],
                            id: widget.competitionSubmission["id"],
                            image: widget.competitionSubmission["image"],
                            name: widget.competitionSubmission["name"],
                            creator: widget.competitionSubmission["creator"],
                            votes: widget.competitionSubmission["votes"],
                            prize_money:
                                widget.competitionSubmission["price"])),
                  );
                },
                child: const Text("View Receipt"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

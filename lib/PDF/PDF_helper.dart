import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart';

import '../models/bill.dart';

Future<Uint8List> pdfBuilder(BillModel bill) async {
  final pdf = Document();
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/images/appicon.png'))
          .buffer
          .asUint8List());

  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Bill no: ${bill.competition_id}"),
                    Text("Attention to: ${bill.name}"),
                  ],
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(
                    imageLogo,
                  ),
                )
              ],
            ),
            Container(height: 50),
            Table(
              border: TableBorder.all(color: PdfColors.black),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Payment Receipt',
                        style: Theme.of(context).header4,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    textAndPadding('Bill To', align: TextAlign.center),
                    textAndPadding(bill.name),
                  ],
                ),
                TableRow(
                  children: [
                    textAndPadding('Amount', align: TextAlign.center),
                    textAndPadding(bill.prize_money.toString())
                  ],
                ),
                TableRow(
                  children: [
                    textAndPadding('Tax', align: TextAlign.center),
                    textAndPadding((bill.prize_money * 0.18).toString())
                  ],
                ),
                TableRow(
                  children: [
                    textAndPadding('Total', align: TextAlign.center),
                    textAndPadding(
                        (bill.prize_money * 1.18).toStringAsFixed(2).toString())
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
                "This bill is generated as part of PhotoFrenzys competition feature"),
            Divider(
              height: 1,
            ),
            Container(height: 50),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Text(
                'Please ensure all amount is paid to PhotoFrenzy Group',
                style: Theme.of(context).header2,
                textAlign: TextAlign.center,
              ),
            )
          ],
        );
      },
    ),
  );
  return pdf.save();
}

Widget textAndPadding(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(1),
      child: Text(
        text,
        textAlign: align,
      ),
    );

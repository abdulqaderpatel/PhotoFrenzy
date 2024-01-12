import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../models/shirt_data.dart';

List<String> sizeList = ["S", "M", "L", "XL", "XXL", "Custom"];

class DetailScreen extends StatelessWidget {
  final Shirt data;
  final Map<String, dynamic> details;

  const DetailScreen({super.key, required this.data, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(details["title"],
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
            Text("By ${details["creator_name"]}",
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: const [
          Icon(Icons.favorite_outline, color: Colors.brown),
          SizedBox(width: 10)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
                      margin: const EdgeInsets.all(15),
                      child: Image.network(details["imageurl"]),
                    ),

          Flexible(
            child: Container(

              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: const BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    "Price: ${details["price"]}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const Gap(10),
                  Container(
                    height: 80,
                    child: Text(
                      "Description: ${details["description"]}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Get.width * 0.44,
                        height: Get.height * 0.05,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width, 40),
                              backgroundColor: Colors.blue,
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              // Background color
                            ),
                            onPressed: () {},
                            child: const Text("Contact Owner")),
                      ),
                      SizedBox(
                        width: Get.width * 0.44,
                        height: Get.height * 0.05,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(Get.width, 40),
                              backgroundColor: Colors.yellow,
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              // Background color
                            ),
                            onPressed: () {},
                            child: const Text("Buy")),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

        ],
      ),

    );
  }
}

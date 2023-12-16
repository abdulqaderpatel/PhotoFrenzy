import 'package:flutter/material.dart';
import '../models/shirt_data.dart';

List<String> sizeList = ["S", "M", "L", "XL", "XXL", "Custom"];

class DetailScreen extends StatelessWidget {
  final Shirt data;

  const DetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.black,
                child: Container(
                  height: 450,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(25))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Slim Fit\n${data.title}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            )),
                            const SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 60,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  border: Border.all(),
                                ),
                                child: const Icon(Icons.arrow_back),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastEaseInToSlowEaseOut,
                        height: getSize(120),
                        child: Hero(
                            tag: "${data.id}",
                            child: Image.asset(data.imageUrl)),
                      ),
                      const Spacer(),
                      // const  SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                              height: 30,
                              child: Row(
                                children: [
                                  for (int i = 0; i < sizeList.length; i++) ...[
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          border: Border.all(),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(sizeList[i],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                      ),
                                    )
                                  ]
                                ],
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    color: Colors.black,
                    child: Container(
                      height: 100,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //   AnimatedSwitcher is used to animated the changes
                              // make sure to provide unique key to text other wise it won't work
                              AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    // we are adding FadeTransition effect to our counter text
                                    // here we are using SlideTransition to animate our counter in much cooler way
                                    // and we are creating the position to animate our text in specific direction

                                    final position = Tween<Offset>(
                                      begin: const Offset(0, 1),
                                      end: Offset.zero,
                                    );
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SlideTransition(
                                        position: position.animate(animation),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "test",
                                    key: UniqueKey(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(35),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                alignment: Alignment.center,
                                child: Text("\$${data.amount}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -50,
                    child: ClipOval(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          width: 120,
                          height: 100,
                          color: Colors.black,
                          alignment: Alignment.centerLeft,
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -50,
                    child: ClipOval(
                        child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        width: 120,
                        height: 100,
                        color: Colors.black,
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                color: Colors.black,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25))),
                  child: Column(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          var product = Shirt(
                              id: data.id,
                              title: data.title,
                              imageUrl: data.imageUrl,
                              amount: data.amount,
                              count: 1,
                              size: "XL");
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            height: 50,
                            padding: const EdgeInsets.only(left: 20, right: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add to Cart",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white),
                                  child: Icon(Icons.add_shopping_cart_outlined),
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ));
  }
}

getSize(value) {
  switch (value) {
    case "S":
      {
        return 200.0;
      }
    case "M":
      {
        return 220.0;
      }
    case "L":
      {
        return 240.0;
      }
    case "XL":
      {
        return 260.0;
      }
    case "XXL":
      {
        return 280.0;
      }
    case "Custom":
      {
        return 180.0;
      }
  }
}

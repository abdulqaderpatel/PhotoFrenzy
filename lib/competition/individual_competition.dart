import 'dart:io';
import 'dart:ui';

import 'dart:math' as math;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photofrenzy/global/firebase_tables.dart';
import 'package:matrix2d/matrix2d.dart';

import '../global/show_message.dart';

class IndividualCompetitionsScreen extends StatefulWidget {
  final String id;

  const IndividualCompetitionsScreen({required this.id, super.key});

  @override
  State<IndividualCompetitionsScreen> createState() =>
      _IndividualCompetitionsScreenState();
}

class _IndividualCompetitionsScreenState
    extends State<IndividualCompetitionsScreen> {
  File? postImage = File("");
  var buttonLoading = false;
  final picker = ImagePicker();

  FirebaseStorage storage = FirebaseStorage.instance;

  List<Map<String, dynamic>> items = [];
  bool isLoaded = false;


  void incrementCounter() async {
    setState(() {
      isLoaded = true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable()
        .competitionsTable
        .doc(widget.id)
        .collection("Images")
        .get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    items = temp;




    setState(() {
      isLoaded = false;
    });
  }

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        postImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    incrementCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoaded
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: Get.height * 0.8,
                color: Colors.blue,
                child: Expanded(
                    child: GridView.builder(
                      itemCount: items.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 images per row
                        crossAxisSpacing: 8.0, // Space between images horizontally
                        mainAxisSpacing: 8.0, // Space between images vertically
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Image.network(
                          items[index]["image"],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                ),
              ),
              InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: postImage!.path.isNotEmpty
                    ? Container(
                  constraints: BoxConstraints(
                      minWidth: Get.width,
                      minHeight: Get.height * 0.4,
                      maxHeight: Get.height * 0.5),
                  margin: const EdgeInsets.only(top: 10),
                  child: Image.file(
                    postImage!, // Replace with the path to your image
                    fit: BoxFit
                        .fill, // Use BoxFit.fill to force the image to fill the container
                  ),
                )
                    : Container(
                  constraints: BoxConstraints(
                      minWidth: Get.width,
                      minHeight: Get.height * 0.4,
                      maxHeight: Get.height * 0.5),
                  margin: const EdgeInsets.only(top: 10),
                  child: const Center(
                    child: Icon(Icons.camera),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: buttonLoading
                      ? null
                      : () {
                    setState(() {
                      buttonLoading = true;
                    });
                    int time =
                        DateTime
                            .now()
                            .millisecondsSinceEpoch;

                    Reference ref = FirebaseStorage.instance
                        .ref("/${widget.id}/$time");

                    UploadTask uploadTask =
                    ref.putFile(postImage!.absolute);

                    Future.value(uploadTask).then((value) async {
                      var newUrl = await ref.getDownloadURL();
                      await FirebaseTable()
                          .competitionsTable
                          .doc(widget.id)
                          .collection("Images")
                          .doc(time.toString())
                          .set({
                        "id": time.toString(),
                        "image": newUrl.toString()
                      });

                      showToast(
                          message: "Post created successfully");
                      setState(() {
                        buttonLoading = false;
                      });
                    });
                  },
                  child: buttonLoading
                      ? const CircularProgressIndicator()
                      : const Text("Add image"))
            ],
          ),
        ),
      ),
    );
  }
}

class TwoDimensionalGridView extends TwoDimensionalScrollView {
  const TwoDimensionalGridView({
    super.key,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails = const ScrollableDetails.vertical(),
    super.horizontalDetails = const ScrollableDetails.horizontal(),
    required TwoDimensionalChildBuilderDelegate delegate,
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  Widget buildViewport(BuildContext context,
      ViewportOffset verticalOffset,
      ViewportOffset horizontalOffset,) {
    return TwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }
}

class TwoDimensionalGridViewport extends TwoDimensionalViewport {
  const TwoDimensionalGridViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  });

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderTwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      childManager: context as TwoDimensionalChildManager,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(BuildContext context,
      RenderTwoDimensionalGridViewport renderObject,) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

class RenderTwoDimensionalGridViewport extends RenderTwoDimensionalViewport {
  RenderTwoDimensionalGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  void layoutChildSequence() {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;
    final double viewportWidth = viewportDimension.width + cacheExtent;
    final double viewportHeight = viewportDimension.height + cacheExtent;
    final TwoDimensionalChildBuilderDelegate builderDelegate =
    delegate as TwoDimensionalChildBuilderDelegate;

    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn = math.max((horizontalPixels / 200).floor(), 0);
    final int leadingRow = math.max((verticalPixels / 200).floor(), 0);
    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / 200).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / 200).ceil(),
      maxRowIndex,
    );

    double xLayoutOffset = (leadingColumn * 200) - horizontalOffset.pixels;
    for (int column = leadingColumn; column <= trailingColumn; column++) {
      double yLayoutOffset = (leadingRow * 200) - verticalOffset.pixels;
      for (int row = leadingRow; row <= trailingRow; row++) {
        final ChildVicinity vicinity =
        ChildVicinity(xIndex: column, yIndex: row);
        final RenderBox child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        // Subclasses only need to set the normalized layout offset. The super
        // class adjusts for reversed axes.
        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += 200;
      }
      xLayoutOffset += 200;
    }

    // Set the min and max scroll extents for each axis.
    final double verticalExtent = 200 * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );
    final double horizontalExtent = 200 * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
    // Super class handles garbage collection too!
  }
}

import 'package:flutter/material.dart';

class DynamicImageCarousel extends StatefulWidget {
  final List<Map<String, String>> imageDetails;
  final double aspectRatio;
  final double viewportFraction;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final bool enableInfiniteScroll;
  final double enlargeFactor;
  final double dotSize;
  final Color activeDotColor;
  final Color inactiveDotColor;
  final double borderRadius;
  final double? imageWidth;
  final double? imageHeight;
  final bool openModalOnClick;
  final TextStyle titleTextStyle;
  final TextStyle questionTextStyle;
  final TextStyle answerTextStyle;
  final double padding;
  final Widget? overlayContent;
  final double? dotHeightFromBottom;

  const DynamicImageCarousel({
    super.key,
    required this.imageDetails,
    this.aspectRatio = 1,
    this.viewportFraction = 0.9,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.enableInfiniteScroll = true,
    this.enlargeFactor = 0.8,
    this.dotSize = 7.0,
    this.activeDotColor = Colors.blue,
    this.inactiveDotColor = Colors.grey,
    this.borderRadius = 18.0,
    this.imageWidth,
    this.imageHeight,
    this.padding = 8.0,
    this.overlayContent,
    this.dotHeightFromBottom,
    this.openModalOnClick = true,
    required this.titleTextStyle,
    required this.questionTextStyle,
    required this.answerTextStyle,
  });

  @override
  State<DynamicImageCarousel> createState() => _DynamicImageCarouselState();
}

class _DynamicImageCarouselState extends State<DynamicImageCarousel> {
  int myCurrentIndex = 0;

  void _showImageDetails(BuildContext context, Map<String, String> imageData) {
    if (!widget.openModalOnClick) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double maxHeight = MediaQuery.of(context).size.height * 0.6;
                return Container(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: imageData['isAsset'] == 'true'
                            ? Image.asset(
                                imageData['bgImage']!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imageData['bgImage']!,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.black.withOpacity(0.6), // Darker overlay
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    imageData['title']!,
                                    style: widget.titleTextStyle,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    imageData['question']!,
                                    style: widget.questionTextStyle,
                                  ),
                                  if (imageData['question'] !=
                                      imageData['answer']) ...[
                                    SizedBox(height: 16),
                                    Text(
                                      imageData['answer']!,
                                      style: widget.answerTextStyle,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.imageHeight ?? 240.0,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.imageDetails.length,
            controller: PageController(
              viewportFraction: widget.viewportFraction,
            ),
            onPageChanged: (index) {
              setState(() {
                myCurrentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              Map<String, String> imageData = widget.imageDetails[index];
              bool isAsset = imageData['isAsset'] == 'true';

              return Padding(
                padding: EdgeInsets.all(widget.padding),
                child: GestureDetector(
                  onTap: () => _showImageDetails(context, imageData),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        child: isAsset
                            ? Image.asset(
                                imageData['url']!,
                                fit: BoxFit.cover,
                                width: widget.imageWidth ?? double.infinity,
                                height: widget.imageHeight ?? double.infinity,
                              )
                            : Image.network(
                                imageData['url']!,
                                fit: BoxFit.cover,
                                width: widget.imageWidth ?? double.infinity,
                                height: widget.imageHeight ?? double.infinity,
                              ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(40),
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                          ),
                          child: widget.overlayContent ??
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      imageData['title']!,
                                      style: widget.titleTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      imageData['question']!,
                                      style: widget.questionTextStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: widget.dotHeightFromBottom ?? 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageDetails.asMap().entries.map((entry) {
                return Container(
                  width: myCurrentIndex == entry.key
                      ? widget.dotSize * 2.4
                      : widget.dotSize,
                  height: widget.dotSize,
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: myCurrentIndex == entry.key
                        ? widget.activeDotColor
                        : widget.inactiveDotColor,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

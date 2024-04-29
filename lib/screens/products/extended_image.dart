import 'package:booking_system_flutter/component/cached_image_widget.dart';
import 'package:booking_system_flutter/model/product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

PageController _pageController = PageController();

class ExtendedImageWidget extends StatelessWidget {
  final List<Photos> imageList;
  final int currentPage;
  const ExtendedImageWidget({
    Key? key,
    required this.imageList,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: currentPage);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: black,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: PageView(
          controller: _pageController,
          children: List.generate(imageList.length, (index) {
            return GestureDetector(
              onDoubleTapDown: _handleDoubleTapDown,
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                  transformationController: _transformationController,
                  child: CachedImageWidget(
                      url: imageList[index].path.toString(), height: 1)
                  /* ... */
                  ),
            );
          }),
          onPageChanged: (ss) {
            _transformationController.value = Matrix4.identity();
          }),
    );
  }
}

final _transformationController = TransformationController();
TapDownDetails? _doubleTapDetails;

void _handleDoubleTapDown(TapDownDetails details) {
  _doubleTapDetails = details;
}

final position = _doubleTapDetails!.localPosition;

void _handleDoubleTap() {
  if (_transformationController.value != Matrix4.identity()) {
    _transformationController.value = Matrix4.identity();
  } else {
    // For a 3x zoom
    //  _transformationController.value = Matrix4.identity()
    //   ..translate(-position.dx * 2, -position.dy * 2)
    //   ..scale(3.0);
    // Fox a 2x zoom
    _transformationController.value = Matrix4.identity()
      ..translate(-position.dx, -position.dy)
      ..scale(2.0);
  }
}

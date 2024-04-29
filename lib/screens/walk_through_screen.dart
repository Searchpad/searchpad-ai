import 'package:booking_system_flutter/screens/dashboard/dashboard_screen.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  List<WalkThroughModelClass> pages = [];
  int currentPosition = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() async {
      pages.add(WalkThroughModelClass(
          title: language.lblWelcomeToHandyman,
          image: walk_Img1,
          subTitle: language.lblWalkThrough0));
      pages.add(WalkThroughModelClass(
          title: language.walkTitle1,
          image: walk_Img2,
          subTitle: language.walkThrough1));
      pages.add(WalkThroughModelClass(
          title: language.walkTitle2,
          image: walk_Img3,
          subTitle: language.walkThrough2));
      pages.add(WalkThroughModelClass(
          title: language.walkTitle3,
          image: walk_Img4,
          subTitle: language.walkThrough3));

      setState(() {});
    });
  }

  init() async {
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            itemCount: pages.length,
            itemBuilder: (BuildContext context, int index) {
              WalkThroughModelClass page = pages[index];
              return Container(
                child: Image.asset(
                  page.image.validate(),
                  fit: BoxFit.fill,
                ),
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Image.asset(page.image.validate(), height: context.height() * 0.45),
                //     76.height,
                //     Text(page.title.toString(), style: boldTextStyle(size: 22)),
                //     16.height,
                //     Text(page.subTitle.toString(), style: secondaryTextStyle()),
                //   ],
                // ),
              );
            },
            controller: pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (num) {
              currentPosition = num + 1;
              setState(() {});
            },
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () async {
                    await setValue(IS_FIRST_TIME, false);
                    DashboardScreen().launch(context,
                        isNewTask: true,
                        pageRouteAnimation: PageRouteAnimation.Fade);
                  },
                  child: Text(language.lblSkip,
                      style: boldTextStyle(color: black)),
                ),
                DotIndicator(
                  pageController: pageController,
                  pages: pages,
                  indicatorColor: black,
                  unselectedIndicatorColor: black.withOpacity(0.5),
                  currentBoxShape: BoxShape.circle,
                  boxShape: BoxShape.circle,
                  dotSize: 6,
                ),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () async {
                    if (currentPosition == 4) {
                      await setValue(IS_FIRST_TIME, false);
                      DashboardScreen().launch(context,
                          isNewTask: true,
                          pageRouteAnimation: PageRouteAnimation.Fade);
                    } else {
                      pageController.nextPage(
                          duration: 500.milliseconds,
                          curve: Curves.linearToEaseOut);
                    }
                  },
                  child: Text(
                      currentPosition == 4
                          ? language.getStarted
                          : language.btnNext,
                      style: boldTextStyle(color: black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

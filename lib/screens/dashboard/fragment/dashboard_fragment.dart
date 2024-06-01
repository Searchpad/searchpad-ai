import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/dashboard_model.dart';
import 'package:booking_system_flutter/model/product_list_model.dart';
import 'package:booking_system_flutter/network/rest_apis.dart';
import 'package:booking_system_flutter/screens/auth/pre_sign_in_screen.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/screens/auth/sign_up_screen.dart';
import 'package:booking_system_flutter/screens/dashboard/component/featured_product_list_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/featured_service_list_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/service_list_component.dart';
import 'package:booking_system_flutter/screens/dashboard/component/slider_and_location_component.dart';
import 'package:booking_system_flutter/screens/dashboard/shimmer/dashboard_shimmer.dart';
import 'package:booking_system_flutter/screens/products/cart_provider.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/constant.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../component/empty_error_state_widget.dart';
import '../../../component/loader_widget.dart';
import '../component/booking_confirmed_component.dart';
import '../component/category_component.dart';
import '../component/product_list_component.dart';

class DashboardFragment extends StatefulWidget {
  @override
  _DashboardFragmentState createState() => _DashboardFragmentState();
}

bool isFirstCall = true;

class _DashboardFragmentState extends State<DashboardFragment> {
  Future<DashboardResponse>? future;
  // ProvidersModel providerModel = ProvidersModel();
  ProductListModel productListModel = ProductListModel();
  @override
  void initState() {
    super.initState();

    init();

    setStatusBarColor(transparentColor, delayInMilliSeconds: 800);

    // LiveStream().on(LIVESTREAM_UPDATE_DASHBOARD, (p0) {
    //   init();
    //   setState(() {});
    // });
  }

  void init() async {
    future = userDashboard(
        isCurrentLocation: appStore.isCurrentLocation,
        lat: getDoubleAsync(LATITUDE),
        long: getDoubleAsync(LONGITUDE));
    ////
    productListModel.data = null;
    productListModel = await getProductList(
      isCurrentLocation: appStore.isCurrentLocation,
      dataCount: 10,
      offset: 1,
      userId: appStore.userId ?? 0,
      latitude: getDoubleAsync(LATITUDE),
      longitude: getDoubleAsync(LONGITUDE),
    );
    setState(() {});

    if (appStore.isLoggedIn) {
      await context.read<CartProvider>().getCartList();
    }
    // await checkPermission();

    if (isFirstCall) {
      if (!appStore.isLoggedIn) {
        Future.delayed(Duration(seconds: 3), () {
          showDialog(
              context: context,
              builder: (con) {
                return MyDialog();
              });
        });
      }

      setState(() {});
    }
    isFirstCall = false;
  }

  checkPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      await getLiveLocation();
    } else {
      await Permission.location.request();
      checkPermission();
    }
  }

  Geolocator geoLocator = Geolocator();
  getLiveLocation() async {
    Position positionStream = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    appStore.setLatitude(positionStream.latitude);
    appStore.setLongitude(positionStream.longitude);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(LIVESTREAM_UPDATE_DASHBOARD);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //     label: Text(
      //       '${'chat_with HandyMan'}',
      //     ),
      //     icon: const Icon(Icons.chat, color: Colors.white),
      //     backgroundColor: Theme.of(context).primaryColor,
      //     onPressed: () => ConversationScreen().launch(context)),
      child: Stack(
        children: [
          SnapHelperWidget<DashboardResponse>(
            initialData: cachedDashboardResponse,
            future: future,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: language.reload,
                onRetry: () {
                  appStore.setLoading(true);
                  init();

                  setState(() {});
                },
              );
            },
            loadingWidget: DashboardShimmer(),
            onSuccess: (snap) {
              return AnimatedScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                onSwipeRefresh: () async {
                  appStore.setLoading(true);

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                children: [
                  SliderLocationComponent(
                    sliderList: snap.slider.validate(),
                    callback: () async {
                      appStore.setLoading(true);

                      init();
                      setState(() {});
                    },
                  ),
                  30.height,
                  PendingBookingComponent(upcomingData: snap.upcomingData),
                  CategoryComponent(categoryList: snap.category.validate()),
                  // ProviderComponent(
                  //     providerList: providerModel.data.validate()),
                  16.height,
                  FeaturedServiceListComponent(
                      serviceList: snap.featuredServices.validate()),
                  ServiceListComponent(serviceList: snap.service.validate()),
                  ProductListComponent(productList: productListModel.data),
                  FeaturedProductListComponent(
                      productList: snap.featuredProduct.validate()),
                  // 16.height,
                  // NewJobRequestComponent(),
                ],
              );
            },
          ),
          Observer(
              builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}

class MyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Image.asset(login_signup),
            Text(
              language.loginSignup,
              style: primaryTextStyle(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    PreSigninScreen().launch(context);
                  },
                  child: Text(language.signIn,
                      style: primaryTextStyle(weight: FontWeight.bold)),
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(3),
                      backgroundColor: MaterialStatePropertyAll(primaryColor)),
                ),
                SizedBox(width: 10.0),
                OutlinedButton(
                  onPressed: () {
                    SignUpScreen().launch(context);
                  },
                  child: Text(language.signUp,
                      style: primaryTextStyle(weight: FontWeight.bold)),
                  style: ButtonStyle(
                      elevation: MaterialStatePropertyAll(3),
                      backgroundColor:
                          MaterialStatePropertyAll(transparentColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

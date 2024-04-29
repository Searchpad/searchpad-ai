import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/disabled_rating_bar_widget.dart';
import 'package:booking_system_flutter/component/image_border_component.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/component/user_info_widget.dart';
import 'package:booking_system_flutter/model/providers_model.dart';
import 'package:booking_system_flutter/screens/auth/sign_in_screen.dart';
import 'package:booking_system_flutter/store/filter_store.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import 'package:booking_system_flutter/utils/images.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../network/rest_apis.dart';
import '../booking/provider_info_screen.dart';

class ProviderListScreen extends StatefulWidget {
  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  Future<ProvidersModel>? futureProvider;
  List<Data> providerList = [];

  FocusNode myFocusNode = FocusNode();
  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    filterStore = FilterStore();
  }

  void init() async {
    fetchAllProviders(false);
  }

  void fetchAllProviders(isSearch) async {
    futureProvider = getProvidersData(10, page, "", appStore.userId);

    ProvidersModel dd;

    dd = await futureProvider!;
    if (page == dd.pagination?.totalPages) {
      isLastPage = true;
    }
    if (isSearch) {
      providerList = [];
    }
    for (var element in dd.data!) {
      providerList.add(element);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    filterStore.clearFilters();
    myFocusNode.dispose();
    filterStore.setSelectedSubCategory(catId: 0);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: language.lblProvierList,
      child: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onSwipeRefresh: () {
                fetchAllProviders(true);
                setState(() {});
                return Future.value(false);
              },
              children: [
                SnapHelperWidget(
                    future: futureProvider,
                    loadingWidget: LoaderWidget(),
                    errorBuilder: (p0) {
                      return NoDataWidget(
                        title: p0,
                        retryText: language.reload,
                        imageWidget: ErrorStateWidget(),
                        onRetry: () {
                          appStore.setLoading(true);
                          fetchAllProviders(true);
                        },
                      );
                    },
                    onSuccess: (data) {
                      return AnimatedListView(
                          itemCount: providerList.length,
                          listAnimationType: ListAnimationType.FadeIn,
                          fadeInConfiguration:
                              FadeInConfiguration(duration: 2.seconds),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          emptyWidget: NoDataWidget(
                            title: language.noDataAvailable,
                            imageWidget: EmptyStateWidget(),
                            onRetry: () {},
                            retryText: language.lblAddAddress,
                          ),
                          itemBuilder: (_, index) {
                            var data = providerList[index];
                            return ProviderWid(
                              data: data,
                              isOnTapEnabled: true,
                              onUpdate: () {},
                            );

                            // ProviderWidget(
                            //   providerData: data,
                            // );
                          });
                    })
              ],
            ).paddingAll(10).expand(),
          ],
        ),
      ),
    );
  }
}

class ProviderWid extends StatefulWidget {
  final data;
  final bool? isOnTapEnabled;
  final bool forProvider;
  final VoidCallback? onUpdate;

  ProviderWid(
      {required this.data,
      this.isOnTapEnabled,
      this.forProvider = true,
      this.onUpdate});

  @override
  State<ProviderWid> createState() => _ProviderWidState();
}

class _ProviderWidState extends State<ProviderWid> {
  @override
  void initState() {
    setStatusBarColor(primaryColor);
    super.initState();
  }

  //Favourite provider
  Future<bool> addProviderToWishList({required int providerId}) async {
    Map req = {"id": "", "provider_id": providerId, "user_id": appStore.userId};
    return await addProviderWishList(req).then((res) {
      toast(language.providerAddedToFavourite);
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<bool> removeProviderToWishList({required int providerId}) async {
    Map req = {"user_id": appStore.userId, 'provider_id': providerId};

    return await removeProviderWishList(req).then((res) {
      toast(language.providerRemovedFromFavourite);
      return true;
    }).catchError((error) {
      toast(error.toString());
      return false;
    });
  }

  Future<void> onTapFavouriteProvider() async {
    if (widget.data.isFavourite == 1) {
      widget.data.isFavourite = 0;
      setState(() {});

      await removeProviderToWishList(providerId: widget.data.id).then((value) {
        if (!value) {
          widget.data.isFavourite = 1;
          setState(() {});
          widget.onUpdate!.call();
        }
      });
    } else {
      widget.data.isFavourite = 1;
      setState(() {});

      await addProviderToWishList(providerId: widget.data.id).then((value) {
        if (!value) {
          widget.data.isFavourite = 0;
          setState(() {});
          widget.onUpdate!.call();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isOnTapEnabled.validate(value: false)
          ? null
          : () {
              ProviderInfoScreen(providerId: widget.data.id).launch(context);
            },
      child: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Container(
              height: 95,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: radiusCircular()),
                color: context.primaryColor,
              ),
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                decoration: boxDecorationDefault(
                  color: context.scaffoldBackgroundColor,
                  border: Border.all(color: context.dividerColor, width: 1),
                  borderRadius: radius(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ImageBorder(
                          callBack: false,
                          src: widget.data.profileImage,
                          height: 90,
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${widget.data.firstName} ${widget.data.lastName}",
                                                style: boldTextStyle(size: 18))
                                            .expand(),
                                        Image.asset(ic_verified,
                                                height: 18,
                                                width: 18,
                                                color: verifyAcColor)
                                            .visible(
                                                widget.data.isVerifyProvider ==
                                                    1),
                                        8.width,

                                        //Favourite provider
                                        // if (widget.data.isProvider)
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: boxDecorationWithShadow(
                                              boxShape: BoxShape.circle,
                                              backgroundColor:
                                                  context.cardColor),
                                          child: widget.data.isFavourite == 1
                                              ? ic_fill_heart.iconImage(
                                                  color: favouriteColor,
                                                  size: 20)
                                              : ic_heart.iconImage(
                                                  color: unFavouriteColor,
                                                  size: 20),
                                        ).onTap(() async {
                                          if (appStore.isLoggedIn) {
                                            onTapFavouriteProvider();
                                          } else {
                                            bool? res = await push(SignInScreen(
                                                returnExpected: true));

                                            if (res ?? false) {
                                              onTapFavouriteProvider();
                                            }
                                          }
                                        }),
                                      ],
                                    ),
                                    // if (widget.data.designation
                                    //     .validate()
                                    //     .isNotEmpty)
                                    //   Column(
                                    //     children: [
                                    //       4.height,
                                    //       Marquee(
                                    //           child: Text(
                                    //               widget.data.designation
                                    //                   .validate(),
                                    //               style: secondaryTextStyle(
                                    //                   size: 12,
                                    //                   weight:
                                    //                       FontWeight.bold))),
                                    //       4.height,
                                    //     ],
                                    //   ),
                                  ],
                                ).flexible(),
                              ],
                            ),
                            4.height,
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(language.lblMemberSince,
                            //         style: secondaryTextStyle(
                            //             size: 12, weight: FontWeight.bold)),
                            //     Text(
                            //         " ${DateTime.parse(widget.data.createdAt.validate()).year}",
                            //         style: secondaryTextStyle(
                            //             size: 12, weight: FontWeight.bold)),
                            //   ],
                            // ),
                            8.height,
                            DisabledRatingBarWidget(
                                rating: widget.data.providersServiceRating),
                          ],
                        ).expand(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

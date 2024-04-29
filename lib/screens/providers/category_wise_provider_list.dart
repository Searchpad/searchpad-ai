import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/model/category_wise_provider_model.dart';
import 'package:booking_system_flutter/screens/providers/provider_list_screen.dart';
import 'package:booking_system_flutter/store/filter_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../component/empty_error_state_widget.dart';
import '../../main.dart';
import '../../network/rest_apis.dart';
import '../../utils/constant.dart';
import '../booking/provider_info_screen.dart';

class CategoryWiseProviderScreen extends StatefulWidget {
  final int categoryId;

  const CategoryWiseProviderScreen({
    super.key,
    required this.categoryId,
  });

  @override
  State<CategoryWiseProviderScreen> createState() =>
      _CategoryWiseProviderScreenState();
}

class _CategoryWiseProviderScreenState
    extends State<CategoryWiseProviderScreen> {
  Future<CategoryWiseProviderModel>? futureCategoryProver;
  List<Providers> providerList = [];

  FocusNode myFocusNode = FocusNode();
  TextEditingController searchCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
    filterStore = FilterStore();
  }

  void init() async {
    fetchProviers(false);
  }

  void fetchProviers(isSearch) async {
    futureCategoryProver = fetchCategoryBasedSellers(
        catId: widget.categoryId, customerId: appStore.userId);
    var dd = await futureCategoryProver;
    providerList = dd!.providers!;
  }

  String get setSearchString {
    return language.products;
  }

  Widget subCategoryWidget() {
    return SnapHelperWidget<CategoryWiseProviderModel>(
      future: futureCategoryProver,
      // initialData: cachedSubcategoryList
      //     .firstWhere((element) => element?.$1 == widget.categoryId.validate(),
      //         orElse: () => null)
      //     ?.$2,
      loadingWidget: Offstage(),
      onSuccess: (list) {
        if (list.providers?.length == 1) return Offstage();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            16.height,
            Text(language.lblSubcategories,
                    style: boldTextStyle(size: LABEL_TEXT_SIZE))
                .paddingLeft(16),
            HorizontalList(
              itemCount: list.providers.validate().length,
              padding: EdgeInsets.only(left: 16, right: 16),
              runSpacing: 8,
              spacing: 12,
              itemBuilder: (_, index) {
                Providers data = list.providers![index];

                return Observer(
                  builder: (_) {
                    bool isSelected =
                        filterStore.selectedSubCategoryId == index;

                    return GestureDetector(
                      onTap: () {
                        appStore.setLoading(true);
                        fetchProviers(false);
                        setState(() {});
                      },
                      child: SizedBox(
                        width: context.width() / 4 - 20,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                16.height,
                                if (index == 0)
                                  Container(
                                    height: CATEGORY_ICON_SIZE,
                                    width: CATEGORY_ICON_SIZE,
                                    decoration: BoxDecoration(
                                        color: context.cardColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: grey)),
                                    alignment: Alignment.center,
                                    child: Text(data.firstName.validate(),
                                        style: boldTextStyle(size: 12)),
                                  ),
                                4.height,
                                if (index == 0)
                                  Text(language.lblViewAll,
                                      style: boldTextStyle(size: 12),
                                      textAlign: TextAlign.center,
                                      maxLines: 1),
                                if (index != 0)
                                  Marquee(
                                      child: Text(
                                          '${data.firstName.validate()}',
                                          style: boldTextStyle(size: 12),
                                          textAlign: TextAlign.center,
                                          maxLines: 1)),
                              ],
                            ),
                            Positioned(
                              top: 14,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: boxDecorationDefault(
                                    color: context.primaryColor),
                                child: Icon(Icons.done,
                                    size: 16, color: Colors.white),
                              ).visible(isSelected),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            16.height,
          ],
        );
      },
    );
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
      appBarTitle: language.provider,
      child: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onSwipeRefresh: () {
                fetchProviers(true);
                setState(() {});
                return Future.value(false);
              },
              children: [
                SnapHelperWidget(
                    future: futureCategoryProver,
                    loadingWidget: LoaderWidget(),
                    errorBuilder: (p0) {
                      return NoDataWidget(
                        title: p0,
                        retryText: language.reload,
                        imageWidget: ErrorStateWidget(),
                        onRetry: () {
                          appStore.setLoading(true);
                          fetchProviers(true);
                        },
                      );
                    },
                    onSuccess: (data) {
                      return AnimatedWrap(
                        runSpacing: 16,
                        spacing: 16,
                        itemCount: providerList.length,
                        listAnimationType: ListAnimationType.FadeIn,
                        fadeInConfiguration:
                            FadeInConfiguration(duration: 2.seconds),
                        scaleConfiguration: ScaleConfiguration(
                            duration: 300.milliseconds, delay: 50.milliseconds),
                        itemBuilder: (_, index) {
                          Providers dd = providerList[index];

                          return GestureDetector(
                              onTap: () async {
                                if (dd.id != appStore.userId.validate()) {
                                  await ProviderInfoScreen(
                                          providerId: dd.id.validate())
                                      .launch(context);
                                  setStatusBarColor(Colors.transparent);
                                }
                                // ViewAllServiceScreen(
                                //         categoryId: data.id.validate(),
                                //         categoryName: data.name,
                                //         isFromCategory: true)
                                //     .launch(context);
                              },
                              child: ProviderWid(
                                data: dd,
                              )

                              // CategoryWidget(
                              //     categoryData: data,
                              //     width: context.width() / 4 - 20),
                              );
                        },
                      );
                    })
              ],
            ).paddingAll(10).expand(),
          ],
        ),
      ),
    );
  }
}

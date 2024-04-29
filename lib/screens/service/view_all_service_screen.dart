import 'package:booking_system_flutter/screens/products/product_component.dart';
import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:booking_system_flutter/model/service_response.dart';
import 'package:booking_system_flutter/store/filter_store.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import '../../component/empty_error_state_widget.dart';
import '../../component/cached_image_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../model/service_data_model.dart';
import 'component/service_component.dart';
import '../../model/category_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import '../filter/filter_screen.dart';
import '../../network/rest_apis.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import '../../utils/common.dart';
import '../../main.dart';

class ViewAllServiceScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  final String isFeatured;
  final bool isFromProvider;
  final bool isFromCategory;
  final int? providerId;

  ViewAllServiceScreen({
    this.categoryId,
    this.categoryName = '',
    this.isFeatured = '',
    this.isFromProvider = true,
    this.isFromCategory = false,
    this.providerId,
    Key? key,
  }) : super(key: key);

  @override
  State<ViewAllServiceScreen> createState() => _ViewAllServiceScreenState();
}

class _ViewAllServiceScreenState extends State<ViewAllServiceScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  Future<List<CategoryData>>? futureCategory;
  List<CategoryData> categoryList = [];
  Future<ServiceResponse>? futureService;
  List<ServiceData> serviceList = [];
  List<Product> productList = [];

  FocusNode myFocusNode = FocusNode();
  TextEditingController searchCont = TextEditingController();

  int? subCategory;

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2,
        vsync: this,
        animationDuration: const Duration(milliseconds: 0));
    init();
    filterStore = FilterStore();
  }

  void init() async {
    fetchAllServiceData();

    if (widget.categoryId != null) {
      fetchCategoryList();
    }
  }

  void fetchCategoryList() async {
    futureCategory = getSubCategoryListAPI(catId: widget.categoryId!);
  }

  fetchAllServiceData() async {
    futureService = searchServiceAPI(
      page: page,
      list: serviceList,
      product: productList,
      categoryId: widget.categoryId != null
          ? widget.categoryId.validate().toString()
          : filterStore.categoryId.join(','),
      subCategory: subCategory != null ? subCategory.validate().toString() : '',
      providerId: widget.providerId != null
          ? widget.providerId.toString()
          : filterStore.providerId.join(","),
      isPriceMin: filterStore.isPriceMin,
      isPriceMax: filterStore.isPriceMax,
      search: searchCont.text,
      latitude: filterStore.latitude,
      longitude: filterStore.longitude,
      lastPageCallBack: (p0) {
        isLastPage = p0;
        setState(() {});
      },
      isFeatured: widget.isFeatured,
    );
  }

  String get setSearchString {
    if (!widget.categoryName.isEmptyOrNull) {
      return widget.categoryName!;
    } else if (widget.isFeatured == "1") {
      return language.lblFeatured;
    } else {
      return language.allServices;
    }
  }

  Widget subCategoryWidget() {
    return SnapHelperWidget<List<CategoryData>>(
      future: futureCategory,
      initialData: cachedSubcategoryList
          .firstWhere((element) => element?.$1 == widget.categoryId.validate(),
              orElse: () => null)
          ?.$2,
      loadingWidget: Offstage(),
      onSuccess: (list) {
        if (list.length == 1) return Offstage();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            16.height,
            Text(language.lblSubcategories,
                    style: boldTextStyle(size: LABEL_TEXT_SIZE))
                .paddingLeft(16),
            HorizontalList(
              itemCount: list.validate().length,
              padding: EdgeInsets.only(left: 16, right: 16),
              runSpacing: 8,
              spacing: 12,
              itemBuilder: (_, index) {
                CategoryData data = list[index];

                return Observer(
                  builder: (_) {
                    bool isSelected =
                        filterStore.selectedSubCategoryId == index;

                    return GestureDetector(
                      onTap: () {
                        filterStore.setSelectedSubCategory(catId: index);

                        subCategory = data.id;
                        page = 1;

                        // appStore.setLoading(true);
                        fetchAllServiceData();

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
                                    child: Text(data.name.validate(),
                                        style: boldTextStyle(size: 12)),
                                  ),
                                if (index != 0)
                                  data.categoryImage.validate().endsWith('.svg')
                                      ? Container(
                                          width: CATEGORY_ICON_SIZE,
                                          height: CATEGORY_ICON_SIZE,
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: context.cardColor,
                                              shape: BoxShape.circle),
                                          child: SvgPicture.network(
                                            data.categoryImage.validate(),
                                            height: CATEGORY_ICON_SIZE,
                                            width: CATEGORY_ICON_SIZE,
                                            color: appStore.isDarkMode
                                                ? Colors.white
                                                : data.color
                                                    .validate(value: '000')
                                                    .toColor(),
                                            placeholderBuilder: (context) =>
                                                PlaceHolderWidget(
                                                    height: CATEGORY_ICON_SIZE,
                                                    width: CATEGORY_ICON_SIZE,
                                                    color: transparentColor),
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              color: context.cardColor,
                                              shape: BoxShape.circle),
                                          child: CachedImageWidget(
                                            url: data.categoryImage.validate(),
                                            fit: BoxFit.fitWidth,
                                            width: SUBCATEGORY_ICON_SIZE,
                                            height: SUBCATEGORY_ICON_SIZE,
                                            circle: true,
                                          ),
                                        ),
                                4.height,
                                if (index == 0)
                                  Text(language.lblViewAll,
                                      style: boldTextStyle(size: 12),
                                      textAlign: TextAlign.center,
                                      maxLines: 1),
                                if (index != 0)
                                  Marquee(
                                      child: Text('${data.name.validate()}',
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
      appBarTitle: language.allServiceAndProduct,
      child: SizedBox(
        height: context.height(),
        width: context.width(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    focus: myFocusNode,
                    controller: searchCont,
                    suffix: CloseButton(
                      onPressed: () {
                        page = 1;
                        searchCont.clear();
                        filterStore.setSearch('');

                        appStore.setLoading(true);
                        fetchAllServiceData();
                        setState(() {});
                      },
                    ).visible(searchCont.text.isNotEmpty),
                    onFieldSubmitted: (s) {
                      page = 1;

                      filterStore.setSearch(s);
                      appStore.setLoading(true);

                      fetchAllServiceData();
                      setState(() {});
                    },
                    decoration: inputDecoration(context).copyWith(
                      hintText:
                          "${language.lblSearchFor} ${language.allServiceAndProduct}",
                      prefixIcon: ic_search.iconImage(size: 10).paddingAll(14),
                      hintStyle: secondaryTextStyle(),
                    ),
                  ).expand(),
                  16.width,
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        boxDecorationDefault(color: context.primaryColor),
                    child: CachedImageWidget(
                      url: ic_filter,
                      height: 26,
                      width: 26,
                      color: Colors.white,
                    ),
                  ).onTap(() {
                    hideKeyboard(context);

                    FilterScreen(
                            isFromProvider: widget.isFromProvider,
                            isFromCategory: widget.isFromCategory)
                        .launch(context)
                        .then((value) {
                      if (value != null) {
                        page = 1;
                        appStore.setLoading(true);

                        fetchAllServiceData();
                        setState(() {});
                      }
                    });
                  }, borderRadius: radius())
                ],
              ),
            ),

            /// Tab Bar
            TabBar(
              dividerColor: transparentColor,
              labelStyle: primaryTextStyle(size: 16, weight: FontWeight.bold),
              unselectedLabelColor: Colors.grey[500],
              unselectedLabelStyle:
                  primaryTextStyle(size: 16, weight: FontWeight.bold),
              controller: _tabController,
              // indicatorColor: Colors.transparent,
              labelColor: Colors.grey[800],
              tabs: [
                Tab(
                  text: language.service,
                ).paddingOnly(left: 20, right: 20),
                Tab(
                  text: language.products,
                ).paddingOnly(left: 20, right: 20),
              ],
              // indicator: BoxDecoration(
              //     shape: BoxShape.rectangle,
              //     color: primaryColor,
              //     borderRadius: BorderRadius.circular(5)),
            ),
            // TabBar(
            //   dividerColor: transparentColor,
            //   labelStyle: primaryTextStyle(size: 16, weight: FontWeight.bold),
            //   unselectedLabelColor: Colors.grey[600],
            //   unselectedLabelStyle:
            //       primaryTextStyle(size: 16, weight: FontWeight.bold),
            //   controller: _tabController,
            //   // indicatorColor: Colors.transparent,
            //   labelColor: const Color.fromARGB(255, 255, 255, 255),
            //   tabs: [
            //     Tab(
            //       text: language.service,
            //     ).paddingOnly(left: 20, right: 20),
            //     Tab(
            //       text: language.products,
            //     ).paddingOnly(left: 20, right: 20),
            //   ],
            //   indicator: BoxDecoration(
            //       shape: BoxShape.rectangle,
            //       color: primaryColor,
            //       borderRadius: BorderRadius.circular(5)),
            // ),
            Divider(),

            Expanded(
              child: TabBarView(
                // physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: <Widget>[
                  getServiceView(),
                  getProductView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedScrollView getProductView() {
    return AnimatedScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      onSwipeRefresh: () {
        page = 1;
        appStore.setLoading(true);
        fetchAllServiceData();
        setState(() {});

        return Future.value(false);
      },
      // onNextPage: () {
      //   if (!isLastPage) {
      //     page++;
      //     appStore.setLoading(true);
      //     fetchAllServiceData();
      //     setState(() {});
      //   }
      // },
      children: [
        if (widget.categoryId != null) subCategoryWidget(),
        16.height,
        SnapHelperWidget(
          future: futureService,
          // loadingWidget: LoaderWidget(),
          errorBuilder: (p0) {
            return NoDataWidget(
              title: p0,
              retryText: language.reload,
              imageWidget: ErrorStateWidget(),
              onRetry: () {
                page = 1;
                appStore.setLoading(true);

                fetchAllServiceData();
                setState(() {});
              },
            );
          },
          onSuccess: (data) {
            return productList.isEmpty
                ? NoDataWidget(
                    title: language.lblNoProductsFound,
                    subTitle: (searchCont.text.isNotEmpty ||
                            filterStore.providerId.isNotEmpty ||
                            filterStore.categoryId.isNotEmpty)
                        ? language.noDataFoundInFilter
                        : null,
                    imageWidget: EmptyStateWidget(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: productList.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.products,
                                    style: boldTextStyle(size: LABEL_TEXT_SIZE))
                                .paddingSymmetric(horizontal: 16),
                            AnimatedListView(
                              itemCount: productList.length,
                              listAnimationType: ListAnimationType.FadeIn,
                              fadeInConfiguration:
                                  FadeInConfiguration(duration: 2.seconds),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              emptyWidget: NoDataWidget(
                                title: language.lblNoProductsFound,
                                subTitle: (searchCont.text.isNotEmpty ||
                                        filterStore.providerId.isNotEmpty ||
                                        filterStore.categoryId.isNotEmpty)
                                    ? language.noDataFoundInFilter
                                    : null,
                                imageWidget: EmptyStateWidget(),
                              ),
                              itemBuilder: (_, index) {
                                return ProductComponent(
                                        productData: productList[index])
                                    .paddingAll(8);
                              },
                            ).paddingAll(8),
                          ],
                        ),
                      ),
                      if ((categoryList.isNotEmpty || serviceList.isNotEmpty) &&
                          !isLastPage)
                        Observer(builder: (_) {
                          return Center(
                            child: appStore.isLoading
                                ? CircularProgressIndicator()
                                : AppButton(
                                    color: primaryColor,
                                    height: 20,
                                    child: Text(
                                      language.showMore,
                                      style: primaryTextStyle(
                                          weight: FontWeight.bold),
                                    ),
                                    onTap: () async {
                                      if (!isLastPage) {
                                        page++;
                                        appStore.setLoading(true);
                                        await fetchAllServiceData();
                                      }
                                    },
                                  ),
                          ).paddingBottom(10);
                        })
                    ],
                  );
          },
        ),
      ],
    );
  }

  AnimatedScrollView getServiceView() {
    // ScrollController scrollController = ScrollController();

    return AnimatedScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      onSwipeRefresh: () {
        page = 1;
        appStore.setLoading(true);
        fetchAllServiceData();
        setState(() {});

        return Future.value(false);
      },
      // onNextPage: () {
      //   if (!isLastPage) {
      //     page++;
      //     appStore.setLoading(true);
      //     fetchAllServiceData();
      //     setState(() {});
      //   }
      // },
      children: [
        if (widget.categoryId != null) subCategoryWidget(),
        16.height,
        SnapHelperWidget(
          future: futureService,
          // loadingWidget: LoaderWidget(),
          errorBuilder: (p0) {
            return NoDataWidget(
              title: p0,
              retryText: language.reload,
              imageWidget: ErrorStateWidget(),
              onRetry: () {
                page = 1;
                appStore.setLoading(true);

                fetchAllServiceData();
                setState(() {});
              },
            );
          },
          onSuccess: (data) {
            return serviceList.isEmpty
                ? NoDataWidget(
                    title: language.lblNoServicesFound,
                    subTitle: (searchCont.text.isNotEmpty ||
                            filterStore.providerId.isNotEmpty ||
                            filterStore.categoryId.isNotEmpty)
                        ? language.noDataFoundInFilter
                        : null,
                    imageWidget: EmptyStateWidget(),
                    onRetry: () {
                      _tabController.index = 1;
                    },
                    retryText: language.seeProductAlso,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: serviceList.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language.service,
                                    style: boldTextStyle(size: LABEL_TEXT_SIZE))
                                .paddingSymmetric(horizontal: 16),
                            AnimatedListView(
                              itemCount: serviceList.length,
                              listAnimationType: ListAnimationType.FadeIn,
                              fadeInConfiguration:
                                  FadeInConfiguration(duration: 2.seconds),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              emptyWidget: NoDataWidget(
                                title: language.lblNoServicesFound,
                                subTitle: (searchCont.text.isNotEmpty ||
                                        filterStore.providerId.isNotEmpty ||
                                        filterStore.categoryId.isNotEmpty)
                                    ? language.noDataFoundInFilter
                                    : null,
                                imageWidget: EmptyStateWidget(),
                              ),
                              itemBuilder: (_, index) {
                                return ServiceComponent(
                                        serviceData: serviceList[index])
                                    .paddingAll(8);
                              },
                            ).paddingAll(8),
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
        if ((categoryList.isNotEmpty || serviceList.isNotEmpty) && !isLastPage)
          Observer(builder: (_) {
            return Center(
              child: appStore.isLoading
                  ? CircularProgressIndicator()
                  : AppButton(
                      color: primaryColor,
                      height: 20,
                      child: Text(
                        language.showMore,
                        style: primaryTextStyle(weight: FontWeight.bold),
                      ),
                      onTap: () async {
                        if (!isLastPage) {
                          page++;
                          appStore.setLoading(true);
                          await fetchAllServiceData();
                        }
                      },
                    ),
            ).paddingBottom(10);
          })
      ],
    );
  }
}

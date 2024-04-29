import 'package:booking_system_flutter/screens/products/product_component.dart';
import 'package:booking_system_flutter/component/base_scaffold_widget.dart';
import 'package:booking_system_flutter/model/product_list_model.dart';
import 'package:booking_system_flutter/utils/string_extensions.dart';
import 'package:booking_system_flutter/component/loader_widget.dart';
import 'package:booking_system_flutter/store/filter_store.dart';
import 'package:booking_system_flutter/utils/colors.dart';
import '../../component/empty_error_state_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import '../../network/rest_apis.dart';
import '../../utils/constant.dart';
import '../../utils/images.dart';
import '../../utils/common.dart';
import '../../main.dart';

class ViewAllProductScreen extends StatefulWidget {
  final int? brandId;
  final int? categoryId;
  final int? subCategoryId;
  final int? providerId;
  final String? search;
  final String? isFeatured;

  const ViewAllProductScreen(
      {super.key,
      this.brandId,
      this.categoryId,
      this.subCategoryId,
      this.providerId,
      this.isFeatured,
      this.search});

  @override
  State<ViewAllProductScreen> createState() => _ViewAllProductScreenState();
}

class _ViewAllProductScreenState extends State<ViewAllProductScreen> {
  Future<ProductListModel>? futureProduct;
  List<Data> productList = [];

  FocusNode myFocusNode = FocusNode();
  TextEditingController searchCont = TextEditingController();

  int? subCategory;

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    filterStore = FilterStore();
  }

  void init() async {
    fetchAllProducts(false);
  }

  // void fetchCategoryList() async {
  //   futureCategory = getSubCategoryListAPI(catId: widget.categoryId!);
  // }

  void fetchAllProducts(isSearch) async {
    futureProduct = getProductList(
        userId: appStore.userId ?? 0,
        offset: page,
        isFeatured: widget.isFeatured,
        search: searchCont.text,
        dataCount: 10,
        brandId: widget.brandId,
        categoryId: widget.categoryId,
        providerId: widget.providerId,
        subCategoryId: widget.subCategoryId,
        latitude: getDoubleAsync(LATITUDE),
        longitude: getDoubleAsync(LONGITUDE));

    ProductListModel dd;

    dd = await futureProduct!;
    if (page == dd.pagination?.totalPages) {
      isLastPage = true;
    }
    if (isSearch) {
      productList = [];
    }
    for (var element in dd.data!) {
      productList.add(element);
    }
  }

  String get setSearchString {
    return language.products;
  }

  Widget subCategoryWidget() {
    return SnapHelperWidget<ProductListModel>(
      future: futureProduct,
      // initialData: cachedSubcategoryList
      //     .firstWhere((element) => element?.$1 == widget.categoryId.validate(),
      //         orElse: () => null)
      //     ?.$2,
      loadingWidget: Offstage(),
      onSuccess: (list) {
        if (list.data?.length == 1) return Offstage();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            16.height,
            Text(language.lblSubcategories,
                    style: boldTextStyle(size: LABEL_TEXT_SIZE))
                .paddingLeft(16),
            HorizontalList(
              itemCount: list.data.validate().length,
              padding: EdgeInsets.only(left: 16, right: 16),
              runSpacing: 8,
              spacing: 12,
              itemBuilder: (_, index) {
                Data data = list.data![index];

                return Observer(
                  builder: (_) {
                    bool isSelected =
                        filterStore.selectedSubCategoryId == index;

                    return GestureDetector(
                      onTap: () {
                        filterStore.setSelectedSubCategory(catId: index);

                        subCategory = data.id;
                        page = 1;

                        appStore.setLoading(true);
                        fetchAllProducts(false);

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
                                // if (index != 0)
                                //   data.category..validate().endsWith('.svg')
                                //       ? Container(
                                //           width: CATEGORY_ICON_SIZE,
                                //           height: CATEGORY_ICON_SIZE,
                                //           padding: EdgeInsets.all(8),
                                //           decoration: BoxDecoration(
                                //               color: context.cardColor,
                                //               shape: BoxShape.circle),
                                //           child: SvgPicture.network(
                                //             data.categoryImage.validate(),
                                //             height: CATEGORY_ICON_SIZE,
                                //             width: CATEGORY_ICON_SIZE,
                                //             color: appStore.isDarkMode
                                //                 ? Colors.white
                                //                 : data.color
                                //                     .validate(value: '000')
                                //                     .toColor(),
                                //             placeholderBuilder: (context) =>
                                //                 PlaceHolderWidget(
                                //                     height: CATEGORY_ICON_SIZE,
                                //                     width: CATEGORY_ICON_SIZE,
                                //                     color: transparentColor),
                                //           ),
                                //         )
                                //       : Container(
                                //           padding: EdgeInsets.all(12),
                                //           decoration: BoxDecoration(
                                //               color: context.cardColor,
                                //               shape: BoxShape.circle),
                                //           child: CachedImageWidget(
                                //             url: data.categoryImage.validate(),
                                //             fit: BoxFit.fitWidth,
                                //             width: SUBCATEGORY_ICON_SIZE,
                                //             height: SUBCATEGORY_ICON_SIZE,
                                //             circle: true,
                                //           ),
                                //         ),
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
      appBarTitle: setSearchString,
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

                        fetchAllProducts(true);
                        setState(() {});
                      },
                    ).visible(searchCont.text.isNotEmpty),
                    onFieldSubmitted: (s) {
                      page = 1;
                      filterStore.setSearch(s);
                      appStore.setLoading(true);

                      fetchAllProducts(true);
                      setState(() {});
                    },
                    decoration: inputDecoration(context).copyWith(
                      hintText: "${language.lblSearchFor} $setSearchString",
                      prefixIcon: ic_search.iconImage(size: 10).paddingAll(14),
                      hintStyle: secondaryTextStyle(),
                    ),
                  ).expand(),
                  // 16.width,
                  // Container(
                  //   padding: EdgeInsets.all(10),
                  //   decoration:
                  //       boxDecorationDefault(color: context.primaryColor),
                  //   child: CachedImageWidget(
                  //     url: ic_filter,
                  //     height: 26,
                  //     width: 26,
                  //     color: Colors.white,
                  //   ),
                  // ).onTap(() {
                  //   hideKeyboard(context);

                  //   // FilterScreen(
                  //   //         isFromProvider: widget.isFromProvider,
                  //   //         isFromCategory: widget.isFromCategory)
                  //   //     .launch(context)
                  //   //     .then((value) {
                  //   //   if (value != null) {
                  //   //     page = 1;
                  //   //     appStore.setLoading(true);

                  //   //     fetchAllServiceData();
                  //   //     setState(() {});
                  //   //   }
                  //   // });
                  // }, borderRadius: radius())
                ],
              ),
            ),
            AnimatedScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              onSwipeRefresh: () {
                page = 1;
                appStore.setLoading(true);
                fetchAllProducts(true);
                setState(() {});

                return Future.value(false);
              },
              // onNextPage: () {
              //   if (!isLastPage) {
              //     page++;
              //     appStore.setLoading(true);
              //     fetchAllProducts(false);
              //     setState(() {});
              //   }
              // },
              children: [
                if (widget.categoryId != null) subCategoryWidget(),
                16.height,
                SnapHelperWidget(
                  future: futureProduct,
                  loadingWidget: LoaderWidget(),
                  errorBuilder: (p0) {
                    return NoDataWidget(
                      title: p0,
                      retryText: language.reload,
                      imageWidget: ErrorStateWidget(),
                      onRetry: () {
                        page = 1;
                        appStore.setLoading(true);
                        fetchAllProducts(true);
                        setState(() {});
                      },
                    );
                  },
                  onSuccess: (data) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
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
                            title: language.noProductFoundInFilter,
                            subTitle: (searchCont.text.isNotEmpty ||
                                    filterStore.providerId.isNotEmpty ||
                                    filterStore.categoryId.isNotEmpty)
                                ? language.noProductFoundInFilter
                                : null,
                            imageWidget: EmptyStateWidget(),
                          ),
                          itemBuilder: (_, index) {
                            return ProductComponent(
                                    productData: productList[index])
                                .paddingAll(8);
                          },
                        ).paddingAll(8),
                        if (productList.isNotEmpty && !isLastPage)
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
                                          fetchAllProducts(false);
                                          setState(() {});
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
            ).expand(),
          ],
        ),
      ),
    );
  }
}

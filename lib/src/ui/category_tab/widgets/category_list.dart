import 'package:Artisan/src/models/category_data/category_data.dart';
import 'package:Artisan/src/routing/router.dart';
import 'package:Artisan/src/ui/category_tab/widgets/category_list_card.dart';
import 'package:Artisan/src/widgets/artisan_paged_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/api_response.dart';

import '../category_tab_page_model.dart';

class CategoryListSection extends ConsumerStatefulWidget {
  const CategoryListSection({
    super.key,
  });

  @override
  ConsumerState<CategoryListSection> createState() => _CategoryListSection();
}

class _CategoryListSection extends ConsumerState<CategoryListSection> {
  static const _pageSize = 5;

  final PagingController<int, CategoryData> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    final response = await ref
        .read(categoryTabPageModelProvider.notifier)
        .getCategoryData(pageKey);
    if (response.status != ApiStatus.success) {
      _pagingController.error =
          response.errorMessage ?? 'Something went wrong!';
    } else {
      final list = response.data!.values.first;
      final isLastPage = list.length < _pageSize ||
          _pagingController.itemList?.length == response.data!.keys.first;
      if (isLastPage) {
        _pagingController.appendLastPage(list);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(list, nextPageKey);
      }
    }
  }

  _refresh() async {
    ref.read(categoryTabPageModelProvider.notifier).isRefreshing(true);
    final response = await ref
        .read(categoryTabPageModelProvider.notifier)
        .getCategoryData(1);

    _pagingController.value.itemList?.clear();
    if (mounted) {
      setState(() {});
    }
    if (response.status != ApiStatus.success) {
      _pagingController.error =
          response.errorMessage ?? 'Something went wrong!';
      _pagingController.refresh();
    } else {
      final list = response.data!.values.first;

      final isLastPage = list.length < _pageSize ||
          (_pagingController.itemList?.length ?? 0) + _pageSize >=
              response.data!.keys.first;
      if (isLastPage) {
        _pagingController.appendLastPage(list);
      } else {
        _pagingController.appendPage(list, 2);
      }
    }
    ref.read(categoryTabPageModelProvider.notifier).isRefreshing(false);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      categoryTabPageModelProvider,
      (previous, next) {
        if (previous?.refreshCounter != next.refreshCounter) {
          debugPrint('Refreshing...');
          _refresh();
        }
      },
    );

    return ArtisanPagedList<CategoryData>(_pagingController,
        itemBuilder: (context, data, index) {
      return GestureDetector(
        onTap: () {
          context.navigateTo(ProductListRoute(
              categoryId: data.id, categoryName: data.catName));
        },
        child: CategoryListCard(
          data: data,
          index: index,
          key: ValueKey(data),
        ),
      );
    }
        // noItemsFoundBuilder: (context) => const Text("No Item Found"),
        );
  }
}

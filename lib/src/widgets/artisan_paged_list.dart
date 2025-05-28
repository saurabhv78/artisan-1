import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import "../constants/colors.dart";

import '../utils/network_utils.dart';

class ArtisanPagedList<ItemType> extends PagedMasonryGridView<int, ItemType> {
  final Widget Function(
    BuildContext context,
    ItemType item,
    int index,
  ) itemBuilder;

  final Widget? emptyItemWidget;

  ArtisanPagedList(
    PagingController<int, ItemType> pagingController, {
    required this.itemBuilder,
    this.emptyItemWidget,
    super.padding,
    super.key,
  }) : super(
          pagingController: pagingController,
          gridDelegateBuilder: (index) =>
              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          builderDelegate: PagedChildBuilderDelegate<ItemType>(
            itemBuilder: itemBuilder,
            firstPageProgressIndicatorBuilder: (context) => const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            ),
            noItemsFoundIndicatorBuilder: (_) => FirstPageExceptionIndicator(
              errorWidget: emptyItemWidget ??
                  Text(
                    'No Item Found',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
            ),
            firstPageErrorIndicatorBuilder: (_) => FirstPageExceptionIndicator(
              errorWidget: null,
              errMessage: pagingController.error,
              onTryAgain: pagingController.retryLastFailedRequest,
            ),
            newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
              onTap: pagingController.retryLastFailedRequest,
            ),
          ),
        );
}

/// implementation of PagedSliverList with custom error UI
class ArtisanPagedSliverList<ItemType>
    extends PagedMasonryGridView<int, ItemType> {
  final Widget Function(
    BuildContext context,
    ItemType item,
    int index,
  ) itemBuilder;

  final Widget Function(BuildContext context)? noItemsFoundBuilder;

  ArtisanPagedSliverList(
    PagingController<int, ItemType> pagingController, {
    required this.itemBuilder,
    this.noItemsFoundBuilder,
    super.key,
  }) : super(
          pagingController: pagingController,
          // stagge
          gridDelegateBuilder: (index) =>
              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          builderDelegate: PagedChildBuilderDelegate<ItemType>(
            itemBuilder: itemBuilder,
            noItemsFoundIndicatorBuilder: (context) =>
                FirstPageExceptionIndicator(
              errorWidget: noItemsFoundBuilder?.call(context) ??
                  Text(
                    'No Item Found',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
            ),
            firstPageErrorIndicatorBuilder: (_) => FirstPageExceptionIndicator(
              errorWidget: null,
              onTryAgain: pagingController.retryLastFailedRequest,
            ),
            newPageErrorIndicatorBuilder: (_) => NewPageErrorIndicator(
              onTap: pagingController.retryLastFailedRequest,
            ),
          ),
        );
}

/// Widget to show first page error
class FirstPageExceptionIndicator extends StatefulWidget {
  const FirstPageExceptionIndicator({
    required this.errorWidget,
    this.onTryAgain,
    this.errMessage,
    super.key,
  });
  final String? errMessage;

  /// if error is null, then it checks for internet access and shows error accordingly
  final Widget? errorWidget;
  final VoidCallback? onTryAgain;

  @override
  State<FirstPageExceptionIndicator> createState() =>
      _FirstPageExceptionIndicatorState();
}

class _FirstPageExceptionIndicatorState
    extends State<FirstPageExceptionIndicator> {
  late final Future<bool?> _future;

  @override
  void initState() {
    super.initState();
    _future = hasInternetAccess();
  }

  @override
  Widget build(BuildContext context) {
    final errorWidget = widget.errorWidget;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: errorWidget ??
                  FutureBuilder<bool?>(
                    future: _future,
                    builder: (context, snapshot) => _buildErrorText(
                      context,
                      snapshot.connectionState == ConnectionState.waiting
                          ? ''
                          : snapshot.data == false
                              ? "No Internet Connection!"
                              : widget.errMessage ?? "Something Went Wrong!",
                    ),
                  ),
            ),
            if (widget.onTryAgain != null)
              const SizedBox(
                height: 16,
              ),
            if (widget.onTryAgain != null)
              SizedBox(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: widget.onTryAgain,
                  icon: const Icon(
                    Icons.refresh,
                    color: primaryColor,
                    size: 18,
                  ),
                  label: Text(
                    'Try Again',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _buildErrorText(BuildContext context, String errorString) => Text(
        errorString,
        textAlign: TextAlign.center,
        style: GoogleFonts.nunitoSans(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      );
}

/// Widget to show new page error
class NewPageErrorIndicator extends StatefulWidget {
  const NewPageErrorIndicator({
    super.key,
    this.onTap,
  });
  final VoidCallback? onTap;

  @override
  State<NewPageErrorIndicator> createState() => _NewPageErrorIndicatorState();
}

class _NewPageErrorIndicatorState extends State<NewPageErrorIndicator> {
  late final Future<bool?> _future;

  @override
  void initState() {
    super.initState();
    _future = hasInternetAccess();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<bool?>(
                    future: _future,
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.connectionState == ConnectionState.waiting
                            ? ''
                            : snapshot.data == false
                                ? 'No internet connection.\nTap to try again.'
                                : 'Something went wrong. Tap to try again.',
                        textAlign: TextAlign.center,
                      );
                    }),
                const SizedBox(
                  height: 4,
                ),
                const Icon(
                  Icons.refresh,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      );
}

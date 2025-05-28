import 'package:Artisan/src/ui/product/product_page_model.dart';
import 'package:Artisan/src/ui/product/widgets/widgets.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/try_again_widget.dart';

@RoutePage()
class ProductPage extends ConsumerStatefulWidget {
  final String id;

  const ProductPage({
    super.key,
    @PathParam('id') required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ref
          .read(productPageModelProvider.notifier)
          .getProductData(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productPageModelProvider, (prev, next) {});
    final moreByArtist = ref
        .watch(productPageModelProvider.select((value) => value.moreByArtist));
    final productData = ref
        .watch(productPageModelProvider.select((value) => value.productData));
    final status =
        ref.watch(productPageModelProvider.select((value) => value.status));
    return WillPopScope(
      onWillPop: () async {
        if (ref.exists(productPageModelProvider)) {
          await ref.read(productPageModelProvider.notifier).removeId(widget.id);
        }
        return true;
      },
      child: CustomScaffold(
        child: status == ProductPageStatus.loaded &&
                productData != null &&
                moreByArtist != null
            ? Stack(
                children: [
                  RefreshIndicator(
                    edgeOffset: 60,
                    onRefresh: () async {
                      return await ref
                          .read(productPageModelProvider.notifier)
                          .getProductData(widget.id);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ImageSection(data: productData),
                          const SizedBox(height: 10),
                          NamePriceSection(
                            productData: productData,
                          ),
                          const SizedBox(height: 20),
                          ArtistDetailSection(
                            artistData: productData.artistData,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MoreByArtistSection(
                            products: moreByArtist,
                            data: productData,
                          ),
                          const SizedBox(height: 75),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
                      height: 66,
                      width: MediaQuery.sizeOf(context).width,
                      child: BottomButtons(
                        data: productData,
                      ),
                    ),
                  ),
                ],
              )
            : TryAgainWidget(
                onTap: () {
                  ref
                      .read(productPageModelProvider.notifier)
                      .getProductData(widget.id);
                },
                isProcessing: status == ProductPageStatus.initial ||
                    status == ProductPageStatus.loading,
                errMessage: ref.watch(
                  productPageModelProvider.select(
                    (value) => value.errMessage.trim().isEmpty
                        ? "Something Went Wrong!!!"
                        : value.errMessage.trim(),
                  ),
                ),
              ),
      ),
    );
  }
}

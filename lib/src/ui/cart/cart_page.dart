import 'package:Artisan/src/ui/cart/cart_page_model.dart';
import 'package:Artisan/src/ui/cart/widgets/cart_bottom_sheet.dart';
import 'package:Artisan/src/ui/cart/widgets/widgets.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/try_again_widget.dart';

@RoutePage()
class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(cartPageModelProvider, (prev, next) {});
    final data =
        ref.watch(cartPageModelProvider.select((value) => value.cartData));
    final status =
        ref.watch(cartPageModelProvider.select((value) => value.status));
    return CustomScaffold(
        topPadding: 35,
        // bgColor: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                const CartAppBar(),
                status == CartPageStatus.loaded
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              const ChangeAddressSection(),
                              const SizedBox(height: 10),
                              CartProductListSection(
                                data: data.items,
                              ),
                              const SizedBox(height: 20),
                              // const MorePaintingSection(),
                              const SizedBox(height: 250),
                            ],
                          ),
                        ),
                      )
                    : TryAgainWidget(
                        onTap: () {
                          ref
                              .read(cartPageModelProvider.notifier)
                              .getCartData();
                        },
                        isProcessing: status == CartPageStatus.initial ||
                            status == CartPageStatus.loading,
                        errMessage: ref.watch(
                          cartPageModelProvider.select(
                            (value) => value.errorMessage.trim().isEmpty
                                ? data.items.isEmpty
                                    ? "No Favourite Found"
                                    : "Something Went Wrong!!!"
                                : value.errorMessage.trim(),
                          ),
                        ),
                      ),
              ],
            ),
            if (status == CartPageStatus.loaded && data.items.isNotEmpty)
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  child: const CartBottomSheet(),
                ),
              ),
          ],
        ));
  }
}

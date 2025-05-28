import 'package:Artisan/src/ui/product/product_page_model.dart';
import 'package:Artisan/src/widgets/custom_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../logic/repositories/auth_repository.dart';
import '../../../models/product_data/product_data.dart';
import '../../../routing/router.dart';
import '../../../utils/toast_utils.dart';

class BottomButtons extends ConsumerStatefulWidget {
  final ProductData data;
  const BottomButtons({
    super.key,
    required this.data,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomButtonsState();
}

class _BottomButtonsState extends ConsumerState<BottomButtons> {
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    final cartData =
        ref.watch(authRepositoryProvider.select((value) => value.cartData));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: cartData.contains(widget.data.id)
                  ? "Remove from bag"
                  : 'Add to bag',
              onTap: () async {
                if (!isProcessing) {
                  if (mounted) {
                    setState(() {
                      isProcessing = true;
                    });
                  }
                  final res = await ref
                      .read(productPageModelProvider.notifier)
                      .addToCart(
                        widget.data.id,
                        widget.data.discountData == null
                            ? 0
                            : widget.data.discountData!.discountVal,
                        !cartData.contains(widget.data.id),
                      );
                  if (res.keys.first != true) {
                    showErrorMessage(res.values.first);
                  } else {
                    showSuccessMessage(res.values.first);
                    ref.read(authRepositoryProvider.notifier).getCartData();
                  }
                  if (mounted) {
                    setState(() {
                      isProcessing = false;
                    });
                  }
                }
              },
              secondUI: true,
              isProcessing: isProcessing,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: CustomButton(
              text: 'Buy Now',
              onTap: () {
                context.navigateTo(const CartRoute());
              },
              isProcessing: false,
            ),
          ),
        ],
      ),
    );
  }
}

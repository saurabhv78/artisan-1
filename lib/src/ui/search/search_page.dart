import 'package:Artisan/src/ui/auth/widgets/back_btn.dart';
import 'package:Artisan/src/ui/search/search_page_model.dart';
import 'package:Artisan/src/ui/search/widgets/search_paged_list.dart';
import 'package:Artisan/src/ui/search/widgets/search_text_field.dart';
import 'package:Artisan/src/widgets/custom_scaffold.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(searchPageModelProvider, (prev, next) {});
    final text =
        ref.watch(searchPageModelProvider.select((value) => value.searchText));
    return CustomScaffold(
        bgColor: const Color(0xffEFE4FF),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(
              height: 15,
            ),
            Align(
              child: Row(
                children: [
                  BackBtn(
                    onTap: () {
                      context.maybePop();
                    },
                    iconColor: Colors.black,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Expanded(
                    child: SearchTextField(),
                  ),
                ],
              ),
            ),
            if (text.trim().length < 3) ...[
              Expanded(
                child: Center(
                  child: Text(
                    text.trim().isEmpty
                        ? 'Please type something to search'
                        : 'Please type at-least 3 characters to see the results',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            ] else ...[
              const Expanded(child: SearchPagedListSection()),
            ]
            // if (widget.categoryName != null) ...[
            //   const SizedBox(
            //     height: 20,
            //   ),
            //   Text(
            //     "Shop in “${widget.categoryName}”",
            //     style: const GoogleFonts.nunitoSans(
            //
            //       fontSize: 20,
            //       fontWeight: FontWeight.w400,
            //       color: Colors.black,
            //     ),
            //   ),
            // ],
            // Expanded(
            //     child: ProductPagedListSection(
            //   categoryId: widget.categoryId,
            //   discountId: widget.discountId,
            //   key: ValueKey(refreshCounter),
            // )),
          ]),
        ));
  }
}

import 'dart:developer';

import 'package:Artisan/src/constants/colors.dart';
import 'package:Artisan/src/models/product_data/product_data.dart';
import 'package:Artisan/src/widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NamePriceSection extends ConsumerWidget {
  final ProductData productData;
  const NamePriceSection({
    super.key,
    required this.productData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelStyle = GoogleFonts.nunitoSans(
      fontWeight: FontWeight.w500,
      fontSize: 13,
      color: Colors.black87,
    );
    final String shortDesc = productData.prodDesc.length > 95
        ? productData.prodDesc.substring(0, 95) + "..."
        : productData.prodDesc;
    final descStyle = GoogleFonts.nunitoSans(
      fontSize: 13,
      color: Colors.black87, fontWeight: FontWeight.w500,
      // height: 1.5,
    );
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                productData.prodName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w700,
                  color: bgDark,
                  fontSize: 20,
                  letterSpacing: .1,
                ),
              ),
            ],
          ),
          Row(children: [
            Text(
              "₹${(productData.discountData != null ? (productData.prodPrice - productData.prodPrice * productData.discountData!.discountVal / 100) : productData.prodPrice).toStringAsFixed(2)}",
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w700,
                color: bgDark,
                fontSize: 16,
                letterSpacing: .2,
              ),
            ),
            const SizedBox(
              width: 9,
            ),
            if (productData.discountData != null)
              Text(
                "₹${(productData.prodPrice).toStringAsFixed(2)}",
                style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: grayTextColor,
                  fontSize: 12,
                  color: grayTextColor,
                  letterSpacing: .2,
                ),
              ),
          ]),

          // Text(
          //   'Product Description:',
          //   style: GoogleFonts.nunitoSans(
          //     fontWeight: FontWeight.w400,
          //     // decoration: TextDecoration.lineThrough,
          //     // decorationColor: blackPrimaryColor,
          //     fontSize: 13,
          //     color: grayTextColor,
          //     letterSpacing: .2,
          //   ),
          // ),
          // const SizedBox(height: 8),
          // Text(
          //   productData.prodDesc.toString(),
          //   style: GoogleFonts.nunitoSans(
          //     fontWeight: FontWeight.w400,
          //     // decoration: TextDecoration.lineThrough,
          //     // decorationColor: blackPrimaryColor,
          //     fontSize: 13,
          //     color: bgDark,
          //     letterSpacing: .2,
          //   ),
          // ),
          // const SizedBox(height: 10),
          // _buildDetailRow(
          //   'Signed By Artist :',
          //   productData.signed == true ? "Yes" : "No",
          // ),
          // _buildDetailRow(
          //     'Framed :', productData.framed == true ? "Yes" : "No"),
          // _buildDetailRow('Dimensions :', productData.paintingSize.toString()),
          // _buildDetailRow(
          //   'Base Type :',
          //   productData.baseType.toString(),
          // ),
          // _buildDetailRow(
          //     'Painting Type :', productData.paintingType.toString()),

          Text('Product Description:',
              style: labelStyle.copyWith(color: Colors.black)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.7,
                  minChildSize: 0.3,
                  maxChildSize: 0.95,
                  builder: (context, scrollController) {
                    return Column(
                      children: [
                        // Drag handle
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // Header with title & close button
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Product Description",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 24),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),

                        // Scrollable content
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(
                              productData.prodDesc,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(text: shortDesc, style: descStyle),
                  if (productData.prodDesc.length > 95)
                    const TextSpan(
                      text: " See more",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Text(
          //   shortDesc,
          //   style: descStyle,
          //   // maxLines: 2,
          // ),
          const SizedBox(height: 10),
          const Divider(
            color: grayTextColor,
          ),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _iconWithLabel(
                icon: Image.asset(
                  "assets/images/Signature.png", // ✅ your icon path
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
                label: "Signed",
                value: productData.signed ? "Signed" : "Unsigned",
              ),
              Container(
                width: 2,
                height: 20,
                color: grayTextColor,
              ),
              _iconWithLabel(
                icon: Icon(LucideIcons.frame, size: 16, color: Colors.black),
                label: "Framed",
                value: productData.framed ? "Framed" : "Unframed",
              ),
              Container(
                width: 2,
                height: 20,
                color: grayTextColor,
              ),
              _iconWithLabel(
                icon: Icon(LucideIcons.expand, size: 16, color: Colors.black),
                label: "Size",
                value: (productData.paintingSize ?? "").isNotEmpty
                    ? productData.paintingSize!
                    : "N/A",
              ),
              Container(
                width: 2,
                height: 20,
                color: grayTextColor,
              ),
              _iconWithLabel(
                icon: Icon(LucideIcons.palette, size: 16, color: Colors.black),
                label: "Base",
                value: (productData.baseType ?? "").isNotEmpty
                    ? productData.baseType!
                    : "N/A",
              ),
              Container(
                width: 2,
                height: 20,
                color: grayTextColor,
              ),
              _iconWithLabel(
                icon: Icon(LucideIcons.brush, size: 16, color: Colors.black),
                label: "Type",
                value: (productData.paintingType ?? "").isNotEmpty
                    ? productData.paintingType!
                    : "N/A",
              ),
            ],
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              log(productData.authCertificate);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfViewScreen(
                    filePath: productData.authCertificate,
                    // "https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf", // test path
                  ),
                ),
              ); // const PDFView(
              //   filePath:
              //       "https://ontheline.trincoll.edu/images/bookdown/sample-local-pdf.pdf",
              // );
            },
            child: Row(
              children: [
                Image.asset(
                  "assets/images/cirtificate.png",
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 12),
                Text(
                  "Certified Product",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: grayTextColor,
          ),
        ]));
  }
}

Widget _iconWithLabel({
  required Widget icon, // change from IconData to Widget
  required String label,
  String? value,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      icon,
      const SizedBox(width: 6),
      Text(
        value ?? label,
        style: GoogleFonts.nunitoSans(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    ],
  );
}

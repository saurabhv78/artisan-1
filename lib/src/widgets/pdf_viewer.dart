import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class PdfViewScreen extends StatefulWidget {
  final String filePath; // Can be a local path, network URL, or asset path
  const PdfViewScreen({super.key, required this.filePath});

  @override
  State<PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<PdfViewScreen> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  String _errorMessage = "";

  PDFViewController? _pdfViewController;
  String? _resolvedLocalPath;

  bool _showOverlays = true;
  bool _swipeHorizontal = false;
  bool _nightMode = false;
  FitPolicy _fitPolicy = FitPolicy.BOTH;

  Future<void> _saveCopyToDocuments(BuildContext context) async {
    if (_resolvedLocalPath == null) return;
    try {
      final Directory docsDir = await getApplicationDocumentsDirectory();
      final String fileName = _resolvedLocalPath!.split('/').last;
      final String targetPath = '${docsDir.path}/$fileName';
      final File source = File(_resolvedLocalPath!);
      final File target = File(targetPath);
      await target.writeAsBytes(await source.readAsBytes(), flush: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved a copy to: $targetPath')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save copy: $e')),
      );
    }
  }

  Future<void> _showJumpToPageDialog(BuildContext context) async {
    if (_totalPages <= 0) return;
    final TextEditingController controller =
        TextEditingController(text: '${_currentPage + 1}');
    final int? selected = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Jump to page'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '1 - $_totalPages',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final int? value = int.tryParse(controller.text.trim());
                if (value == null || value < 1 || value > _totalPages) {
                  Navigator.of(ctx).pop();
                  return;
                }
                Navigator.of(ctx).pop(value);
              },
              child: const Text('Go'),
            ),
          ],
        );
      },
    );
    if (selected != null && _pdfViewController != null) {
      final int pageIndex = selected - 1;
      setState(() {
        _currentPage = pageIndex;
      });
      await _pdfViewController!.setPage(pageIndex);
      HapticFeedback.selectionClick();
    }
  }

  @override
  void initState() {
    super.initState();
    _prepareFile();
  }

  Future<void> _prepareFile() async {
    try {
      final String input = widget.filePath;
      if (input.startsWith('http://') || input.startsWith('https://')) {
        final String path = await _downloadToTemp(input);
        if (!mounted) return;
        setState(() {
          _resolvedLocalPath = path;
        });
      } else if (input.startsWith('assets/')) {
        final String path = await _copyAssetToTemp(input);
        if (!mounted) return;
        setState(() {
          _resolvedLocalPath = path;
        });
      } else {
        // Assume it's already a local file path
        if (await File(input).exists()) {
          setState(() {
            _resolvedLocalPath = input;
          });
        } else {
          throw Exception('File not found at path: $input');
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<String> _downloadToTemp(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download PDF (${response.statusCode})');
    }
    final Directory dir = await getTemporaryDirectory();
    final String filePath =
        '${dir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Future<String> _copyAssetToTemp(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    final Directory dir = await getTemporaryDirectory();
    final String filePath =
        '${dir.path}/asset_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final File file = File(filePath);
    await file.writeAsBytes(data.buffer.asUint8List());
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    // final String title = _resolvedLocalPath != null
    //     ? _resolvedLocalPath!.split('/').last
    //     : widget.filePath.split('/').last;

    return Scaffold(
      backgroundColor: const Color(0xffEFE4FF),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showOverlays = !_showOverlays;
          });
        },
        child: Stack(
          children: [
            if (_resolvedLocalPath != null)
              PDFView(
                filePath: _resolvedLocalPath,
                enableSwipe: true,
                swipeHorizontal: _swipeHorizontal,
                autoSpacing: true,
                pageFling: true,
                nightMode: _nightMode,
                fitPolicy: _fitPolicy,
                onRender: (pages) {
                  setState(() {
                    _totalPages = pages ?? 0;
                    _isReady = true;
                  });
                },
                onError: (error) {
                  setState(() {
                    _errorMessage = error.toString();
                  });
                },
                onPageError: (page, error) {
                  setState(() {
                    _errorMessage = "Error on page $page: $error";
                  });
                },
                onViewCreated: (controller) {
                  setState(() {
                    _pdfViewController = controller;
                  });
                },
                onPageChanged: (page, total) {
                  setState(() {
                    _currentPage = page ?? 0;
                  });
                  HapticFeedback.selectionClick();
                },
              ),
            if (_resolvedLocalPath == null && _errorMessage.isEmpty)
              const Center(child: CircularProgressIndicator()),
            if (_errorMessage.isNotEmpty)
              Center(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Top overlay bar
            if (_showOverlays)
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Certificate of Authenticity",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _isReady && _totalPages > 0
                                    ? 'Page ${_currentPage + 1} of $_totalPages'
                                    : 'Loading…',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom navigation bar with slider and controls
            if (_showOverlays && _isReady && _totalPages > 0)
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: _currentPage > 0
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                              ),
                              onPressed: (_pdfViewController != null &&
                                      _currentPage > 0)
                                  ? () async {
                                      await _pdfViewController!
                                          .setPage(_currentPage - 1);
                                      HapticFeedback.selectionClick();
                                    }
                                  : null,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8),
                                  trackHeight: 2.5,
                                ),
                                child: Slider(
                                  value: _currentPage
                                      .toDouble()
                                      .clamp(0, (_totalPages - 1).toDouble()),
                                  min: 0,
                                  max: (_totalPages - 1).toDouble(),
                                  divisions:
                                      _totalPages > 1 ? _totalPages - 1 : 1,
                                  label: 'Page ${_currentPage + 1}',
                                  onChanged: (value) async {
                                    final int page = value.round();
                                    setState(() {
                                      _currentPage = page;
                                    });
                                    if (_pdfViewController != null) {
                                      await _pdfViewController!.setPage(page);
                                    }
                                    HapticFeedback.selectionClick();
                                  },
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: _currentPage < _totalPages - 1
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                              ),
                              onPressed: (_pdfViewController != null &&
                                      _currentPage < _totalPages - 1)
                                  ? () async {
                                      await _pdfViewController!
                                          .setPage(_currentPage + 1);
                                      HapticFeedback.selectionClick();
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isReady
                              ? 'Page ${_currentPage + 1} / $_totalPages'
                              : 'Preparing…',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

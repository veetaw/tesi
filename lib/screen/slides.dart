import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:tesi/constants/asset_names.dart';
import 'package:tesi/constants/colors.dart';
import 'package:tesi/screen/quizhog.dart';

class Slides extends StatefulWidget {
  static const String routeName = "slides";

  const Slides({super.key});

  @override
  State<Slides> createState() => _SlidesState();
}

class _SlidesState extends State<Slides> {
  late PdfViewerController _pdfViewerController;
  OverlayEntry? _overlayEntry;

  File? _filePath;

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Errore'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickPDFFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final fileSize = file.lengthSync();
        if (fileSize <= 3 * 1024 * 1024) {
          setState(() {
            _filePath = file;
          });
        } else {
          _showErrorDialog("Il file selezionato supera i 3MB!");
        }
      }
    } catch (e) {
      _showErrorDialog("Errore nella selezione del file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuizHog'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Seleziona del testo per ricevere una spiegazione più dettagliata",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
              child: _filePath == null
                  ? Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBrownPrimary,
                          ),
                          onPressed: _pickPDFFile,
                          child: Text(
                            'Seleziona file PDF',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: kBrownAccent, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SfPdfViewer.file(
                          _filePath!,
                          onTextSelectionChanged:
                              (PdfTextSelectionChangedDetails details) {
                            if (details.selectedText == null &&
                                _overlayEntry != null) {
                              _overlayEntry!.remove();
                              _overlayEntry = null;
                            } else if (details.selectedText != null &&
                                _overlayEntry == null) {
                              _showContextMenu(context, details);
                            }
                          },
                          key: _pdfViewerKey,
                          controller: _pdfViewerController,
                          canShowTextSelectionMenu: false,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBrownLight,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      QuizHog.routeName,
                      arguments: ScreenInput(
                        pdfContent: _filePath,
                      ),
                    );
                  },
                  child: Text(
                    'Avanti',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    const double height = 50;
    const double width = 150;
    final OverlayState overlayState = Overlay.of(context);
    final Size screenSize = MediaQuery.of(context).size;

    double top = details.globalSelectedRegion!.top >= screenSize.height / 2
        ? details.globalSelectedRegion!.top - height - 10
        : details.globalSelectedRegion!.bottom + 20;
    top = top < 0 ? 20 : top;
    top = top + height > screenSize.height
        ? screenSize.height - height - 10
        : top;

    double left = details.globalSelectedRegion!.bottomLeft.dx;
    left = left < 0 ? 10 : left;
    left =
        left + width > screenSize.width ? screenSize.width - width - 10 : left;
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: top,
        left: left,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          constraints:
              const BoxConstraints.tightFor(width: width, height: height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  if (details.selectedText != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushNamed(
                        QuizHog.routeName,
                        arguments: ScreenInput(
                          textSelection: details.selectedText,
                          pdfContent: _filePath,
                        ),
                      );

                      _pdfViewerController.clearSelection();
                    });
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AssetNames.kBookInHandWalk,
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    Text(
                      'QuizHog',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
  }
}

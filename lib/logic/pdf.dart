import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:share/share.dart';

import 'package:app_cost/logic/option_selection.dart';

savePdf(Map project, List pages, {bool export = false}) async {
  Uint8List uint8list = await generateDocument(project, pages);
  Directory downloads = await DownloadsPathProvider.downloadsDirectory;
  String downloadsPath = path.join(downloads.path, "App Cost");
  Directory temp = await getTemporaryDirectory();

  String pdfName = "${project["name"]} Estimation.pdf";
  if (!export) {
    int counter = 2;
    while (await File(path.join(downloadsPath, pdfName)).exists()) {
      pdfName = "${project["name"]} Estimation_${counter++}.pdf";
    }
    if (await Permission.storage.request().isGranted) {
      String savePath = path.join(downloadsPath, pdfName);
      File file = await File(savePath).create(recursive: true);
      await file.writeAsBytes(uint8list);
      return savePath;
    }
  } else {
    pdfName = "${project["name"]} Estimation_EXPORT.pdf";
    await File(path.join(temp.path, pdfName)).writeAsBytes(uint8list);
    await Share.shareFiles(
      [path.join(temp.path, pdfName)],
      mimeTypes: ["application/pdf"],
      text: "${project["name"]} Estimation",
    );
  }
}

Future<Uint8List> generateDocument(Map project, List pages) async {
  final time = DateTime.now();

  final Document doc = Document(
    pageMode: PdfPageMode.fullscreen,
    theme: ThemeData(
      header1: TextStyle(fontSize: 14),
      tableHeader: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      tableCell: TextStyle(fontSize: 12),
      paragraphStyle: TextStyle(fontSize: 12),
    ),
  );

  const double inch = 72.0;
  const double cm = inch / 2.54;

  doc.addPage(
    MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) => <Widget>[
        Table.fromTextArray(
          context: context,
          border: null,
          headerCount: 0,
          tableWidth: null,
          cellPadding: EdgeInsets.all(3),
          // cellStyle: Theme.of(context).header1,
          columnWidths: {
            0: FixedColumnWidth(120),
            2: FixedColumnWidth(60),
          },
          data: <List<String>>[
            ["ESTIMATE:", "${project["name"]}"],
            [""],
            [""],
            [
              "Prepared by:",
              "FlutterCrew",
              "",
              "Date:",
              "${time.day}.${time.month}.${time.year}",
            ],
            ["E-mail:", "appcost@fluttercrew.com"],
          ],
        ),
        SizedBox(height: 1 * cm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table.fromTextArray(
                context: context,
                headerAlignment: Alignment.centerLeft,
                cellPadding: EdgeInsets.all(3),
                tableWidth: TableWidth.max,
                cellAlignments: {
                  0: Alignment.centerLeft,
                  1: Alignment.centerLeft,
                  2: Alignment.center,
                },
                columnWidths: {
                  0: FixedColumnWidth(135),
                  1: FixedColumnWidth(200),
                  2: FixedColumnWidth(75),
                },
                data: <List<String>>[
                  <String>['Description', 'Choosed', 'Estimate (hours)'],
                  for (int i = 0; i < project["optionSelection"].length; i++)
                    if (0 < i && i < project["optionSelection"].length - 2)
                      <String>[
                        '${pages[i]["alias"]}',
                        '${project["optionSelection"][pages[i]["alias"]].length > 0 ? project["optionSelection"][pages[i]["alias"]].join(", ") : "None"}',
                        '${estimate(project, project["optionSelection"][pages[i]["alias"]], pages[i]["options"])}'
                      ]
                ]),
            Table.fromTextArray(
              context: context,
              headerCount: 0,
              cellPadding: EdgeInsets.all(3),
              tableWidth: TableWidth.max,
              cellStyle: TextStyle(fontSize: 10),
              cellAlignments: {
                0: Alignment.centerLeft,
                1: Alignment.centerLeft,
                2: Alignment.center,
              },
              columnWidths: {
                0: FixedColumnWidth(135),
                1: FixedColumnWidth(200),
                2: FixedColumnWidth(75),
              },
              data: <List<String>>[
                for (int i = 0;
                    i < project["optionSelection"]["Additional"].length;
                    i++)
                  if (project["optionSelection"]["Additional"][i] != "None")
                    <String>[
                      'Additional Feature #${i + 1}',
                      '${project["optionSelection"]["Additional"][i]}',
                      'n/d'
                    ],
              ],
            ),
            Table.fromTextArray(
              context: context,
              headerCount: 0,
              cellPadding: EdgeInsets.all(3),
              tableWidth: TableWidth.max,
              cellStyle: Theme.of(context)
                  .tableCell
                  .copyWith(fontWeight: FontWeight.bold),
              cellAlignments: {
                0: Alignment.centerRight,
                1: Alignment.center,
              },
              columnWidths: {
                0: FixedColumnWidth(335),
                1: FixedColumnWidth(75),
              },
              data: <List<String>>[
                ["Total hours:", "${calculateEstimate(project).toInt()}"],
              ],
            ),
            Paragraph(
              text:
                  "Timeline: approx. ${(calculateEstimate(project) / 40).ceil().toInt()}-${(calculateEstimate(project) / 40).ceil().toInt() + 2} weeks.",
              margin: EdgeInsets.symmetric(vertical: 5.0 * PdfPageFormat.mm),
              style: Theme.of(context).tableHeader,
            )
          ],
        ),
        SizedBox(height: 1 * cm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Paragraph(
            //     text:
            //         "After delivery we will continue supporting the product for three months free of charge fixing any issues that were missed during the QA phase and might arise after launch during this period Further support is possible and is a matter of discussion upon request"),
            // Paragraph(text: ""),
            Paragraph(
                text:
                    "This is a rough estimate of services describe above, not a final bill. The pricing may change upon clearing all details, final design review or if project specifications change.",
                textAlign: TextAlign.left),
            Paragraph(
                text:
                    "If you have any questions regarding this document, please feel free to contact us.",
                style: Theme.of(context)
                    .header1
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left),
            Paragraph(text: "Sincerely yours, Flutter Crew."),
          ],
        ),
      ],
    ),
  );

  return doc.save();
}

String estimate(Map project, List pageChoosenOptions, List pageOptions) {
  Map optionEstimateFromTitle(String optionTitle) {
    Map _estimate;
    for (var pageOption in pageOptions) {
      if (pageOption["title"] == optionTitle)
        _estimate = pageOption["estimate"];
    }
    return _estimate ?? {"multiplier": "0", "hours": "0"};
  }

  List<int> _estimateValues = List();

  for (var option in pageChoosenOptions) {
    var localEstimateOptions = new Map()..addAll(project["estimateOptions"]);
    print(optionEstimateFromTitle(option).toString());
    decreaseEstimate(optionEstimateFromTitle(option),
        estimateOptions: localEstimateOptions);

    _estimateValues.insert(
        _estimateValues.length,
        (calculateEstimate(project) - calculateEstimate(localEstimateOptions))
            .toInt());
  }

  return _estimateValues.length > 0 ? _estimateValues.join(", ") : "0";
}

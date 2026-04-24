import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'notification_service.dart';

class DownloadService {
  /// Generates a CSV file from list of maps and shares it
  static Future<void> _writeAndShareCsv({
    required BuildContext context,
    required String fileName,
    required List<List<String>> csvData,
  }) async {
    try {
      final csvString = const ListToCsvConverter().convert(csvData);
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$fileName';
      final file = File(path);
      await file.writeAsString(csvString);

      await Share.shareXFiles(
        [XFile(path)],
        text: 'Here is your $fileName',
      );

      if (context.mounted) {
        NotificationService.showSuccess(
          context,
          'Receipt saved: $fileName',
        );
      }
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  /// Download receipt as a real CSV file
  static Future<void> downloadReceipt(
    BuildContext context, {
    required String fileName,
    required Map<String, dynamic> receiptData,
  }) async {
    final orderId = receiptData['orderId'] ?? 'N/A';
    final date = receiptData['date'] ?? 'N/A';
    final cafeteria = receiptData['cafeteria'] ?? 'N/A';
    final paymentMethod = receiptData['paymentMethod'] ?? 'N/A';
    final transactionId = receiptData['transactionId'] ?? 'N/A';
    final amount = receiptData['amount'] ?? 'N/A';
    final items = receiptData['items'] as List<dynamic>? ?? [];

    final csvData = <List<String>>[
      ['Canteeno Receipt'],
      [],
      ['Order ID', orderId],
      ['Date', date],
      ['Cafeteria', cafeteria],
      ['Payment Method', paymentMethod],
      ['Transaction ID', transactionId],
      ['Total Amount', amount],
      [],
      ['Item', 'Qty', 'Unit Price', 'Subtotal'],
      ...items.map((item) {
        final name = item['name']?.toString() ?? '';
        final qty = item['qty']?.toString() ?? '';
        final unit = item['unitPrice']?.toString() ?? '';
        final sub = item['subtotal']?.toString() ?? '';
        return [name, qty, unit, sub];
      }),
      [],
      ['Thank you for dining with Canteeno!'],
    ];

    await _writeAndShareCsv(
      context: context,
      fileName: fileName,
      csvData: csvData,
    );
  }

  /// Download transaction history as a real CSV file
  static Future<void> downloadTransactionHistory(
    BuildContext context, {
    required String fileName,
    required List<Map<String, dynamic>> transactions,
  }) async {
    final csvData = <List<String>>[
      ['Title', 'Date', 'Cafeteria', 'Payment Method', 'Amount'],
      ...transactions.map((tx) {
        return [
          tx['title']?.toString() ?? '',
          tx['date']?.toString() ?? '',
          tx['cafeteria']?.toString() ?? '',
          tx['paymentMethod']?.toString() ?? '',
          tx['amount']?.toString() ?? '',
        ];
      }),
    ];

    await _writeAndShareCsv(
      context: context,
      fileName: fileName,
      csvData: csvData,
    );
  }

  /// Download menu list
  static Future<void> downloadMenu(
    BuildContext context, {
    required String fileName,
    required List<Map<String, String>> items,
  }) async {
    final csvData = <List<String>>[
      ['Name', 'Category', 'Price', 'Cafeteria', 'Offer'],
      ...items.map((item) => [
        item['name'] ?? '',
        item['category'] ?? '',
        item['price'] ?? '',
        item['cafeteria'] ?? '',
        item['offer'] ?? '',
      ]),
    ];

    await _writeAndShareCsv(
      context: context,
      fileName: fileName,
      csvData: csvData,
    );
  }

  /// Download report (sales, revenue, etc.)
  static Future<void> downloadReport(
    BuildContext context, {
    required String fileName,
    required String reportType,
    required Map<String, dynamic> reportData,
  }) async {
    final csvData = <List<String>>[
      ['Report Type', reportType],
      ['Generated', DateTime.now().toIso8601String()],
      [],
      ['Key', 'Value'],
      ...reportData.entries.map((e) => [e.key, e.value.toString()]),
    ];

    await _writeAndShareCsv(
      context: context,
      fileName: fileName,
      csvData: csvData,
    );
  }

  /// Download order details
  static Future<void> downloadOrder(
    BuildContext context, {
    required String fileName,
    required String orderId,
    required List<Map<String, String>> items,
    required String totalAmount,
  }) async {
    final csvData = <List<String>>[
      ['Order ID', orderId],
      ['Total Amount', totalAmount],
      [],
      ['Item', 'Qty', 'Price'],
      ...items.map((item) => [
        item['name'] ?? '',
        item['qty'] ?? '',
        item['price'] ?? '',
      ]),
    ];

    await _writeAndShareCsv(
      context: context,
      fileName: fileName,
      csvData: csvData,
    );
  }

  /// Show download options dialog
  static void showDownloadOptions(
    BuildContext context, {
    required List<String> options,
    required Function(String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Download Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...options.map((option) => ListTile(
                  leading: const Icon(Icons.download, color: Color(0xFF9B1C1C)),
                  title: Text(option),
                  onTap: () {
                    Navigator.pop(context);
                    onSelect(option);
                  },
                )),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'notification_service.dart';

class DownloadService {
  /// Download receipt as PDF format (simulated)
  static void downloadReceipt(
    BuildContext context, {
    required String fileName,
    required String receiptData,
  }) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          NotificationService.showSuccess(
            context,
            'Receipt downloaded: $fileName.pdf',
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  /// Download menu list
  static void downloadMenu(
    BuildContext context, {
    required String fileName,
    required List<Map<String, String>> items,
  }) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          NotificationService.showSuccess(
            context,
            'Menu downloaded: $fileName.csv',
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  /// Download report (sales, revenue, etc.)
  static void downloadReport(
    BuildContext context, {
    required String fileName,
    required String reportType,
    required Map<String, dynamic> reportData,
  }) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          NotificationService.showSuccess(
            context,
            'Report downloaded: $fileName.csv',
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  /// Download transaction history
  static void downloadTransactionHistory(
    BuildContext context, {
    required String fileName,
    required List<Map<String, String>> transactions,
  }) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          NotificationService.showSuccess(
            context,
            'Transaction history downloaded: $fileName.csv',
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
  }

  /// Download order details
  static void downloadOrder(
    BuildContext context, {
    required String fileName,
    required String orderId,
    required List<Map<String, String>> items,
    required String totalAmount,
  }) {
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          NotificationService.showSuccess(
            context,
            'Order downloaded: $fileName.pdf',
          );
        }
      });
    } catch (e) {
      if (context.mounted) {
        NotificationService.showError(context, 'Download failed: $e');
      }
    }
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

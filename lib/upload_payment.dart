import 'dart:convert' show utf8, json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart' as sheets;

class PaymentUpload {
  static Future<Map<String, dynamic>> loadServiceAccountCredentials() async {
    final String jsonString =
        await rootBundle.loadString('assets/pulsebeat-4f88a40244ac.json');
    return json.decode(utf8.decode(jsonString.codeUnits))
        as Map<String, dynamic>;
  }

  static Future<void> insertValueIntoSpreadsheet(
      String emailID,
      String fullName,
      String paymentID,
      String transamount,
      String subscriptionplan,
      String startdate,
      String status) async {
    // Load and authenticate using the credentials JSON file
    final credentials = auth.ServiceAccountCredentials.fromJson(
        await loadServiceAccountCredentials());
    final client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);

    // Spreadsheet ID can be found in the URL of the spreadsheet
    const spreadsheetId = "1Z743UxQyVtKqq4yPnX-3B8_AOA7ohiP4_9ArWm4b2TM";

    try {
      // Prepare the range and values to append
      const sheet = "Payment-Details";
      const range = "$sheet!A2:G";
      final newRow = [
        [
          emailID,
          fullName,
          paymentID,
          transamount,
          subscriptionplan,
          startdate,
          status
        ]
      ];
      final appendValue = sheets.ValueRange.fromJson({"values": newRow});

      // Append the new row to the spreadsheet
      await sheets.SheetsApi(client).spreadsheets.values.append(
          appendValue, spreadsheetId, range,
          valueInputOption: "RAW", insertDataOption: "INSERT_ROWS");
    } catch (e) {
      // Handle the error appropriately
      // print("Error inserting value: $e");
    } finally {
      client.close();
    }
  }
}

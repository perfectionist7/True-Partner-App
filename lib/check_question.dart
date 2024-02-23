import 'dart:convert' show utf8, json;
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart' as sheets;

class CheckQuestion {
  static final Map<String, List<String>> checkQuestion = {};
  static List<String> answers = [];

  static Future<void> fetchDataFromSpreadsheet() async {
    // Load and authenticate using the credentials JSON file
    final credentials = auth.ServiceAccountCredentials.fromJson(
        await loadServiceAccountCredentials());
    final client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsReadonlyScope]);

    // Spreadsheet ID can be found in the URL of the spreadsheet
    const spreadsheetId = "1LbJke7ajYFi0TDyEeG7XrRzyse8Au0dkLEOaiYrQtaA";

    // The range of cells you want to read from (e.g., "Sheet1!A2:B")
    const range = "Sheet1!A2:E";

    try {
      var response = await sheets.SheetsApi(client)
          .spreadsheets
          .values
          .get(spreadsheetId, range);

      // Parse and update the data in the map
      if (response.values != null && response.values!.isNotEmpty) {
        for (var row in response.values!) {
          // Ensure the row has two columns (Key and Value)
          if (row.length >= 5) {
            final String key = row[0] as String;
            print("KEY IS: $key");
            final String value1 = row[1] as String;
            final String value2 = row[2] as String;
            final String value3 = row[3] as String;
            final String value4 = row[4] as String;
            checkQuestion[key] = [value1, value2, value3, value4];
            print("Value is: $value1");
            print("Value is: $value2");
            print("Value is: $value3");
            print("Value is: $value4");
          }
        }
        // checkSubscription.forEach((key, value) {
        //   print("$key: $value");
        // });
      }
    } catch (e) {
      // print("Error reading data: $e");
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>> loadServiceAccountCredentials() async {
    final String jsonString = await rootBundle
        .loadString('assets/true-partner-app-415205-ae667a16716b.json');
    return json.decode(utf8.decode(jsonString.codeUnits))
        as Map<String, dynamic>;
  }

  static String getAnswerFromKey(String key) {
    return checkQuestion[key]?[0] ?? "No option";
  }

  static List<String> getOptionsFromKey(String key) {
    answers[0] = checkQuestion[key]?[1] ?? "No option";
    answers[1] = checkQuestion[key]?[2] ?? "No option";
    answers[2] = checkQuestion[key]?[3] ?? "No option";
    return answers;
  }

  static Future<void> insertValueIntoSpreadsheet(
      String key, String value) async {
    // Load and authenticate using the credentials JSON file
    final credentials = auth.ServiceAccountCredentials.fromJson(
        await loadServiceAccountCredentials());
    final client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);

    // Spreadsheet ID can be found in the URL of the spreadsheet
    const spreadsheetId = "1LbJke7ajYFi0TDyEeG7XrRzyse8Au0dkLEOaiYrQtaA";

    try {
      // Find the row where the key is present
      const sheet = "Sheet1";
      const range = "$sheet!A2:E"; // Assuming data is in columns A, B, and C
      var response = await sheets.SheetsApi(client)
          .spreadsheets
          .values
          .get(spreadsheetId, range);

      if (response.values != null && response.values!.isNotEmpty) {
        for (var i = 0; i < response.values!.length; i++) {
          final row = response.values![i];
          if (row.length >= 4 && row[0] == key) {
            // Update the D column (index 3) in the corresponding row
            final newValue = value;
            final updateRange =
                "$sheet!C${i + 2}"; // Adding 2 because of 0-based index and header row
            final updateValue = sheets.ValueRange.fromJson({
              "values": [
                [newValue]
              ]
            });
            await sheets.SheetsApi(client).spreadsheets.values.update(
                updateValue, spreadsheetId, updateRange,
                valueInputOption: "RAW");
            break; // Exit the loop after updating
          }
        }
      } else {
        // print("No data found in the spreadsheet.");
      }
    } catch (e) {
      // print("Error inserting value: $e");
    } finally {
      client.close();
    }
  }

  static Future<void> insertValueIntoSpreadsheet1(
      String key, String value) async {
    // Load and authenticate using the credentials JSON file
    final credentials = auth.ServiceAccountCredentials.fromJson(
        await loadServiceAccountCredentials());
    final client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);

    // Spreadsheet ID can be found in the URL of the spreadsheet
    const spreadsheetId = "1LbJke7ajYFi0TDyEeG7XrRzyse8Au0dkLEOaiYrQtaA";

    try {
      // Find the row where the key is present
      const sheet = "Sheet1";
      const range = "$sheet!A2:E"; // Assuming data is in columns A, B, and C
      var response = await sheets.SheetsApi(client)
          .spreadsheets
          .values
          .get(spreadsheetId, range);

      if (response.values != null && response.values!.isNotEmpty) {
        for (var i = 0; i < response.values!.length; i++) {
          final row = response.values![i];
          if (row.length >= 2 && row[0] == key) {
            // Update the D column (index 3) in the corresponding row
            final newValue = value;
            final updateRange =
                "$sheet!D${i + 2}"; // Adding 2 because of 0-based index and header row
            final updateValue = sheets.ValueRange.fromJson({
              "values": [
                [newValue]
              ]
            });
            await sheets.SheetsApi(client).spreadsheets.values.update(
                updateValue, spreadsheetId, updateRange,
                valueInputOption: "RAW");
            break; // Exit the loop after updating
          }
        }
      } else {
        // print("No data found in the spreadsheet.");
      }
    } catch (e) {
      // print("Error inserting value: $e");
    } finally {
      client.close();
    }
  }
}

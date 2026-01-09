// lib/services/history_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_grow/models/history_model.dart';

class HistoryService {
  // Ganti dengan base URL API Anda
  static const String _baseUrl = 'http://195.35.23.135:3000';
  
  final http.Client _client = http.Client();
  
  // Fungsi untuk mengambil semua data history
  Future<List<HistoryData>> getAllHistory() async {
    try {
      print('📡 Fetching history data from API...');
      
      // Ambil data dari 3 endpoint berbeda
      final List<Future<List<HistoryData>>> futures = [
        _fetchDhtHistory(),
        _fetchJarakHistory(),
        _fetchTdsHistory(),
      ];
      
      final results = await Future.wait(futures);
      
      // Gabungkan semua data
      List<HistoryData> allData = [];
      for (var list in results) {
        allData.addAll(list);
      }
      
      // Urutkan berdasarkan timestamp (terbaru dulu)
      allData.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      print('✅ Fetched ${allData.length} history records');
      return allData;
      
    } catch (e) {
      print('❌ Error fetching history: $e');
      return [];
    }
  }
  
  // Ambil data DHT history (suhu & kelembaban)
  Future<List<HistoryData>> _fetchDhtHistory() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/api/dht-history'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => HistoryData.fromJson(json)).toList();
      } else {
        print('❌ DHT History API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ DHT History fetch error: $e');
      return [];
    }
  }
  
  // Ambil data jarak history (level air)
  Future<List<HistoryData>> _fetchJarakHistory() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/api/jarak-history'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => HistoryData.fromJson(json)).toList();
      } else {
        print('❌ Jarak History API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ Jarak History fetch error: $e');
      return [];
    }
  }
  
  // Ambil data TDS history (kualitas air)
  Future<List<HistoryData>> _fetchTdsHistory() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/api/tds-history'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => HistoryData.fromJson(json)).toList();
      } else {
        print('❌ TDS History API error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('❌ TDS History fetch error: $e');
      return [];
    }
  }
  
  // Filter data berdasarkan tanggal (opsional)
  Future<List<HistoryData>> getHistoryByDate(DateTime date) async {
    final allData = await getAllHistory();
    
    return allData.where((data) {
      try {
        final dataDate = DateTime.parse(data.timestamp);
        return dataDate.year == date.year &&
               dataDate.month == date.month &&
               dataDate.day == date.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }
  
  // Get latest data (misal 10 terbaru)
  Future<List<HistoryData>> getLatestHistory({int limit = 10}) async {
    final allData = await getAllHistory();
    return allData.take(limit).toList();
  }
  
  void dispose() {
    _client.close();
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WidgetHistoryData extends StatefulWidget {
  const WidgetHistoryData({super.key});

  @override
  State<WidgetHistoryData> createState() => _WidgetHistoryDataState();
}

class _WidgetHistoryDataState extends State<WidgetHistoryData> {
  List<Map<String, dynamic>> historyData = [];
  bool isLoading = true;
  bool useMockData = false;
  String errorMessage = "";

  final String baseUrl = "https://backendappsgh-project.up.railway.app/api";

  @override
  void initState() {
    super.initState();
    fetchAllHistoryData();
  }

  Future<void> fetchAllHistoryData() async {
    try {
      print("🔄 Mengambil semua data history...");

      // Ambil data dari semua endpoint secara paralel
      final responses = await Future.wait([
        _fetchHistoryData("/actuator-history/all", "actuator"),
        _fetchHistoryData("/dht-history/all", "dht"),
        _fetchHistoryData("/soil-history/all", "soil"),
        _fetchHistoryData("/jarak-history/all", "jarak"),
        _fetchHistoryData("/tds-history/all", "tds"),
      ]);

      // Proses dan gabungkan data
      final processedData = await _processAndMatchData(responses);
      
      setState(() {
        historyData = processedData;
        isLoading = false;
        useMockData = false;
        errorMessage = "";
      });
      
      print("✅ Berhasil memproses ${historyData.length} data history");
      
    } catch (e) {
      print("❌ Error: $e");
      
      setState(() {
        useMockData = true;
        isLoading = false;
        errorMessage = "Gagal mengambil data: ${e.toString()}";
        historyData = _generateMockHistoryData();
      });
    }
  }

  Future<Map<String, dynamic>> _fetchHistoryData(String endpoint, String type) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print("📡 Fetching $type history from: $url");
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      print("📊 Response status: ${response.statusCode}");
      
      if (response.statusCode != 200) {
        throw Exception("$type: Error ${response.statusCode}");
      }

      final Map<String, dynamic> decoded = json.decode(response.body);
      final count = decoded['count'] ?? 0;
      print("📦 $type history received: $count items");
      
      return {
        'type': type, 
        'data': decoded,
        'success': true,
        'count': count
      };
      
    } catch (e) {
      print("❌ Error fetching $type history: $e");
      return {'type': type, 'error': e.toString(), 'success': false};
    }
  }

  Future<List<Map<String, dynamic>>> _processAndMatchData(
      List<Map<String, dynamic>> responses) async {
    
    // Ekstrak semua data history
    List<Map<String, dynamic>> actuatorHistory = [];
    List<Map<String, dynamic>> dhtHistory = [];
    List<Map<String, dynamic>> soilHistory = [];
    List<Map<String, dynamic>> jarakHistory = [];
    List<Map<String, dynamic>> tdsHistory = [];

    for (var response in responses) {
      if (response['success'] != true) continue;
      
      final type = response['type'];
      final data = response['data'];
      
      if (data.containsKey('data') && data['data'] is List) {
        final List<dynamic> dataList = data['data'];
        
        switch (type) {
          case 'actuator':
            actuatorHistory = dataList.cast<Map<String, dynamic>>();
            print("✅ Actuator history: ${actuatorHistory.length} items");
            break;
            
          case 'dht':
            dhtHistory = dataList.cast<Map<String, dynamic>>();
            print("✅ DHT history: ${dhtHistory.length} items");
            break;
            
          case 'soil':
            soilHistory = dataList.cast<Map<String, dynamic>>();
            print("✅ Soil history: ${soilHistory.length} items");
            break;
            
          case 'jarak':
            jarakHistory = dataList.cast<Map<String, dynamic>>();
            print("✅ Jarak history: ${jarakHistory.length} items");
            break;
            
          case 'tds':
            tdsHistory = dataList.cast<Map<String, dynamic>>();
            print("✅ TDS history: ${tdsHistory.length} items");
            break;
        }
      }
    }

    // Jika tidak ada actuator history
    if (actuatorHistory.isEmpty) {
      throw Exception("Tidak ada data actuator history");
    }

    // Urutkan semua data berdasarkan timestamp (terbaru ke terlama)
    actuatorHistory.sort((a, b) => 
        DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp'])));
    
    dhtHistory.sort((a, b) => 
        DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
    
    jarakHistory.sort((a, b) => 
        DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));
    
    tdsHistory.sort((a, b) => 
        DateTime.parse(b['createdAt']).compareTo(DateTime.parse(a['createdAt'])));

    // Proses matching data
    final List<Map<String, dynamic>> matchedData = [];

    // Untuk setiap data actuator, cari data sensor yang cocok
    for (var actuator in actuatorHistory.take(15)) { // Ambil 15 data terbaru
      try {
        final actuatorTimestamp = actuator['timestamp']?.toString();
        if (actuatorTimestamp == null) continue;
        
        final actuatorTime = DateTime.parse(actuatorTimestamp);
        
        // Format tanggal
        final dayName = _getIndonesianDay(actuatorTime.weekday);
        final formattedDate = "${actuatorTime.year}-${actuatorTime.month.toString().padLeft(2, '0')}-${actuatorTime.day.toString().padLeft(2, '0')}";
        final formattedTime = "${actuatorTime.hour.toString().padLeft(2, '0')}:${actuatorTime.minute.toString().padLeft(2, '0')}:${actuatorTime.second.toString().padLeft(2, '0')}";
        
        // Cari data sensor yang paling mendekati timestamp actuator
        final temperature = _findClosestSensorValue(
          dhtHistory, actuatorTime, 'temperature', '°C');
        
        final soilHumidity = _findClosestSensorValue(
          soilHistory, actuatorTime, 'kelembaban_tanah', '%');
        
        final distanceValue = _findClosestSensorValue(
          jarakHistory, actuatorTime, 'distance_cm', '');
        
        final waterLevel = distanceValue != "N/A" 
            ? _calculateWaterLevel(double.parse(distanceValue))
            : "N/A";
        
        final tds = _findClosestSensorValue(
          tdsHistory, actuatorTime, 'tds_ppm', ' ppm');
        
        // Hitung berapa banyak sensor data yang tersedia
        int availableSensors = 0;
        if (temperature != "N/A") availableSensors++;
        if (soilHumidity != "N/A") availableSensors++;
        if (waterLevel != "N/A") availableSensors++;
        if (tds != "N/A") availableSensors++;
        
        matchedData.add({
          'dayName': dayName,
          'displayDate': "$formattedDate $formattedTime",
          'actuatorTime': actuatorTime,
          'pumpStatus': actuator['action']?.toString() ?? "-",
          'reason': actuator['reason']?.toString() ?? "",
          'source': actuator['source']?.toString() ?? "",
          
          // Sensor data
          'temperature': temperature,
          'soilHumidity': soilHumidity,
          'distance': distanceValue != "N/A" ? "$distanceValue cm" : "N/A",
          'waterLevel': waterLevel,
          'tds': tds,
          
          // Metadata
          'availableSensors': availableSensors,
          'hasSensorData': availableSensors > 0,
          'timestamp': actuatorTimestamp,
        });
        
      } catch (e) {
        print("⚠️ Error matching data for actuator: $e");
      }
    }
    
    return matchedData;
  }

  String _findClosestSensorValue(
    List<Map<String, dynamic>> sensorHistory,
    DateTime targetTime,
    String valueKey,
    String unit,
  ) {
    if (sensorHistory.isEmpty) return "N/A";
    
    try {
      Map<String, dynamic>? closestData;
      Duration? smallestDifference;
      
      for (var sensor in sensorHistory) {
        try {
          // Gunakan 'createdAt' untuk sensor, 'timestamp' untuk actuator
          final sensorTimestamp = sensor['createdAt']?.toString();
          if (sensorTimestamp == null) continue;
          
          final sensorTime = DateTime.parse(sensorTimestamp);
          final difference = sensorTime.difference(targetTime).abs();
          
          // Cari yang paling dekat (dalam 12 jam)
          if (difference.inHours <= 12) {
            if (smallestDifference == null || difference < smallestDifference) {
              smallestDifference = difference;
              closestData = sensor;
            }
          }
        } catch (e) {
          continue;
        }
      }
      
      if (closestData != null && closestData.containsKey(valueKey)) {
        final value = closestData[valueKey];
        if (value == null) return "N/A";
        
        if (value is num) {
          return '${value.toStringAsFixed(1)}$unit';
        } else if (value is String) {
          try {
            final numValue = double.parse(value);
            return '${numValue.toStringAsFixed(1)}$unit';
          } catch (e) {
            return '$value$unit';
          }
        }
        return '$value$unit';
      }
      
      return "N/A";
      
    } catch (e) {
      print("⚠️ Error finding closest sensor value: $e");
      return "N/A";
    }
  }

  String _calculateWaterLevel(double distance) {
    const maxDistance = 30.0;
    const minDistance = 10.0;
    
    if (distance <= minDistance) return "100%";
    if (distance >= maxDistance) return "0%";
    
    final percentage = 100 - ((distance - minDistance) / (maxDistance - minDistance)) * 100;
    return "${percentage.toStringAsFixed(0)}%";
  }

  String _getIndonesianDay(int weekday) {
    final days = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];
    return days[weekday % 7];
  }

  List<Map<String, dynamic>> _generateMockHistoryData() {
    final now = DateTime.now();
    final List<Map<String, dynamic>> mockData = [];
    
    for (int i = 0; i < 10; i++) {
      final d = now.subtract(Duration(hours: i * 3));
      final dayName = _getIndonesianDay(d.weekday);
      final formattedDate = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
      final formattedTime = "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}:${d.second.toString().padLeft(2, '0')}";
      
      // Simulasi beberapa data memiliki sensor, beberapa tidak
      final hasSensorData = i < 5;
      
      mockData.add({
        'dayName': dayName,
        'displayDate': "$formattedDate $formattedTime",
        'pumpStatus': i % 2 == 0 ? "ON" : "OFF",
        'reason': i % 3 == 0 ? "fsm_fill_tank" : "fsm_idle",
        'source': "controller",
        'temperature': hasSensorData ? "${25 + i}°C" : "N/A",
        'soilHumidity': hasSensorData ? "${30 + i * 2}%" : "N/A",
        'distance': hasSensorData ? "${20 + i} cm" : "N/A",
        'waterLevel': hasSensorData ? "${80 - i * 10}%" : "N/A",
        'tds': hasSensorData ? "${100 + i * 20} ppm" : "N/A",
        'availableSensors': hasSensorData ? 4 : 0,
        'hasSensorData': hasSensorData,
        'isMock': true,
      });
    }
    
    return mockData;
  }

  String _formatValue(String value) {
    if (value == "N/A" || value.isEmpty) {
      return "-";
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              "Memuat riwayat lengkap...",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchAllHistoryData,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            if (useMockData)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Menggunakan data simulasi\n$errorMessage",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 84, 50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        "📊 Riwayat Lengkap Sistem",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(Icons.power_settings_new, 
                          "Aktivitas", "${historyData.length}"),
                      _buildStatCard(Icons.sensors, 
                          "Data Sensor", "${historyData.where((d) => d['hasSensorData'] == true).length}"),
                    ],
                  ),
                ],
              ),
            ),
            // List history data
            ...historyData.map(
              (data) => Card(
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                color: data['hasSensorData'] == true
                    ? const Color.fromARGB(255, 34, 74, 36)
                    : const Color.fromARGB(255, 49, 84, 50),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${data['dayName']} [${data['displayDate']}]",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (data['hasSensorData'] == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.sensors, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    "${data['availableSensors']}/4",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: data['source'] == 'controller' 
                                  ? Colors.blue.shade800 
                                  : Colors.orange.shade800,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "📋 Pompa",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: data['pumpStatus'] == 'ON' 
                                  ? Colors.green.shade800 
                                  : Colors.red.shade800,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  data['pumpStatus'] == 'ON' 
                                      ? Icons.power_settings_new 
                                      : Icons.power_off,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  data['pumpStatus'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (data['reason']?.isNotEmpty == true) ...[
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "(${data['reason']})",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(top: 10, bottom: 12),
                      ),
                      
                      // Sensor Data Section
                      if (data['hasSensorData'] == true) ...[
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            _buildSensorChip("🌡", "Suhu", data['temperature']),
                            _buildSensorChip("🌱", "Tanah", data['soilHumidity']),
                            _buildSensorChip("💧", "Air", data['waterLevel']),
                            _buildSensorChip("📈", "TDS", data['tds']),
                          ],
                        ),
                        SizedBox(height: 10),
                      ] else ...[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, 
                                    size: 14, color: Colors.white70),
                                SizedBox(width: 6),
                                Text(
                                  "Tidak ada data sensor yang terekam",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            
            // Load more indicator
            if (historyData.length >= 15)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "📄 Menampilkan 15 data terbaru dari total ${historyData.length}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSensorChip(String emoji, String label, String value) {
    final isAvailable = value != "N/A" && value != "-";
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable 
            ? Colors.white.withOpacity(0.15)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAvailable 
              ? Colors.white.withOpacity(0.3)
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$emoji ", style: TextStyle(
            fontSize: 13,
            color: isAvailable ? Colors.white : Colors.white54,
          )),
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 15,
              color: isAvailable ? Colors.white : Colors.white54,
            ),
          ),
          Text(
            _formatValue(value),
            style: TextStyle(
              fontSize: 15,
              color: isAvailable ? Colors.white : Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final format = DateFormat('dd/MM/yyyy HH:mm:ss', 'id_ID');
      return format.format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  String _getDateRange(List<Map<String, dynamic>> data) {
    if (data.length < 2) return "1";
    
    try {
      final first = DateTime.parse(data.first['timestamp']);
      final last = DateTime.parse(data.last['timestamp']);
      final difference = first.difference(last).abs();
      return difference.inDays.toString();
    } catch (e) {
      return "7";
    }
  }
}
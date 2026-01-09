// lib/models/history_model.dart
class HistoryData {
  final String id;
  final String timestamp;
  final double? temperature;
  final double? humidity;
  final double? distanceCm;
  final double? tdsPpm;
  final String? ipAddress;
  
  HistoryData({
    required this.id,
    required this.timestamp,
    this.temperature,
    this.humidity,
    this.distanceCm,
    this.tdsPpm,
    this.ipAddress,
  });
  
  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      id: json['_id'] ?? json['id'] ?? '',
      timestamp: json['timestamp'] ?? '',
      temperature: _parseDouble(json['temperature']),
      humidity: _parseDouble(json['humidity']),
      distanceCm: _parseDouble(json['distance_cm']),
      tdsPpm: _parseDouble(json['tds_ppm']),
      ipAddress: json['ip'] ?? json['ipAddress'],
    );
  }
  
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
  
  // Format date untuk display
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${_getDayName(dateTime.weekday)}, ${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
    } catch (e) {
      return timestamp;
    }
  }
  
  String get formattedTime {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
  
  String _getDayName(int day) {
    switch (day) {
      case 1: return 'Senin';
      case 2: return 'Selasa';
      case 3: return 'Rabu';
      case 4: return 'Kamis';
      case 5: return 'Jumat';
      case 6: return 'Sabtu';
      case 7: return 'Minggu';
      default: return '';
    }
  }
  
  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Januari';
      case 2: return 'Februari';
      case 3: return 'Maret';
      case 4: return 'April';
      case 5: return 'Mei';
      case 6: return 'Juni';
      case 7: return 'Juli';
      case 8: return 'Agustus';
      case 9: return 'September';
      case 10: return 'Oktober';
      case 11: return 'November';
      case 12: return 'Desember';
      default: return '';
    }
  }
}
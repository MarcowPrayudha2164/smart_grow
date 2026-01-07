class SensorData {
  double temperature = 0;  
  double soilHumidity = 0;    
  double ph = 0;            
  double waterLevel = 0;    
  double waterQuality = 0;   
  double airHumidity = 0; 
  
  // Timestamp terakhir update untuk setiap sensor
  Map<String, DateTime> lastUpdate = {
    'sensor_dht11': DateTime.now(),
    'sensor_tanah': DateTime.now(),
    'sensor_ph': DateTime.now(),
    'sensor_tingkat_air': DateTime.now(),
    'sensor_kualitas': DateTime.now(),
  };
  
  // Update data dari queue tertentu
  void updateFromQueue(String queueName, Map<String, dynamic> data) {
    switch (queueName) {
      case 'sensor_tanah':
        soilHumidity = _parseDouble(data['kelembaban_tanah']);
        break;
      case 'sensor_dht11':
        temperature = _parseDouble(data['suhu']);
        airHumidity = _parseDouble(data['kelembaban_udara']);
        break;
      case 'sensor_ph':
        ph = _parseDouble(data['ph'] ?? data['value']);
        break;
      case 'sensor_tingkat_air':
        waterLevel = _parseDouble(data['level'] ?? data['value']);
        break;
      case 'sensor_kualitas':
        waterQuality = _parseDouble(data['ppm'] ?? data['value']);
        break;
    }
    
    // Update timestamp
    lastUpdate[queueName] = DateTime.now();
  }
  
  // Check jika data dari sensor sudah expired (lebih dari 1 menit)
  bool isDataExpired(String queueName) {
    final lastUpdateTime = lastUpdate[queueName];
    if (lastUpdateTime == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastUpdateTime);
    return difference.inSeconds > 60; // 1 menit
  }
  
  // Get formatted value dengan pengecekan expired
  String getFormattedValue({
    required double value,
    required String suffix,
    bool isExpired = false,
  }) {
    if (isExpired) {
      return 'N/A';
    }
    return '${value.toStringAsFixed(1)}$suffix';
  }
  
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Handle string dengan satuan (contoh: "32.1°C" -> 32.1)
      final numericString = value.replaceAll(RegExp(r'[^0-9\.]'), '');
      return double.tryParse(numericString) ?? 0.0;
    }
    return 0.0;
  }
}
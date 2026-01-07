import 'dart:async';
import 'dart:convert';
import 'package:dart_amqp/dart_amqp.dart';

class RabbitMQSingleton {
  static final RabbitMQSingleton _instance = RabbitMQSingleton._internal();
  factory RabbitMQSingleton() => _instance;
  RabbitMQSingleton._internal();
  
  Client? _client;
  
  // Stream controller untuk semua data
  final StreamController<Map<String, dynamic>> _dataController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;
  
  // Data untuk setiap sensor (PUBLIC - bisa diakses langsung)
  double soilHumidity = 0.0;       // dari soil_queue (kelembaban_tanah)
  double temperature = 0.0;        // dari sensor_dht11 (suhu_dht11)
  double airHumidity = 0.0;        // dari sensor_dht11 (kelembaban_dht11)
  double waterLevel = 0.0;         // dari jarak_apps (distance_cm)
  double waterQuality = 0.0;       // dari tds_apps (tds_ppm)
  double ph = 6.2;                 // Default statis (nanti dari sensor_ph)
  
  // Status untuk setiap sensor (PUBLIC - bisa diakses langsung)
  bool hasSoilData = false;
  bool hasTempData = false;
  bool hasAirHumidityData = false;
  bool hasWaterLevelData = false;
  bool hasWaterQualityData = false;
  bool hasPhData = false;          // masih false karena belum implement
  
  bool isConnected = false;
  
  // Queue names
  final Map<String, String> _queues = {
    'soil': 'soil_queue',
    'temp': 'sensor_dht11',
    'water_level': 'jarak_apps',
    'water_quality': 'tds_apps',
    // 'ph': 'sensor_ph',  // Untuk nanti ketika sensor_ph aktif
  };
  
  // Handler untuk setiap queue
  final Map<String, Function(Map<String, dynamic>)> _handlers = {};
  
  Future<void> connect() async {
    try {
      final settings = ConnectionSettings(
        host: '195.35.23.135',
        port: 5672,
        authProvider: PlainAuthenticator('mhs_kuliah', '12345678'),
        virtualHost: '/ai-automation',
      );
      
      _client = Client(settings: settings);
      
      // Setup handlers
      _setupHandlers();
      
      // Connect ke semua queue
      for (var entry in _queues.entries) {
        await _subscribeToQueue(entry.key, entry.value);
      }
      
      isConnected = true;
      print('✅ Connected to ${_queues.length} RabbitMQ queues');
      
    } catch (e) {
      isConnected = false;
      print('❌ Error connecting to RabbitMQ: $e');
    }
  }
  
  void _setupHandlers() {
    // Soil humidity handler
    _handlers['soil'] = (data) {
      final humidity = data['kelembaban_tanah'];
      if (humidity != null) {
        soilHumidity = _parseDouble(humidity);
        hasSoilData = true;
        print('🌱 Soil humidity updated: $soilHumidity%');
      }
    };
    
    // Temperature & Air humidity handler
    _handlers['temp'] = (data) {
      // Suhu
      final temp = data['suhu_dht11'];
      if (temp != null) {
        temperature = _parseDouble(temp);
        hasTempData = true;
        print('🌡️ Temperature updated: ${temperature}°C');
      }
      
      // Kelembapan udara
      final airHum = data['kelembaban_dht11'];
      if (airHum != null) {
        airHumidity = _parseDouble(airHum);
        hasAirHumidityData = true;
        print('💨 Air humidity updated: ${airHumidity}%');
      }
    };
    
    // Water level handler
    _handlers['water_level'] = (data) {
      final distance = data['distance_cm'];
      if (distance != null) {
        waterLevel = _parseDouble(distance);
        hasWaterLevelData = true;
        print('💧 Water level updated: $waterLevel cm');
      }
    };
    
    // Water quality handler
    _handlers['water_quality'] = (data) {
      final tds = data['tds_ppm'];
      if (tds != null) {
        waterQuality = _parseDouble(tds);
        hasWaterQualityData = true;
        print('🔬 Water quality updated: $waterQuality ppm');
      }
    };
    
    // pH handler (untuk nanti)
    _handlers['ph'] = (data) {
      final phValue = data['ph'] ?? data['value'];
      if (phValue != null) {
        ph = _parseDouble(phValue);
        hasPhData = true;
        print('🧪 pH updated: $ph');
      }
    };
  }
  
  Future<void> _subscribeToQueue(String sensorType, String queueName) async {
    try {
      final channel = await _client!.channel();
      final queue = await channel.queue(queueName, durable: true);
      final consumer = await queue.consume();
      
      print('📡 Subscribed to $sensorType queue: $queueName');
      
      consumer.listen((message) {
        try {
          final payload = utf8.decode(message.payload!);
          final data = json.decode(payload) as Map<String, dynamic>;
          
          print('📥 Received from $sensorType: $data');
          
          // Tambahkan sensor type ke data
          data['sensor_type'] = sensorType;
          
          // Handle data sesuai sensor type
          if (_handlers.containsKey(sensorType)) {
            _handlers[sensorType]!(data);
          }
          
          // Kirim ke stream
          _dataController.add(data);
          
          message.ack();
          
        } catch (e) {
          print('❌ Error processing message from $sensorType: $e');
        }
      }, onError: (error) {
        print('❌ Consumer error for $sensorType: $error');
      });
      
    } catch (e) {
      print('❌ Error subscribing to $sensorType: $e');
    }
  }
  
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }
  
  // Konversi distance_cm ke persentase
  double getWaterLevelPercentage() {
    const maxDistance = 30.0;
    
    if (waterLevel <= 0) return 100.0;
    if (waterLevel >= maxDistance) return 0.0;
    
    return ((maxDistance - waterLevel) / maxDistance * 100).clamp(0, 100);
  }
  
  // Indikator level air
  String getWaterLevelIndicator() {
    final percentage = getWaterLevelPercentage();
    
    if (percentage >= 70) return "Tinggi 🟢";
    if (percentage >= 30) return "Sedang 🟡";
    return "Rendah 🔴";
  }
  
  Future<void> disconnect() async {
    await _client?.close();
    isConnected = false;
    print('🔌 Disconnected from RabbitMQ');
  }
  
  // Get jumlah sensor yang aktif
  int get activeSensorCount {
    return [
      hasTempData,
      hasSoilData,
      hasAirHumidityData,
      hasWaterLevelData,
      hasWaterQualityData,
      hasPhData,
    ].where((hasData) => hasData).length;
  }
}
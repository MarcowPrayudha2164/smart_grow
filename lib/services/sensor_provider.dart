import 'dart:async';
import 'dart:convert';
import 'package:dart_amqp/dart_amqp.dart';

class RabbitMQSingleton {
  static final RabbitMQSingleton _instance = RabbitMQSingleton._internal();
  factory RabbitMQSingleton() => _instance;
  RabbitMQSingleton._internal();
  
  Client? _client;
  
  final StreamController<Map<String, dynamic>> _dataController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;
  
  // Data sensors - soilHumidity sebagai INT
  int soilHumidity = 0;            // ⬅️ UBAH KE INT untuk kelembaban tanah
  double temperature = 0.0;        // dari suhu_apps (tetap double untuk desimal)
  double waterLevel = 0.0;         // dari jarak_apps
  double waterQuality = 0.0;       // dari tds_apps
  double ph = 6.2;                 // Default statis
  
  // Status
  bool hasSoilData = false;
  bool hasTempData = false;
  bool hasWaterLevelData = false;
  bool hasWaterQualityData = false;
  bool hasPhData = false;
  
  bool isConnected = false;
  
  // QUEUE NAMES
  final Map<String, String> _queues = {
    'soil': 'soil_apps',
    'temp': 'suhu_apps',
    'water_level': 'jarak_apps',
    'water_quality': 'tds_apps',
  };
  
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
      
      _setupHandlers();
      
      print('🔄 Connecting to RabbitMQ...');
      
      for (var entry in _queues.entries) {
        await _subscribeToQueue(entry.key, entry.value);
      }
      
      isConnected = true;
      print('✅ Connected to ${_queues.length} queues');
      
    } catch (e) {
      isConnected = false;
      print('❌ Connection error: $e');
    }
  }
  
  void _setupHandlers() {
    // Handler untuk soil_apps - KELEMBABAN TANAH (INTEGER)
    _handlers['soil'] = (Map<String, dynamic> data) {
      print('🌱 Processing soil data from soil_apps');
      print('📊 Raw data: $data');
      
      final humidity = data['kelembaban_tanah'];
      print('🔍 kelembaban_tanah field: $humidity (type: ${humidity.runtimeType})');
      
      if (humidity != null) {
        // PARSE KE INTEGER, BUKAN DOUBLE
        final parsedHumidity = _parseInt(humidity);
        soilHumidity = parsedHumidity;
        hasSoilData = true;
        print('✅ Soil humidity updated to: $soilHumidity% (as integer)');
        
        _dataController.add({
          'type': 'soil',
          'value': soilHumidity,
          'value_int': soilHumidity, // Tambah field integer
          'raw_data': data,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      } else {
        print('❌ kelembaban_tanah is null or not found');
      }
    };
    
    // Handler untuk suhu_apps - SUHU (tetap double)
    _handlers['temp'] = (Map<String, dynamic> data) {
      final temp = data['temperature'];
      if (temp != null) {
        temperature = _parseDouble(temp);
        hasTempData = true;
        print('✅ Temperature updated: ${temperature.toStringAsFixed(1)}°C');
        
        _dataController.add({
          'type': 'temperature',
          'value': temperature,
          'raw_data': data,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    };
    
    // Handler untuk jarak_apps - LEVEL AIR
    _handlers['water_level'] = (Map<String, dynamic> data) {
      final distance = data['distance_cm'];
      if (distance != null) {
        waterLevel = _parseDouble(distance);
        hasWaterLevelData = true;
        print('✅ Water level updated: $waterLevel cm');
        
        _dataController.add({
          'type': 'water_level',
          'value': waterLevel,
          'raw_data': data,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    };
    
    // Handler untuk tds_apps - KUALITAS AIR
    _handlers['water_quality'] = (Map<String, dynamic> data) {
      final tds = data['tds_ppm'];
      if (tds != null) {
        waterQuality = _parseDouble(tds);
        hasWaterQualityData = true;
        print('✅ Water quality updated: ${waterQuality.toInt()} ppm');
        
        _dataController.add({
          'type': 'water_quality',
          'value': waterQuality,
          'raw_data': data,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    };
  }
  
  Future<void> _subscribeToQueue(String sensorType, String queueName) async {
    try {
      final channel = await _client!.channel();
      final queue = await channel.queue(queueName, durable: true);
      final consumer = await queue.consume();
      
      print('✅ Subscribed to: $queueName');
      
      consumer.listen((message) {
        try {
          final payload = utf8.decode(message.payload!);
          final data = json.decode(payload) as Map<String, dynamic>;
          
          print('\n📥 Message from $queueName ($sensorType):');
          
          // Tambahkan metadata
          data['queue_source'] = queueName;
          data['sensor_type'] = sensorType;
          
          // Eksekusi handler
          if (_handlers.containsKey(sensorType)) {
            _handlers[sensorType]!(data);
          }
          
          // Kirim ke stream
          _dataController.add(data);
          
          message.ack();
          
        } catch (e) {
          print('❌ Error: $e');
        }
      });
      
    } catch (e) {
      print('❌ Subscription error: $e');
    }
  }
  
  // PARSE KE INTEGER untuk kelembaban tanah
  int _parseInt(dynamic value) {
    print('🔢 Parsing to integer: $value (type: ${value.runtimeType})');
    
    if (value == null) {
      print('⚠️ Value is null, returning 0');
      return 0;
    }
    
    if (value is int) {
      print('✅ Already integer: $value');
      return value;
    }
    
    if (value is double) {
      print('🔄 Converting double to int: $value → ${value.toInt()}');
      return value.toInt();
    }
    
    if (value is String) {
      print('🔄 Parsing string to int: "$value"');
      // Bersihkan string, ambil angka bulat
      final cleaned = value.replaceAll(RegExp(r'[^0-9\-]'), '');
      final parsed = int.tryParse(cleaned);
      
      if (parsed != null) {
        print('✅ Successfully parsed to int: $parsed');
        return parsed;
      } else {
        print('❌ Failed to parse string to int');
        return 0;
      }
    }
    
    print('⚠️ Unknown type, returning 0');
    return 0;
  }
  
  // PARSE KE DOUBLE untuk sensor lain
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
  
  Future<void> disconnect() async {
    await _client?.close();
    isConnected = false;
    print('🔌 Disconnected');
  }
  
  int get activeSensorCount {
    return [
      hasTempData,
      hasSoilData,
      hasWaterLevelData,
      hasWaterQualityData,
    ].where((hasData) => hasData).length;
  }
}
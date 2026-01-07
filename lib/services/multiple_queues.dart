import 'dart:async';
import 'dart:convert';
import 'package:dart_amqp/dart_amqp.dart';

class RabbitMQService {
  late Client _client;
  
  final String _host = '195.35.23.135';
  final int _port = 5672;
  final String _username = 'mhs_kuliah';
  final String _password = '12345678';
  final String _vhost = '/ai-automation';
  
  // List semua queue yang akan di-subscribe
  final List<String> _queues = [
    'soil_queue',      // kelembaban tanah
    'sensor_dht11',      // suhu & kelembaban udara
    'sensor_ph',         // pH air
    'sensor_tingkat_air', // level air
    'sensor_kualitas',    // kualitas air (ppm)
  ];
  
  // Menyimpan channel untuk setiap queue
  final Map<String, Channel> _channels = {};
  final Map<String, Consumer> _consumers = {};
  
  // Stream controller untuk data sensor
  final StreamController<Map<String, dynamic>> _sensorStreamController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get sensorDataStream => _sensorStreamController.stream;
  
  Future<void> connect() async {
    try {
      final settings = ConnectionSettings(
        host: _host,
        port: _port,
        authProvider: PlainAuthenticator(_username, _password),
        virtualHost: _vhost,
      );
      
      _client = Client(settings: settings);
      
      print('✅ Connecting to RabbitMQ...');
      
      // Subscribe ke semua queues
      for (var queueName in _queues) {
        await _subscribeToQueue(queueName);
      }
      
      print('✅ Successfully connected to RabbitMQ');
      
    } catch (e) {
      print('❌ Error connecting to RabbitMQ: $e');
      rethrow;
    }
  }
  
  Future<void> _subscribeToQueue(String queueName) async {
    try {
      // Buat channel baru untuk setiap queue
      final channel = await _client.channel();
      _channels[queueName] = channel;
      
      // Declare queue
      final queue = await channel.queue(queueName, durable: true);
      
      // Setup consumer
      final consumer = await queue.consume();
      _consumers[queueName] = consumer;
      
      print('📡 Subscribed to queue: $queueName');
      
      consumer.listen((message) {
        try {
          final payload = utf8.decode(message.payload!);
          final data = json.decode(payload) as Map<String, dynamic>;
          print('📥 Received from $queueName: $data');
          data['queue_source'] = queueName;
          _sensorStreamController.add(data);
          message.ack();
          
        } catch (e) {
          print('❌ Error processing message from $queueName: $e');
        }
      }, onError: (error) {
        print('❌ Consumer error for $queueName: $error');
      });
      
    } catch (e) {
      print('❌ Error subscribing to $queueName: $e');
      // Coba reconnect setelah delay
      await Future.delayed(const Duration(seconds: 5));
      await _subscribeToQueue(queueName);
    }
  }
  
  Future<void> disconnect() async {
    try {
      // Close semua consumers
      for (var consumer in _consumers.values) {
        await consumer.cancel();
      }
      
      // Close semua channels
      for (var channel in _channels.values) {
        await channel.close();
      }
      
      // Close client
      await _client.close();
      
      // Close stream controller
      await _sensorStreamController.close();
      
      print('🔌 Disconnected from RabbitMQ');
      
    } catch (e) {
      print('Error disconnecting: $e');
    }
  }
  
  // Untuk publish data (jika diperlukan)
  Future<void> publishMessage(String queueName, Map<String, dynamic> data) async {
    try {
      final channel = _channels[queueName];
      if (channel != null) {
        final queue = await channel.queue(queueName);
        queue.publish(json.encode(data));
        print('📤 Message published to $queueName');
      }
    } catch (e) {
      print('❌ Error publishing to $queueName: $e');
    }
  }
  
  // Check jika queue tertentu sudah terhubung
  bool isQueueConnected(String queueName) {
    return _consumers.containsKey(queueName) && _consumers[queueName] != null;
  }
  
  // Get list queue yang terhubung
  List<String> get connectedQueues {
    return _queues.where((queue) => isQueueConnected(queue)).toList();
  }
}
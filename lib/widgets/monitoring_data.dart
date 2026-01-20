import 'package:flutter/material.dart';
import 'package:smart_grow/components/colors.dart';
import 'package:smart_grow/services/sensor_provider.dart';

class WidgetMonitoringData extends StatefulWidget {
  const WidgetMonitoringData({super.key});

  @override
  State<WidgetMonitoringData> createState() => _WidgetMonitoringDataState();
}

class _WidgetMonitoringDataState extends State<WidgetMonitoringData> {
  final RabbitMQSingleton _rabbitMQ = RabbitMQSingleton();

  // Data sensors
  double _temperature = 0.0;
  int _soilHumidity = 0;
  double _waterLevel = 0.0;
  double _waterLevelPercentage = 0.0;
  double _waterQuality = 0.0;
  double _ph = 6.2;

  // Status data
  bool _hasTempData = false;
  bool _hasSoilData = false;
  bool _hasWaterLevelData = false;
  bool _hasWaterQualityData = false;
  bool _hasPhData = false;

  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToRabbitMQ();
    _setupListener();
  }

  Future<void> _connectToRabbitMQ() async {
    await _rabbitMQ.connect();
    setState(() {
      _isConnected = _rabbitMQ.isConnected;
    });
  }

  void _setupListener() {
    _rabbitMQ.dataStream.listen((data) {
      if (mounted) {
        setState(() {
          _temperature = _rabbitMQ.temperature;
          _hasTempData = _rabbitMQ.hasTempData;

          _soilHumidity = _rabbitMQ.soilHumidity;
          _hasSoilData = _rabbitMQ.hasSoilData;

          _waterLevel = _rabbitMQ.waterLevel;
          _waterLevelPercentage = _rabbitMQ
              .getWaterLevelPercentage(); // Ambil persentase
          _hasWaterLevelData = _rabbitMQ.hasWaterLevelData;

          _waterQuality = _rabbitMQ.waterQuality;
          _hasWaterQualityData = _rabbitMQ.hasWaterQualityData;

          _ph = _rabbitMQ.ph;
          _hasPhData = _rabbitMQ.hasPhData;

          _isConnected = _rabbitMQ.isConnected;
        });
      }
    });
  }

  @override
  void dispose() {
    _rabbitMQ.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTemperatureCard(),
          const SizedBox(height: 10),
          _buildSoilHumidityCard(),
          const SizedBox(height: 10),
          _buildWaterLevelCard(),
          const SizedBox(height: 10),
          _buildWaterQualityCard(),
          const SizedBox(height: 10),

          // _buildPhCard(),
          const SizedBox(height: 20),
          _buildConnectionStatus(),
        ],
      ),
    );
  }

  Widget _buildTemperatureCard() {
    final value = _hasTempData ? "${_temperature.toStringAsFixed(1)}°C" : "0°C";
    final isActive = _hasTempData;

    return _buildSensorCard(
      label: "Suhu Ruangan",
      subLabel: "Sensor DHT",
      icon: Icons.thermostat_rounded,
      value: value,
      isActive: isActive,
      activeColor: Colors.grey,
      iconColor: Colors.redAccent,
    );
  }

  Widget _buildSoilHumidityCard() {
    final value = _hasSoilData ? "$_soilHumidity%" : "0%";
    final isActive = _hasSoilData;

    return _buildSensorCard(
      label: "Kelembapan",
      subLabel: "Sensor Soil",
      value: value,
      icon: Icons.grass_outlined,
      isActive: isActive,
      activeColor: Colors.brown,
      iconColor: Colors.lightGreen,
    );
  }

  Widget _buildWaterLevelCard() {
    String displayText;
    if (_hasWaterLevelData) {
      displayText = "${_waterLevelPercentage.toStringAsFixed(0)}%";
    } else {
      displayText = "0%";
    }

    final isActive = _hasWaterLevelData;

    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 60,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 100),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Level Air",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Sensor Jarak",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Icon(
              Icons.water_outlined,
              color: isActive ? const Color.fromARGB(255, 59, 159, 241) : Colors.grey,
              size: 35,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayText,
                  style: TextStyle(
                    fontSize: 30,
                    color: isActive ? primaryColor : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Menunggu data...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterQualityCard() {
    final value = _hasWaterQualityData
        ? "${_waterQuality.toStringAsFixed(0)} ppm"
        : "0 ppm";
    final isActive = _hasWaterQualityData;

    return _buildSensorCard(
      label: "Kualitas Air",
      subLabel: "Sensor TDS",
      icon: Icons.water_drop_rounded,
      value: value,
      isActive: isActive,
      activeColor: Colors.green,
      iconColor: Colors.teal,
    );
  }

  Widget _buildSensorCard({
    required String label,
    required String subLabel,
    required IconData icon,
    required String value,
    required bool isActive,
    required Color activeColor,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: textColor,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 60,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 100),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: textColor),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Icon(
              icon,
              color: isActive ? iconColor : Colors.grey,
              size: 35,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 25,
                      color: isActive ? primaryColor : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!isActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Menunggu data...',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    final activeSensors = [
      if (_hasTempData) 'Suhu',
      if (_hasSoilData) 'Tanah',
      if (_hasWaterLevelData) 'Level Air',
      if (_hasWaterQualityData) 'Kualitas Air',
      // if (_hasPhData) 'pH',
    ];

    final activeCount = activeSensors.length;
    final totalSensors = 4;

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: _isConnected ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _isConnected ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isConnected ? Icons.wifi : Icons.wifi_off,
                color: _isConnected ? Colors.green : Colors.orange,
                size: 30,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isConnected ? 'TERHUBUNG' : 'MENGHUBUNGKAN...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isConnected ? Colors.green : Colors.orange,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      'Sensor: $activeCount/$totalSensors aktif',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: LinearProgressIndicator(
              value: activeCount / totalSensors,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _isConnected ? Colors.green : Colors.orange,
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          if (activeSensors.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: activeSensors.map((sensor) {
                  return Chip(
                    label: Text(sensor),
                    backgroundColor: greenColor,
                    side: const BorderSide(color: Colors.green),
                    labelStyle: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    avatar: const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.blue,
                    ),
                  );
                }).toList(),
              ),
            ),
          if (!_isConnected)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton.icon(
                onPressed: () => _connectToRabbitMQ(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Koneksi Ulang'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

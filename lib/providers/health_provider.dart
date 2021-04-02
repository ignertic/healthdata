import 'package:flutter/material.dart';
import 'package:flutter_health/flutter_health.dart';
import 'dart:io' show Platform;

class HealthProvider extends ChangeNotifier{

  Map<String, Function> _iosHealthDataFuncs = {
    'bodyFat' : FlutterHealth.getHKBodyFat,
    'height' : FlutterHealth.getHKHeight,
    'bodyMass' : FlutterHealth.getHKBodyMass,
    'waistCircumference' : FlutterHealth.getHKWaistCircumference,
    'stepsCount' : FlutterHealth.getHKStepCount,
    'bloodPressure' : FlutterHealth.getHKBloodPressure,
    'basalEnergyBurned' : FlutterHealth.getHKBasalEnergyBurned,
    'activeEnergyBurned' : FlutterHealth.getHKActiveEnergyBurned,
    'heartRate' : FlutterHealth.getHKHeartRate,
    'restingHeartRate' : FlutterHealth.getHKRestingHeartRate,
    'walkingHeartRate' : FlutterHealth.getHKWalkingHeartRate,
    'bloodPressureSys' : FlutterHealth.getHKBloodPressureSys,
    'bodyTemperature' : FlutterHealth.getHKBodyTemperature,
    'weight' : FlutterHealth.getHKWeight,
    'bloodGlucose' : FlutterHealth.getHKBloodGlucose,

  };


  Map<String, Function> _androidHealthDataFuncs = {
    'bodyFatPercentage' : FlutterHealth.getGFBodyFat,
    'height' : FlutterHealth.getGFHeight,
    'stepsCount' : FlutterHealth.getGFStepCount,
    'energyBurned' : FlutterHealth.getGFEnergyBurned,
    'heartRate' : FlutterHealth.getGFHeartRate,
    'bloodPressure' : FlutterHealth.getGFBloodPressure,
    'bloodTemperature' : FlutterHealth.getGFBodyTemperature,
    'bloodOxygen' : FlutterHealth.getGFBloodOxygen,
    'bloodGlucose' : FlutterHealth.getGFBloodGlucose,
    'weight' : FlutterHealth.getGFWeight,

  };

  List<String> get androidHealthKeys => _androidHealthDataFuncs.keys.toList();
  List<String> get iosHealthKeys => _iosHealthDataFuncs.keys.toList();


  HealthProvider(){
    // ask for permissions
    _requestPermissions();
  }

  Future<Map> getAllHealthData()async{
    final data = {};
    if (Platform.isAndroid){
      androidHealthKeys.forEach((key)async{
        final _healthData = await this.fetch(key);
        data[key] = _healthData;

      });
    }else{
      iosHealthKeys.forEach((key)async{
        final _healthData = await this.fetch(key);
        data[key] = _healthData;
      });
    }

    return data;
  }

  Future fetch(String key,{startDate, endDate}) async{

    if (Platform.isAndroid){
      final data = await _androidHealthDataFuncs[key](startDate, endDate);
      return data;
    }else{
      final data = await _iosHealthDataFuncs[key](startDate, endDate);
      return data;
    }
  }

  void _requestPermissions(){
      if (Platform.isAndroid){
        _requestPermissionsAndroid();
      }else{
        // it's ios
        _checkIfHealthDataAvailable()
        ..then((result){
          if (result){
            // request permissions if data is available
            _requestPermissionsIOS();
          }else{
            debugPrint("Health Data is not available");
          }
        });
      }
  }

  Future<bool> _checkIfHealthDataAvailable()async{
    bool response = await FlutterHealth.checkIfHealthDataAvailable();
    return response;

  }

  Future<bool> _requestPermissionsAndroid() async{
    final response = await FlutterHealth.requestAuthorization();
    return response;
  }

  Future<bool> _requestPermissionsIOS()async{
    final response = await FlutterHealth.requestAuthorization();
    return response;
  }
}

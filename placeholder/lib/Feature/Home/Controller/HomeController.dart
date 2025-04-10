import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../Core/Service/DBService.dart';
import '../../../Core/Utility/LevelHelper.dart';
import '../../../Core/Service/TimeService.dart';
import '../../../Shared/Controller/UIController.dart';
import "package:geolocator/geolocator.dart";

class HomeController {
  final BuildContext context;
  final String username;
  UIController? ui;

  LatLng Location = LatLng(0, 0);

  final ValueNotifier<int> level = ValueNotifier(1);
  final ValueNotifier<int> streak = ValueNotifier(0);
  final ValueNotifier<double> xp = ValueNotifier(0);
  final ValueNotifier<double> hp = ValueNotifier(10);
  final ValueNotifier<bool> throbber = ValueNotifier(true);

  HomeController({required this.context, required this.username});

  void Controller(UIController controller) {
    ui = controller;
  }

  void init() async {
    await _GetUser();
    Location = await GetLocation();
    TimeService.StartUpdate(username, Update: _GetUser);
  }

  void dispose() => TimeService.CancelUpdate();

  Future<void> _GetUser() async {
    final user = await DBService.GetUser(username);
    final XP = user?.xp ?? 0;
    final rank = user?.rank ?? 1;

    int PrevLevel = level.value;
    int NextLevel = LevelHelper.GetLevel(XP, rank);

    level.value = NextLevel;
    xp.value = LevelHelper.Percentage(XP, rank);
    hp.value = (user?.hp ?? 10).toDouble();
    streak.value = user?.streak ?? 0;

    if (NextLevel > PrevLevel) {
      await DBService.UpdateTask(username, []);
      await ui?.GetTask();
    }

    throbber.value = false;
  }

  Future<void> Refresh() async {
    await _GetUser();
  }

  Future<LatLng> GetLocation() async {
    bool toggle = await Geolocator.isLocationServiceEnabled();
    if (!toggle) {
      return LatLng(0, 0);
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LatLng(0, 0);
      } else if (permission == LocationPermission.deniedForever) {
        return LatLng(0, 0);
      } else {
        Position location = await Geolocator.getCurrentPosition();
        return LatLng(location.latitude, location.longitude);
      }
    } else {
      Position location = await Geolocator.getCurrentPosition();
      return LatLng(location.latitude, location.longitude);
    }
  }
}

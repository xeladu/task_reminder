import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class SkipConfiguration extends Equatable {
  const SkipConfiguration({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  const SkipConfiguration.empty()
      : this(
            monday: false,
            tuesday: false,
            wednesday: false,
            thursday: false,
            friday: false,
            saturday: false,
            sunday: false);

  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;

  factory SkipConfiguration.fromJson(Map<String, dynamic> json) =>
      SkipConfiguration(
        monday: json.containsKey("monday") ? json["monday"] : false,
        tuesday: json.containsKey("tuesday") ? json["tuesday"] : false,
        wednesday: json.containsKey("wednesday") ? json["wednesday"] : false,
        thursday: json.containsKey("thursday") ? json["thursday"] : false,
        friday: json.containsKey("friday") ? json["friday"] : false,
        saturday: json.containsKey("saturday") ? json["saturday"] : false,
        sunday: json.containsKey("sunday") ? json["sunday"] : false,
      );

  Map<String, dynamic> toJson() => {
        "monday": monday,
        "tuesday": tuesday,
        "wednesday": wednesday,
        "thursday": thursday,
        "friday": friday,
        "saturday": saturday,
        "sunday": sunday,
      };

  @override
  List<Object?> get props =>
      [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
}

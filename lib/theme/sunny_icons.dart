import 'package:flutter/material.dart';
import 'package:sunny_dart/sunny_dart.dart';
import 'package:sunny_sdk_core/services.dart';

final globalIcons = GlobalIconResolver.instance;

final namedIcons = NamedIconContainer(() => GlobalIconResolver.instance).also(
  (icons) => globalIcons.registerIcon(
      NamedIcon("location", Icons.location_on, Icons.location_on)),
);

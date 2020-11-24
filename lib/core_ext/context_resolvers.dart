
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sunny_sdk_core/services/sunny.dart';

class ProviderBuildContextResolver implements BuildContextResolver {
  @override
  T resolve<T>(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  const ProviderBuildContextResolver();
}
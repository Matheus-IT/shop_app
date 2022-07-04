import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/shop_app.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;
  runApp(const ShopApp());
}

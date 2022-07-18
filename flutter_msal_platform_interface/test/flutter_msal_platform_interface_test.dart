import 'package:flutter_msal_platform_interface/flutter_msal_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$MsalPlatform', () {
    test('$MethodChannelMsal is the default instance', () {
      expect(MsalPlatform.instance, isA<MethodChannelMsal>());
    });
  });
}

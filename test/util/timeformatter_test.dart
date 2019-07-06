import 'package:flutter_test/flutter_test.dart';
import 'package:cube_challenge_timer/util/timeformatter.dart';

void main() {
  group('Time Formatter', () {
    test('Test time < 0', () {
      final time = -123;
      expect(formatTime(time), "DNF");
    });

    test('Test time = 0', () {
      final time = 0;
      expect(formatTime(time), "0.00");
    });

    test('Test 0 < time < 1s', () {
      final time = 123;
      expect(formatTime(time), "0.12");
    });

    test('Test  1s <= time < 10s ', () {
      final time = 9023;
      expect(formatTime(time), "9.02");

      final time2 = 1000;
      expect(formatTime(time2), "1.00");
    });

    test('Test  10s <= time < 60s', () {
      final time = 19023;
      expect(formatTime(time), "19.02");

      final time2 = 59320;
      expect(formatTime(time2), "59.32");
    });

    test('Test  1m <= time < 1h', () {
      final time = 60000;
      expect(formatTime(time), "1:00.00");

      final time2 = 123123;
      expect(formatTime(time2), "2:03.12");

      final time3 = 3599999;
      expect(formatTime(time3), "59:59.99");
    });

    test('Test  time >= 1h) ', () {
      final time = 34600000;
      expect(formatTime(time), "9:36:40.00");

      final time2 = 5 * 3600000;
      expect(formatTime(time2), "5:00:00.00");
    });
  });
}

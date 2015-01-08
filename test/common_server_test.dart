// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartpad_server.common_server_test;

import 'dart:async';
import 'dart:convert' show JSON;

import 'package:dartpad_server/src/common_server.dart';
import 'package:grinder/grinder.dart' as grinder;
import 'package:unittest/unittest.dart';

void defineTests() {
  CommonServer server;
  MockLogger logger = new MockLogger();
  MockCache cache = new MockCache();

  group('CommonServer', () {
    setUp(() {
      if (server == null) {
        String sdkPath = grinder.getSdkDir().path;
        server = new CommonServer(sdkPath, logger, cache);
      }
    });

    test('handleComplete', () {
      String json = JSON.encode({'source': 'void main() {print("foo");}', 'offset': 1});
      return server.handleComplete(json).then((ServerResponse response) {
        expect(response.statusCode, 501);
      });
    });

    test('handleComplete no data', () {
      return server.handleComplete('').then((ServerResponse response) {
        expect(response.statusCode, 400);
      });
    });

    test('handleComplete param missing', () {
      String json = JSON.encode({'offset': 1});
      return server.handleComplete(json).then((ServerResponse response) {
        expect(response.statusCode, 400);
      });
    });
  });
}

class MockLogger implements ServerLogger {
  StringBuffer builder = new StringBuffer();

  void info(String message) => builder.write('${message}\n');
  void clear() => builder.clear();
  String getLog() => builder.toString();
}

class MockCache implements ServerCache {
  Future<String> get(String key) => new Future.value(null);
  Future set(String key, String value, {Duration expiration}) =>
      new Future.value();
  Future remove(String key) => new Future.value();
}
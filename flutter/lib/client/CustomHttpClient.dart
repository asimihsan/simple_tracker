// ============================================================================
//  Copyright 2020 Asim Ihsan. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License in the LICENSE file and at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
// ============================================================================

import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:simple_tracker/exception/BackendClientSendFailedException.dart';
import 'package:simple_tracker/exception/InternalServerErrorException.dart';

class BackendClient {
  final int maxRetryCount = 3;

  final int retryTimeMaximumMillis = 1000;
  final int retryTimeBaseMillis = 100;

  final Duration connectionTimeout = Duration(seconds: 3);
  final Duration connectionClientTimeout = Duration(seconds: 5);
  final List<Duration> operationTimeoutSchedule = [
    Duration(seconds: 3),
    Duration(seconds: 5),
  ];
  final Duration idleTimeout = Duration(seconds: 120);
  final Map<String, String> defaultHeaders = {
    "Accept-Encoding": "gzip",
    "Accept": "application/protobuf",
    "Content-Type": "application/protobuf",
  };

  HttpClient? client;
  final String baseUrl;
  Random random;

  BackendClient(this.client, this.baseUrl, this.random);

  BackendClient.defaultClient(this.baseUrl): random = Random() {
    _initializeHttpClient();
  }

  // Retry using exponential backoff with full jitter.
  //
  // References
  // [1] https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter/
  Duration calculateRetryDuration(final int attempt) {
    final int maximumRetryMillis =
        min(retryTimeMaximumMillis, retryTimeBaseMillis * (2 << attempt));
    final int retryMillis = random.nextInt(maximumRetryMillis);
    return Duration(milliseconds: retryMillis);
  }

  void _initializeHttpClient() {
    if (client != null) {
      client!.close(force: true);
    }
    client = HttpClient();
    client!.connectionTimeout = connectionClientTimeout;
    client!.idleTimeout = idleTimeout;
  }

  Future<List<int>> send(final String endpoint, final List<int> payload) async {
    for (int i = 0; i < maxRetryCount; i++) {
      try {
        final Duration operationTimeout = i < operationTimeoutSchedule.length
            ? operationTimeoutSchedule[i]
            : operationTimeoutSchedule[operationTimeoutSchedule.length - 1];
        return await sendInternal(endpoint, payload, operationTimeout);
      } catch (e) {
        developer.log("URL: $endpoint. failed attempt $i.");
        if (i < maxRetryCount - 1) {
          if (e.runtimeType == InternalServerErrorException || e.runtimeType == TimeoutException) {
            _initializeHttpClient();
          }
          final Duration retryTime = calculateRetryDuration(i);
          developer.log("retry time: $retryTime");
          await Future.delayed(retryTime);
        } else {
          _initializeHttpClient();
        }
      }
    }
    throw BackendClientSendFailedException();
  }

  Future<List<int>> sendInternal(
      final String endpoint, final List<int> payload, final Duration operationTimeout) async {
    final Stopwatch stopwatch = new Stopwatch()..start();
    final String fullPath = baseUrl + endpoint;
    final HttpClientRequest request =
        await client!.postUrl(Uri.parse(fullPath)).timeout(connectionTimeout);
    defaultHeaders.forEach((key, value) {
      request.headers.add(key, value);
    });
    request.persistentConnection = true;
    request.add(payload);
    final HttpClientResponse response = await request.close().timeout(operationTimeout);
    if (response.headers.value("x-amzn-trace-id") != null) {
      developer.log("URL: " +
          endpoint +
          ", X-Ray trace ID: " +
          response.headers.value("x-amzn-trace-id")!.replaceAll("Root=", ""));
    }
    if (response.headers.value("x-amzn-requestid") != null) {
      developer
          .log("URL: " + endpoint + ", Request ID: " + response.headers.value("x-amzn-requestid")!);
    }
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      response.drain();
      throw new InternalServerErrorException();
    }
    final List<int> responseBytes = await response.single;
    developer.log("elapsed duration: ", error: stopwatch.elapsed);
    return responseBytes;
  }
}

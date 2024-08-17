import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StreamHandler {
  final _controller = StreamController<String>();

  Stream<String> currentSongStream() async* {
    final url = Uri.parse(
        "https://api.zeno.fm/mounts/metadata/subscribe/lcdmqnfduyqvv");
    final client = http.Client();

    try {
      final request = http.Request('GET', url);
      final response = await client.send(request);

      await for (var chunk in response.stream.transform(utf8.decoder)) {
        final lines = chunk.split('\n');
        for (var line in lines) {
          if (line.startsWith('data:')) {
            final jsonData = line.substring(5).trim();

            if (jsonData.isNotEmpty) {
              try {
                final Map<String, dynamic> resp = json.decode(jsonData);
                if (resp["streamTitle"] != null) {
                  yield resp["streamTitle"];
                }
              } catch (e) {
                yield* Stream.error("Error parsing JSON: $e");
              }
            }
          }
        }
      }
    } catch (e) {
      yield* Stream.error("Request error: $e");
    } finally {
      client.close();
    }
  }

  Stream<String> get stream => _controller.stream;

  // Método para detener el stream
  void stopStream() {
    _controller.close();
  }
}

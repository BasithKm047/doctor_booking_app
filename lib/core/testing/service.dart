import 'package:doctor_booking_app/core/service/app_logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Service {
  final WebSocketChannel channel;
  Service(String url): channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<dynamic> get stream => channel.stream;

  void send(String message){
    channel.sink.add(message);
    AppLogger.info('messege send');

  }

close(){
  channel.sink.close();
  AppLogger.info('channel Closed');
}
}
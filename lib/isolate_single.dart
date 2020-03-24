import 'dart:isolate';

main() async {

  // isolate的创建必须要有通过ReceivePort创建的SendPort
  final receivePort = new ReceivePort();

  // 创建Isolate
  await Isolate.spawn(_isolate, receivePort.sendPort);

  // 发送第一个message(即sendPort)
  var sendPort = await receivePort.first;

  // 发送信息
  var message = await sendReceive(sendPort, "Send1");
  print('received $message');
  message = await sendReceive(sendPort, "Send2");
  print('received $message');
}

// 入口函数
_isolate(SendPort sendPort) async {
  // 实例化一个ReceivePort以接收消息
  var port = new ReceivePort();

  // 将传入的sendPort发送给当前Isolate, 以便当前Isolate可以给他发送消息
  sendPort.send(port.sendPort);

  // 监听port并从中获取消息
  await for (var message in port) {
    var data = message[0];
    SendPort replyTo = message[1];
    replyTo.send('reply: ' + data);
//    print('reply' + data);
//    print('reply' + replyTo.toString());
    if (message[0] == "Send2") {
      port.close();
    }
  }
}

Future sendReceive(SendPort sendPort, message) {
  ReceivePort receivePort = new ReceivePort();
  // 将信息传递给宿主Isolate
  sendPort.send([message, receivePort.sendPort]);
  // 返回当前Stream,类似一个管道
  return receivePort.first;
}

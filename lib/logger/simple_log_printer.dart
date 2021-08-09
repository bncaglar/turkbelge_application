import 'package:logger/logger.dart';
import 'package:turkbelge_application/logger/stack_trace_formatter.dart';

Logger getLogger() {
  return Logger(
    printer: SimpleLogPrinter(),
  );
}

class SimpleLogPrinter extends LogPrinter {
  SimpleLogPrinter();

  @override
  List<String> log(LogEvent event) {
    try {
      var color = PrettyPrinter.levelColors[event.level];
      var emoji = PrettyPrinter.levelEmojis[event.level];

      String method =
          StackTraceFormatter.formatStackTrace(StackTrace.current, 2, 1)!;
      print(color!("$emoji | $method | ${event.message}"));
      return [];
    } catch (e) {
      return [];
    }
  }
}

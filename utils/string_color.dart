enum StringColor {
  red,
  green,
  yellow,
  blue,
  white,
  grey;
}

String coloredString(String string, {StringColor color = StringColor.white}) {
  switch (color) {
    case StringColor.red:
      return '\x1B[31m$string\x1B[0m';
    case StringColor.green:
      return '\x1B[32m$string\x1B[0m';
    case StringColor.yellow:
      return '\x1B[33m$string\x1B[0m';
    case StringColor.blue:
      return '\x1B[34m$string\x1B[0m';
    case StringColor.white:
      return '\x1B[37m$string\x1B[0m';
    case StringColor.grey:
      return '\x1B[30m$string\x1B[0m';
  }
}

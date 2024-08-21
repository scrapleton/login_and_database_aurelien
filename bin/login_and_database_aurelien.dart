import 'dart:io';
import '../utils/data.dart';
import '../utils/string_color.dart';

bool stopApp = false;
bool isUserLogged = false;
bool isUserAdmin = false;
String? userName;
String? userPassword;

void main(List<String> arguments) {
//Runtime loop
  while (!stopApp) {
    //Login loop
    while (!stopApp && !isUserLogged) {
      appInitialisation();
      appLoginProcess();

      //Data access loop
      while (!stopApp && isUserLogged) {
        appShowHeader();
        appDataAccess();
      }
    }
  }
}

appInitialisation() {
  clearTerminal();
  isUserLogged = false;
  isUserAdmin = false;
  userName = null;
  userPassword = null;
}

appLoginProcess() {
  stdout.write(coloredString('\nPlease login\n', color: StringColor.green));
  stdout.write(coloredString('\nEnter your name : ', color: StringColor.blue));
  userName = stdin.readLineSync();
  stdout.write(
      coloredString('\nEnter your password : ', color: StringColor.blue));
  stdin.echoMode = false;
  userPassword = stdin.readLineSync();
  stdin.echoMode = true;

  //UserName is mandatory
  if (userName != null && userName!.isNotEmpty) {
    //LOG AS ADMIN case
    if (userPassword == Data.adminPassword) {
      isUserAdmin = true;
      isUserLogged = true;
      //LOG AS GEST case
    } else if (userPassword == Data.guestPassword) {
      isUserLogged = true;
      //WRONG PASSWORD case
    } else {
      clearTerminal();
      stdout.write(coloredString('\nWrong password', color: StringColor.red));
      appTryAgainOrQuit();
    }
    //NO USERNAME case
  } else {
    clearTerminal();
    stdout.write(coloredString('\nYou did not enter any name ...',
        color: StringColor.red));
    appTryAgainOrQuit();
  }
}

appShowHeader() {
  clearTerminal();
  stdout.write(coloredString('YOU ARE LOGGED AS :', color: StringColor.green));
  stdout.write(coloredString('\n${isUserAdmin ? 'ADMIN' : 'GUEST'}',
      color: StringColor.white));
  stdout.write(coloredString(' $userName', color: StringColor.white));
}

appDataAccess() {
  stdout.write(coloredString(
      '\n\nType a user ID to access his data (ID are numbers) : ',
      color: StringColor.blue));
  String? index = stdin.readLineSync();

  //Index must be a INT
  if (index != null && int.tryParse(index) != null) {
    //Get user or empty map
    Map selectedUser = Data.userInfoDatabase
        .firstWhere((user) => user['id'] == int.parse(index), orElse: () => {});

    //Show user Data
    if (selectedUser.isNotEmpty) {
      appShowUserData(selectedUser);
      appTryAgainOrQuit();
      //No entry found
    } else {
      stdout
          .write(coloredString('\nNO ENTRY FOUND', color: StringColor.yellow));
      appTryAgainOrQuit();
    }
    //Invalid ID
  } else {
    stdout.write(coloredString('\nERROR ', color: StringColor.red));
    stdout.write(": Invalid ID");
    stdout.write(
        coloredString("\nID must be a number", color: StringColor.yellow));
    appTryAgainOrQuit();
  }
}

appTryAgainOrQuit() {
  stdout.write(coloredString("\n\nPress Enter to try again or 'q' to quit : ",
      color: StringColor.grey));
  String? input = stdin.readLineSync();

  if (input != null && input.toLowerCase() == 'q') {
    stopApp = true;
  }
}

appShowUserData(Map user) {
  stdout.write(coloredString("\n++===============================",
      color: StringColor.grey));

  stdout.write(coloredString("\n|| ", color: StringColor.grey));
  stdout.write("ID     ");
  stdout.write(coloredString("| ", color: StringColor.grey));
  stdout.write("${user['id']}");
  stdout.write(coloredString('\n++--------+----------------------',
      color: StringColor.grey));

  stdout.write(coloredString("\n|| ", color: StringColor.grey));
  stdout.write("NAME   ");
  stdout.write(coloredString("| ", color: StringColor.grey));
  stdout.write("${user['name']}");
  stdout.write(coloredString('\n++--------+----------------------',
      color: StringColor.grey));

  stdout.write(coloredString("\n|| ", color: StringColor.grey));
  stdout.write("AGE    ");
  stdout.write(coloredString("| ", color: StringColor.grey));
  stdout.write("${user['age']}");
  stdout.write(coloredString('\n++--------+----------------------',
      color: StringColor.grey));

  stdout.write(coloredString("\n|| ", color: StringColor.grey));
  stdout.write("EMAIL  ");
  stdout.write(coloredString("| ", color: StringColor.grey));
  stdout.write("${user['email']}");

  stdout.write(coloredString("\n++===============================",
      color: StringColor.grey));
}

clearTerminal() {
  stdout.write("\x1B[2J\x1B[0;0H");
}

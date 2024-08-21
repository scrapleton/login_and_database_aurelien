import 'dart:io';
import '../utils/data.dart';

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
  stdout.write("\x1B[2J\x1B[0;0H");
  isUserLogged = false;
  isUserAdmin = false;
  userName = null;
  userPassword = null;
}

appLoginProcess() {
  stdout.write("\nPlease login");
  stdout.write("\nEnter your name : ");
  userName = stdin.readLineSync();
  stdout.write("\nEnter your password : ");
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
      stdout.write("\x1B[2J\x1B[0;0H");
      stdout.write("\nWrong password");
      appTryAgainOrQuit();
    }
    //NO USERNAME case
  } else {
    stdout.write("\x1B[2J\x1B[0;0H");
    stdout.write("\nYou did not enter any name ...");
    appTryAgainOrQuit();
  }
}

appShowHeader() {
  stdout.write("\x1B[2J\x1B[0;0H");
  stdout.write("\nHello $userName");
  stdout.write("\nYou are logged as ${isUserAdmin ? 'ADMIN' : 'GUEST'} ");
}

appDataAccess() {
  stdout.write("\n\nType a user ID to access his data (ID are numbers) : ");
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
      stdout.write("\nNO ENTRY FOUND");
      appTryAgainOrQuit();
    }
    //Invalid ID
  } else {
    stdout.write("\nERROR : Invalid ID");
    stdout.write("\nID must be a number");
    appTryAgainOrQuit();
  }
}

appTryAgainOrQuit() {
  stdout.write("\n\nPress Enter to try again or 'q' to quit : ");
  String? input = stdin.readLineSync();

  if (input != null && input.toLowerCase() == 'q') {
    stopApp = true;
  }
}

appShowUserData(Map user) {
  stdout.write("\nID    : ${user['id']}");
  stdout.write("\nNAME  : ${user['name']}");
  stdout.write("\nAGE   : ${user['age']}");
  stdout.write("\nEMAIL : ${user['email']}");
}

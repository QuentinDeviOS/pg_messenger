// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "app_title" : MessageLookupByLibrary.simpleMessage("Purple Giraffe Messenger"),
    "login_alert_OK_button" : MessageLookupByLibrary.simpleMessage("OK"),
    "login_error_text" : MessageLookupByLibrary.simpleMessage("Username and/or password do not match."),
    "login_error_title" : MessageLookupByLibrary.simpleMessage("Are you sure about your credentials?"),
    "login_password" : MessageLookupByLibrary.simpleMessage("password"),
    "login_send_button" : MessageLookupByLibrary.simpleMessage("Log In"),
    "login_title" : MessageLookupByLibrary.simpleMessage("Login"),
    "login_username" : MessageLookupByLibrary.simpleMessage("username"),
    "message_just_now" : MessageLookupByLibrary.simpleMessage("Just now"),
    "message_logout" : MessageLookupByLibrary.simpleMessage("Log Out"),
    "message_send_button" : MessageLookupByLibrary.simpleMessage("Send message"),
    "message_title" : MessageLookupByLibrary.simpleMessage("Messages"),
    "register_alert_OK_button" : MessageLookupByLibrary.simpleMessage("OK"),
    "register_alert_title" : MessageLookupByLibrary.simpleMessage("Error"),
    "register_email" : MessageLookupByLibrary.simpleMessage("email"),
    "register_error_email" : MessageLookupByLibrary.simpleMessage("Must be a valid email address"),
    "register_error_password" : MessageLookupByLibrary.simpleMessage("Both password must match"),
    "register_password" : MessageLookupByLibrary.simpleMessage("password"),
    "register_password_verification" : MessageLookupByLibrary.simpleMessage("password verification"),
    "register_send_button" : MessageLookupByLibrary.simpleMessage("Register"),
    "register_title" : MessageLookupByLibrary.simpleMessage("Register"),
    "register_username" : MessageLookupByLibrary.simpleMessage("username")
  };
}

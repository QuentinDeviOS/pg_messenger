// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static m0(link) => "Impossible d\'ouvrir ${link}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "login_alert_OK_button" : MessageLookupByLibrary.simpleMessage("OK"),
    "login_error_text" : MessageLookupByLibrary.simpleMessage("Le mot de passe et l\'identifiant ne concordent pas"),
    "login_error_title" : MessageLookupByLibrary.simpleMessage("Impossible de se connecter"),
    "login_password" : MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "login_send_button" : MessageLookupByLibrary.simpleMessage("Entrer"),
    "login_title" : MessageLookupByLibrary.simpleMessage("Se connecter"),
    "login_username" : MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
    "message_just_now" : MessageLookupByLibrary.simpleMessage("À l\'instant"),
    "message_logout" : MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "message_send_button" : MessageLookupByLibrary.simpleMessage("Envoyer le message"),
    "message_title" : MessageLookupByLibrary.simpleMessage("Messages"),
    "register_EULA_launching_error" : m0,
    "register_EULA_message" : MessageLookupByLibrary.simpleMessage("En vous enregistrant, vous acceptez les conditions d\'utilisation de l\'application qui sont consultables ici : https://www.cedric06nice.com/app-tc-and-privacypolicy/"),
    "register_alert_OK_button" : MessageLookupByLibrary.simpleMessage("D\'accord"),
    "register_alert_title" : MessageLookupByLibrary.simpleMessage("Erreur"),
    "register_email" : MessageLookupByLibrary.simpleMessage("Adresse mail"),
    "register_error_email" : MessageLookupByLibrary.simpleMessage("Veuillez entrer une adresse mail valide"),
    "register_error_password" : MessageLookupByLibrary.simpleMessage("Les deux mots de passe doivent correspondre"),
    "register_password" : MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "register_password_verification" : MessageLookupByLibrary.simpleMessage("Vérification du mot de passe"),
    "register_send_button" : MessageLookupByLibrary.simpleMessage("S\'enregistrer"),
    "register_title" : MessageLookupByLibrary.simpleMessage("Créer un utilisateur"),
    "register_username" : MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur")
  };
}

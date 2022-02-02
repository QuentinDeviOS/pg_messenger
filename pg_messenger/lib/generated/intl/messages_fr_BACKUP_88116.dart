// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static String m0(link) => "Impossible d\'ouvrir ${link}";

  final messages = _notInlinedMessages(_notInlinedMessages);
<<<<<<< HEAD
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "channel": MessageLookupByLibrary.simpleMessage("Salons"),
        "channel_new_button":
            MessageLookupByLibrary.simpleMessage("     Création"),
        "channel_new_checkbox":
            MessageLookupByLibrary.simpleMessage("Accès public"),
        "channel_new_input_hint":
            MessageLookupByLibrary.simpleMessage("Nom du salon"),
        "channel_new_title":
            MessageLookupByLibrary.simpleMessage("Créer un nouveau salon"),
        "login_alert_OK_button": MessageLookupByLibrary.simpleMessage("OK"),
        "login_error_text": MessageLookupByLibrary.simpleMessage(
            "Le mot de passe et l\'identifiant ne concordent pas"),
        "login_error_title":
            MessageLookupByLibrary.simpleMessage("Impossible de se connecter"),
        "login_password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "login_send_button": MessageLookupByLibrary.simpleMessage("Entrer"),
        "login_title": MessageLookupByLibrary.simpleMessage("Se connecter"),
        "login_username":
            MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
        "logout_title": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
        "message_delete":
            MessageLookupByLibrary.simpleMessage(" effacer le message"),
        "message_just_now":
            MessageLookupByLibrary.simpleMessage("À l\'instant"),
        "message_logout":
            MessageLookupByLibrary.simpleMessage("Se déconnecter"),
        "message_report":
            MessageLookupByLibrary.simpleMessage(" reporter le message"),
        "message_send_button":
            MessageLookupByLibrary.simpleMessage("Envoyer le message"),
        "message_title": MessageLookupByLibrary.simpleMessage("Messages"),
        "message_under_moderation": MessageLookupByLibrary.simpleMessage(
            "Message en cours de modération"),
        "picture_import_gallery": MessageLookupByLibrary.simpleMessage(
            "Importer depuis la photothèque"),
        "picture_new":
            MessageLookupByLibrary.simpleMessage("Prendre une nouvelle photo"),
        "register_EULA_launching_error": m0,
        "register_EULA_message":
            MessageLookupByLibrary.simpleMessage("J\'accepte les "),
        "register_EULA_message_link": MessageLookupByLibrary.simpleMessage(
            "conditions d\'utilisation de l\'application."),
        "register_alert_OK_button":
            MessageLookupByLibrary.simpleMessage("D\'accord"),
        "register_alert_title": MessageLookupByLibrary.simpleMessage("Erreur"),
        "register_email": MessageLookupByLibrary.simpleMessage("Adresse mail"),
        "register_error_accept_tc":
            MessageLookupByLibrary.simpleMessage("Vous devez accepter les T&C"),
        "register_error_email": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer une adresse mail valide"),
        "register_error_password": MessageLookupByLibrary.simpleMessage(
            "Les deux mots de passe doivent correspondre"),
        "register_password":
            MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "register_password_verification": MessageLookupByLibrary.simpleMessage(
            "Vérification du mot de passe"),
        "register_send_button":
            MessageLookupByLibrary.simpleMessage("S\'enregistrer"),
        "register_title":
            MessageLookupByLibrary.simpleMessage("Créer un utilisateur"),
        "register_username":
            MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
        "settings_actual_password":
            MessageLookupByLibrary.simpleMessage("Mot de passe actuel"),
        "settings_change_password_button":
            MessageLookupByLibrary.simpleMessage("Changer le mot de passe"),
        "settings_change_password_title":
            MessageLookupByLibrary.simpleMessage("Changer mon mot de passe"),
        "settings_change_picture":
            MessageLookupByLibrary.simpleMessage("Changer ma photo de profil"),
        "settings_default_message_error_new_password":
            MessageLookupByLibrary.simpleMessage(
                "Une erreur est survenue, code erreur : "),
        "settings_new_password":
            MessageLookupByLibrary.simpleMessage("Nouveau mot de passe"),
        "settings_title": MessageLookupByLibrary.simpleMessage("Préférences"),
        "settings_wrong_actual_password": MessageLookupByLibrary.simpleMessage(
            "Veuillez vérifier votre mot de passe actuel")
      };
=======
  static _notInlinedMessages(_) => <String, Function> {
    "channel" : MessageLookupByLibrary.simpleMessage("Salons"),
    "channel_new_button" : MessageLookupByLibrary.simpleMessage("     Création"),
    "channel_new_checkbox" : MessageLookupByLibrary.simpleMessage("Accès public"),
    "channel_new_input_hint" : MessageLookupByLibrary.simpleMessage("Nom du salon"),
    "channel_new_title" : MessageLookupByLibrary.simpleMessage("Créer un nouveau salon"),
    "login_alert_OK_button" : MessageLookupByLibrary.simpleMessage("OK"),
    "login_error_text" : MessageLookupByLibrary.simpleMessage("Le mot de passe et l\'identifiant ne concordent pas"),
    "login_error_title" : MessageLookupByLibrary.simpleMessage("Impossible de se connecter"),
    "login_password" : MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "login_send_button" : MessageLookupByLibrary.simpleMessage("Entrer"),
    "login_title" : MessageLookupByLibrary.simpleMessage("Se connecter"),
    "login_username" : MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
    "logout_title" : MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "message_delete" : MessageLookupByLibrary.simpleMessage("Effacer le message"),
    "message_just_now" : MessageLookupByLibrary.simpleMessage("À l\'instant"),
    "message_logout" : MessageLookupByLibrary.simpleMessage("Se déconnecter"),
    "message_report" : MessageLookupByLibrary.simpleMessage("Reporter le message"),
    "message_send_button" : MessageLookupByLibrary.simpleMessage("Envoyer le message"),
    "message_title" : MessageLookupByLibrary.simpleMessage("Messages"),
    "message_under_moderation" : MessageLookupByLibrary.simpleMessage("Message en cours de modération"),
    "message_unflag" : MessageLookupByLibrary.simpleMessage("Unflag le message"),
    "picture_import_gallery" : MessageLookupByLibrary.simpleMessage("Importer depuis la photothèque"),
    "picture_new" : MessageLookupByLibrary.simpleMessage("Prendre une nouvelle photo"),
    "register_EULA_launching_error" : m0,
    "register_EULA_message" : MessageLookupByLibrary.simpleMessage("J\'accepte les "),
    "register_EULA_message_link" : MessageLookupByLibrary.simpleMessage("conditions d\'utilisation de l\'application."),
    "register_alert_OK_button" : MessageLookupByLibrary.simpleMessage("D\'accord"),
    "register_alert_title" : MessageLookupByLibrary.simpleMessage("Erreur"),
    "register_email" : MessageLookupByLibrary.simpleMessage("Adresse mail"),
    "register_error_accept_tc" : MessageLookupByLibrary.simpleMessage("Vous devez accepter les T&C"),
    "register_error_email" : MessageLookupByLibrary.simpleMessage("Veuillez entrer une adresse mail valide"),
    "register_error_password" : MessageLookupByLibrary.simpleMessage("Les deux mots de passe doivent correspondre"),
    "register_password" : MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "register_password_verification" : MessageLookupByLibrary.simpleMessage("Vérification du mot de passe"),
    "register_send_button" : MessageLookupByLibrary.simpleMessage("S\'enregistrer"),
    "register_title" : MessageLookupByLibrary.simpleMessage("Créer un utilisateur"),
    "register_username" : MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
    "settings_actual_password" : MessageLookupByLibrary.simpleMessage("Mot de passe actuel"),
    "settings_change_password_button" : MessageLookupByLibrary.simpleMessage("Changer le mot de passe"),
    "settings_change_password_title" : MessageLookupByLibrary.simpleMessage("Changer mon mot de passe"),
    "settings_change_picture" : MessageLookupByLibrary.simpleMessage("Changer ma photo de profil"),
    "settings_default_message_error_new_password" : MessageLookupByLibrary.simpleMessage("Une erreur est survenue, code erreur : "),
    "settings_new_password" : MessageLookupByLibrary.simpleMessage("Nouveau mot de passe"),
    "settings_title" : MessageLookupByLibrary.simpleMessage("Préférences"),
    "settings_wrong_actual_password" : MessageLookupByLibrary.simpleMessage("Veuillez vérifier votre mot de passe actuel")
  };
>>>>>>> 90f1ed21b3494f8ae8424f767d7f02976d9902e4
}

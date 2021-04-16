// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
 
      return instance;
    });
  } 

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Register`
  String get register_title {
    return Intl.message(
      'Register',
      name: 'register_title',
      desc: '',
      args: [],
    );
  }

  /// `username`
  String get register_username {
    return Intl.message(
      'username',
      name: 'register_username',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get register_email {
    return Intl.message(
      'email',
      name: 'register_email',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get register_password {
    return Intl.message(
      'password',
      name: 'register_password',
      desc: '',
      args: [],
    );
  }

  /// `password verification`
  String get register_password_verification {
    return Intl.message(
      'password verification',
      name: 'register_password_verification',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register_send_button {
    return Intl.message(
      'Register',
      name: 'register_send_button',
      desc: '',
      args: [],
    );
  }

  /// `Both password must match`
  String get register_error_password {
    return Intl.message(
      'Both password must match',
      name: 'register_error_password',
      desc: '',
      args: [],
    );
  }

  /// `Must be a valid email address`
  String get register_error_email {
    return Intl.message(
      'Must be a valid email address',
      name: 'register_error_email',
      desc: '',
      args: [],
    );
  }

  /// `You must accept the T&C`
  String get register_error_accept_tc {
    return Intl.message(
      'You must accept the T&C',
      name: 'register_error_accept_tc',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get register_alert_OK_button {
    return Intl.message(
      'OK',
      name: 'register_alert_OK_button',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get register_alert_title {
    return Intl.message(
      'Error',
      name: 'register_alert_title',
      desc: '',
      args: [],
    );
  }

  /// `I agree with the `
  String get register_EULA_message {
    return Intl.message(
      'I agree with the ',
      name: 'register_EULA_message',
      desc: '',
      args: [],
    );
  }

  /// `End of User Agreement, Privacy Policy and Terms & Conditions`
  String get register_EULA_message_link {
    return Intl.message(
      'End of User Agreement, Privacy Policy and Terms & Conditions',
      name: 'register_EULA_message_link',
      desc: '',
      args: [],
    );
  }

  /// `Could not launch {link}`
  String register_EULA_launching_error(Object link) {
    return Intl.message(
      'Could not launch $link',
      name: 'register_EULA_launching_error',
      desc: '',
      args: [link],
    );
  }

  /// `Login`
  String get login_title {
    return Intl.message(
      'Login',
      name: 'login_title',
      desc: '',
      args: [],
    );
  }

  /// `username`
  String get login_username {
    return Intl.message(
      'username',
      name: 'login_username',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get login_password {
    return Intl.message(
      'password',
      name: 'login_password',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get login_send_button {
    return Intl.message(
      'Log In',
      name: 'login_send_button',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure about your credentials?`
  String get login_error_title {
    return Intl.message(
      'Are you sure about your credentials?',
      name: 'login_error_title',
      desc: '',
      args: [],
    );
  }

  /// `Username and/or password do not match.`
  String get login_error_text {
    return Intl.message(
      'Username and/or password do not match.',
      name: 'login_error_text',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get login_alert_OK_button {
    return Intl.message(
      'OK',
      name: 'login_alert_OK_button',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get message_title {
    return Intl.message(
      'Messages',
      name: 'message_title',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get message_logout {
    return Intl.message(
      'Log Out',
      name: 'message_logout',
      desc: '',
      args: [],
    );
  }

  /// `Send message`
  String get message_send_button {
    return Intl.message(
      'Send message',
      name: 'message_send_button',
      desc: '',
      args: [],
    );
  }

  /// `Just now`
  String get message_just_now {
    return Intl.message(
      'Just now',
      name: 'message_just_now',
      desc: '',
      args: [],
    );
  }

  /// ` report abuse`
  String get message_report {
    return Intl.message(
      ' report abuse',
      name: 'message_report',
      desc: '',
      args: [],
    );
  }

  /// ` delete message`
  String get message_delete {
    return Intl.message(
      ' delete message',
      name: 'message_delete',
      desc: '',
      args: [],
    );
  }

  /// `Message under moderation`
  String get message_under_moderation {
    return Intl.message(
      'Message under moderation',
      name: 'message_under_moderation',
      desc: '',
      args: [],
    );
  }

  /// `Create new channel`
  String get channel_new_title {
    return Intl.message(
      'Create new channel',
      name: 'channel_new_title',
      desc: '',
      args: [],
    );
  }

  /// `Channel name`
  String get channel_new_input_hint {
    return Intl.message(
      'Channel name',
      name: 'channel_new_input_hint',
      desc: '',
      args: [],
    );
  }

  /// `Public access`
  String get channel_new_checkbox {
    return Intl.message(
      'Public access',
      name: 'channel_new_checkbox',
      desc: '',
      args: [],
    );
  }

  /// `     Create`
  String get channel_new_button {
    return Intl.message(
      '     Create',
      name: 'channel_new_button',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
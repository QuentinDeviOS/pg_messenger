class Constant {
  //LOCAL
  // static const URL_BASE = "192.168.1.25:8080";
  // static const URL_WEB_SERVER_BASE = "http://" + URL_BASE;
  // static const URL_WEB_SOCKET = "ws://192.168.1.25:8080/messages/message-web-socket";

  // LIVE
  static const URL_BASE = "skyisthelimit.net";
  static const URL_WEB_SERVER_BASE = "https://" + URL_BASE;
  static const URL_WEB_SOCKET =
      "wss://skyisthelimit.net/messages/message-web-socket";

  static const PATH_TO_GET_PICTURE = "/photos/get-picture";

  static const URL_TC = "https://www.cedric06nice.com/pg-messenger-app/";

  static const JSONKEY_TOKEN = "token";

  static const JSONKEY_USER = "user";
  static const JSONKEY_USER_ID = "id";
  static const JSONKEY_USER_USERNAME = "name";
  static const JSONKEY_USER_EMAIL = "email";
  static const JSONKEY_USER_PASSWORD = "password";
  static const JSONKEY_USER_PASSWORD_HASH = "passwordHash";
  static const JSONKEY_USER_IS_MODERATOR = "isModerator";
  static const JSONKEY_USER_IS_ACTIVE = "isActive";
  static const JSONKEY_USER_PICTURE = "picture";
  static const JSONKEY_USER_DATE_CREATION = "createdAt";
  static const JSONKEY_USER_RESPONSE_ERROR = "error";
  static const JSONKEY_USER_RESPONSE_ERROR_REASON = "reason";

  static const JSONKEY_MESSAGE_ID = "id";
  static const JSONKEY_MESSAGE_MESSAGE = "message";
  static const JSONKEY_MESSAGE_TIMESTAMP = "timestamp";
  static const JSONKEY_MESSAGE_FLAG = "flag";
  static const JSONKEY_MESSAGE_OWNER = "ownerId";
  static const JSONKEY_MESSAGE_OWNER_ID = "id";
  static const JSONKEY_MESSAGE_IS_PICTURE = "isPicture";
  static const JSONKEY_MESSAGE_CHANNEL = "channel";

  static const JSONKEY_MESSAGE_USERNAME = "username";
  static const JSONKEY_MESSAGE_PASSWORD = "password";
  static const JSONKEY_MESSAGE_USERID = "userID";

  static const JSONKEY_CHANNEL_NAME = "name";
  static const JSONKEY_CHANNEL_IS_PUBLIC = "isPublic";
  static const JSONKEY_CHANNEL_CHANNEL_USERS_ID = "channelUsersID";
}

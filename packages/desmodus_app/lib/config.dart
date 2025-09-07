class Config {
  static String get ambiente =>
      const String.fromEnvironment("AMBIENTE", defaultValue: "UNAUTHORIZED");

  static String get apiUrl => const String.fromEnvironment("API_URL");

  static String get discordOauthUrl =>
      const String.fromEnvironment("DISCORD_OAUTH_URL");

  static String get googleWebClientId =>
      const String.fromEnvironment("GOOGLE_WEB_CLIENT_ID");

  static String get googleAndroidClientId =>
      const String.fromEnvironment("GOOGLE_ANDROID_CLIENT_ID");

  static String get jawgAccessToken =>
      const String.fromEnvironment("JAWG_MAPS_ACCESS_TOKEN");
}

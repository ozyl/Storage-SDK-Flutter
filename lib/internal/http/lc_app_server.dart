part of leancloud_storage;

class LCAppServer {
  String apiServer;

  String pushServer;

  String engineServer;

  DateTime expiredAt;

  bool get isExpired => expiredAt.compareTo(DateTime.now()) < 0;

  LCAppServer.fromJson(Map<String, dynamic> json) :
    apiServer = _getSchemeUrl(json['api_server']),
    pushServer = _getSchemeUrl(json['push_server']),
    engineServer = _getSchemeUrl(json['engine_server']) {
      int ttl = json['ttl'];
      Duration validDuration = new Duration(seconds: ttl);
      DateTime fetchedAt = DateTime.now();
      expiredAt = fetchedAt.add(validDuration);
  }

  static String _getSchemeUrl(String url) {
    return url.startsWith('https://') ? url : 'https://$url';
  }

  static LCAppServer _getInternalFallbackServer(String appId) {
    String prefix = appId.substring(0, 8).toLowerCase();
    return new LCAppServer.fromJson({
      'api_server': 'https://$prefix.api.lncldglobal.com',
      'engine_server': 'https://$prefix.engine.lncldglobal.com',
      'push_server': 'https://$prefix.push.lncldglobal.com',
      'ttl': -1,
    });
  }
}
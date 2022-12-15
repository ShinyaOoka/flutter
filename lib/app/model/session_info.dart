class SessionInfo {
  SessionInfo({
    this.uid,
    this.isSystem,
    this.isAdmin,
    this.userContext,
    this.db,
    this.serverVersion,
    this.serverVersionInfo,
    this.supportUrl,
    this.name,
    this.username,
    this.partnerDisplayName,
    this.companyId,
    this.partnerId,
    this.webbaseurl,
    this.activeIdsLimit,
    this.profileSession,
    this.profileCollectors,
    this.profileParams,
    this.maxFileUploadSize,
    this.homeActionId,
    this.cacheHashes,
    this.currencies,
    this.userCompanies,
    this.showEffect,
    this.displaySwitchCompanyMenu,
    this.userId,
    this.maxTimeBetweenKeysInMs,
    this.tourDisable,
    this.notificationType,
    this.odoobotInitialized,
    this.iapCompanyEnrich,
  });

  SessionInfo.fromJson(dynamic json) {
    uid = json['uid'];
    isSystem = json['is_system'];
    isAdmin = json['is_admin'];
    userContext = json['user_context'] != null
        ? UserContext.fromJson(json['user_context'])
        : null;
    db = json['db'];
    serverVersion = json['server_version'];
    serverVersionInfo = json['server_version_info'] != null
        ? json['server_version_info'].cast<dynamic>()
        : [];
    supportUrl = json['support_url'];
    name = json['name'];
    username = json['username'];
    partnerDisplayName = json['partner_display_name'];
    companyId = json['company_id'];
    partnerId = json['partner_id'];
    webbaseurl = json['web.base.url'];
    activeIdsLimit = json['active_ids_limit'];
    profileSession = json['profile_session'];
    profileCollectors = json['profile_collectors'];
    profileParams = json['profile_params'];
    maxFileUploadSize = json['max_file_upload_size'];
    homeActionId = json['home_action_id'];
    cacheHashes = json['cache_hashes'] != null
        ? CacheHashes.fromJson(json['cache_hashes'])
        : null;
    currencies = json['currencies'] != null
        ? Currencies.fromJson(json['currencies'])
        : null;
    userCompanies = json['user_companies'] != null
        ? UserCompanies.fromJson(json['user_companies'])
        : null;
    showEffect = json['show_effect'];
    displaySwitchCompanyMenu = json['display_switch_company_menu'];
    userId = json['user_id'] != null ? json['user_id'].cast<dynamic>() : [];
    maxTimeBetweenKeysInMs = json['max_time_between_keys_in_ms'];
    tourDisable = json['tour_disable'];
    notificationType = json['notification_type'];
    odoobotInitialized = json['odoobot_initialized'];
    iapCompanyEnrich = json['iap_company_enrich'];
  }

  dynamic? uid;
  bool? isSystem;
  bool? isAdmin;
  UserContext? userContext;
  String? db;
  String? serverVersion;
  List<dynamic>? serverVersionInfo;
  String? supportUrl;
  dynamic name;
  dynamic username;
  dynamic partnerDisplayName;
  dynamic companyId;
  dynamic partnerId;
  String? webbaseurl;
  int? activeIdsLimit;
  dynamic profileSession;
  dynamic profileCollectors;
  dynamic profileParams;
  int? maxFileUploadSize;
  bool? homeActionId;
  CacheHashes? cacheHashes;
  Currencies? currencies;
  UserCompanies? userCompanies;
  dynamic showEffect;
  bool? displaySwitchCompanyMenu;
  List<dynamic>? userId;
  int? maxTimeBetweenKeysInMs;
  bool? tourDisable;
  String? notificationType;
  bool? odoobotInitialized;
  bool? iapCompanyEnrich;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['is_system'] = isSystem;
    map['is_admin'] = isAdmin;
    if (userContext != null) {
      map['user_context'] = userContext?.toJson();
    }
    map['db'] = db;
    map['server_version'] = serverVersion;
    map['server_version_info'] = serverVersionInfo;
    map['support_url'] = supportUrl;
    map['name'] = name;
    map['username'] = username;
    map['partner_display_name'] = partnerDisplayName;
    map['company_id'] = companyId;
    map['partner_id'] = partnerId;
    map['web.base.url'] = webbaseurl;
    map['active_ids_limit'] = activeIdsLimit;
    map['profile_session'] = profileSession;
    map['profile_collectors'] = profileCollectors;
    map['profile_params'] = profileParams;
    map['max_file_upload_size'] = maxFileUploadSize;
    map['home_action_id'] = homeActionId;
    if (cacheHashes != null) {
      map['cache_hashes'] = cacheHashes?.toJson();
    }
    if (currencies != null) {
      map['currencies'] = currencies?.toJson();
    }
    if (userCompanies != null) {
      map['user_companies'] = userCompanies?.toJson();
    }
    map['show_effect'] = showEffect;
    map['display_switch_company_menu'] = displaySwitchCompanyMenu;
    map['user_id'] = userId;
    map['max_time_between_keys_in_ms'] = maxTimeBetweenKeysInMs;
    map['tour_disable'] = tourDisable;
    map['notification_type'] = notificationType;
    map['odoobot_initialized'] = odoobotInitialized;
    map['iap_company_enrich'] = iapCompanyEnrich;
    return map;
  }
}

class UserCompanies {
  UserCompanies({
    this.currentCompany,
      this.allowedCompanies,});

  UserCompanies.fromJson(dynamic json) {
    currentCompany = json['current_company'];
    allowedCompanies = json['allowed_companies'] != null ? AllowedCompanies.fromJson(json['allowed_companies']) : null;
  }
  int? currentCompany;
  AllowedCompanies? allowedCompanies;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current_company'] = currentCompany;
    if (allowedCompanies != null) {
      map['allowed_companies'] = allowedCompanies?.toJson();
    }
    return map;
  }

}


class AllowedCompanies {
  AllowedCompanies({
      this.a1,});

  AllowedCompanies.fromJson(dynamic json) {
    a1 = json['1'] != null ? A1.fromJson(json['1']) : null;
  }
  A1? a1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (a1 != null) {
      map['1'] = a1?.toJson();
    }
    return map;
  }

}


class A1 {
  A1({
    this.id,
    this.name,
      this.sequence,});

  A1.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    sequence = json['sequence'];
  }
  int? id;
  String? name;
  int? sequence;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['sequence'] = sequence;
    return map;
  }
}

class Currencies {
  Currencies({
    this.c1,
    this.c2,
  });

  Currencies.fromJson(dynamic json) {
    c1 = json['1'] != null ? C1.fromJson(json['1']) : null;
    c2 = json['2'] != null ? C2.fromJson(json['2']) : null;
  }

  C1? c1;
  C2? c2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (c1 != null) {
      map['1'] = c1?.toJson();
    }
    if (c2 != null) {
      map['2'] = c2?.toJson();
    }
    return map;
  }
}

class C2 {
  C2({
    this.symbol,
    this.position,
    this.digits,
  });

  C2.fromJson(dynamic json) {
    symbol = json['symbol'];
    position = json['position'];
    digits = json['digits'] != null ? json['digits'].cast<int>() : [];
  }

  String? symbol;
  String? position;
  List<int>? digits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['symbol'] = symbol;
    map['position'] = position;
    map['digits'] = digits;
    return map;
  }
}

class C1 {
  C1({
    this.symbol,
    this.position,
    this.digits,
  });

  C1.fromJson(dynamic json) {
    symbol = json['symbol'];
    position = json['position'];
    digits = json['digits'] != null ? json['digits'].cast<int>() : [];
  }

  String? symbol;
  String? position;
  List<int>? digits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['symbol'] = symbol;
    map['position'] = position;
    map['digits'] = digits;
    return map;
  }
}

class CacheHashes {
  CacheHashes({
    this.translations,
    this.loadMenus,
    this.qweb,
    this.assetsDiscussPublic,
  });

  CacheHashes.fromJson(dynamic json) {
    translations = json['translations'];
    loadMenus = json['load_menus'];
    qweb = json['qweb'];
    assetsDiscussPublic = json['assets_discuss_public'];
  }

  String? translations;
  String? loadMenus;
  String? qweb;
  String? assetsDiscussPublic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['translations'] = translations;
    map['load_menus'] = loadMenus;
    map['qweb'] = qweb;
    map['assets_discuss_public'] = assetsDiscussPublic;
    return map;
  }
}

class UserContext {
  UserContext({
    this.lang,
    this.tz,
    this.uid,
    this.allowedCompanyIds,
  });

  UserContext.fromJson(dynamic json) {
    lang = json['lang'];
    tz = json['tz'];
    uid = json['uid'];
    allowedCompanyIds = json['allowed_company_ids'] != null
        ? json['allowed_company_ids'].cast<int>()
        : [];
  }

  String? lang;
  String? tz;
  int? uid;
  List<int>? allowedCompanyIds;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lang'] = lang;
    map['tz'] = tz;
    map['uid'] = uid;
    map['allowed_company_ids'] = allowedCompanyIds;
    return map;
  }
}

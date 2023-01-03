enum Flavor {
  DEVELOPMENT,
  PRODUCTION,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return 'レポート作成(dev)';
      case Flavor.PRODUCTION:
        return 'レポート作成';
      default:
        return 'レポート作成';
    }
  }

}

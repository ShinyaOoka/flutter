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
        return 'AK AZM(dev)';
      case Flavor.PRODUCTION:
        return 'AK AZM';
      default:
        return 'title';
    }
  }

}

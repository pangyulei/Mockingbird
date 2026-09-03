class AboutState {
  final String version;
  final String appName;

  const AboutState.empty() : this(appName: '', version: '');
  const AboutState({required this.version, required this.appName});
}

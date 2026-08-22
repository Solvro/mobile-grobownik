import "package:envied/envied.dart";

part "env.g.dart";

@Envied(path: ".env", obfuscate: true, useConstantCase: true, requireEnvFile: true)
abstract class Env {
  @EnviedField()
  static final String directusUrl = _Env.directusUrl;
  @EnviedField()
  static final String directusStaticToken = _Env.directusStaticToken;
}

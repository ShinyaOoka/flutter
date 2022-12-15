// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginConfig _$LoginConfigFromJson(Map<String, dynamic> json) => LoginConfig(
      protocol: json['protocol'] as String?,
      server: json['server'] as String?,
      port: json['port'] as String?,
      database: json['database'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      userName: json['userName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$LoginConfigToJson(LoginConfig instance) =>
    <String, dynamic>{
      'protocol': instance.protocol,
      'server': instance.server,
      'port': instance.port,
      'database': instance.database,
      'email': instance.email,
      'password': instance.password,
      'userName': instance.userName,
      'avatarUrl': instance.avatarUrl,
    };

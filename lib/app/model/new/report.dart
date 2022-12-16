import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Report extends Equatable {
  String? date = 'yyyy/mm/dd hh:mm';
  String? name = 'XXXXX';
  String? accident_type = 'XXX';
  String? description = 'XXXXXXXXXXXXXXXXXXXX';

  Report({
    this.date,
    this.name,
    this.accident_type,
    this.description,
  });

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);

  //compare two object
  @override
  List<Object?> get props => [
        date,
        name,
        accident_type,
        description,
      ];
}

import 'package:equatable/equatable.dart';

class MonitoringFilter extends Equatable {
  final DateTime timestamp;
  final MonitoringType filter;

  const MonitoringFilter({
    required this.timestamp,
    required this.filter,
  });

  @override
  List<Object?> get props => [timestamp, filter];
}

enum MonitoringType { solar, house, battery }

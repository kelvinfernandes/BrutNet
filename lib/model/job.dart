import 'package:hive/hive.dart';
import 'package:animate_do/animate_do.dart';

part 'job.g.dart';

@HiveType(typeId: 0)
class Job extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late double brut;

  @HiveField(2)
  late double net;

  @HiveField(3)
  late String statut;

  @HiveField(4)
  late String comment;


}

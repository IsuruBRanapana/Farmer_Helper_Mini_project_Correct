import 'package:flutter/foundation.dart';

class CultivationProblem {
  CultivationProblem({
    @required this.id,
    @required this.jobId,
     this.start,
    this.end,
    @required this.image,
    this.comment,
  });

  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String comment;
  String image;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory CultivationProblem.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    final String imageUrl=value['image'];
    return CultivationProblem(
      id: id,
      jobId: value['jobId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'],
      image: imageUrl
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
      'image':image,
    };
  }
}

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:udemy_course/app/home/models/entry.dart';
import 'package:udemy_course/app/home/models/job.dart';
import 'package:udemy_course/services/apipath.dart';
import 'package:udemy_course/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(CultivationType job);
  Future<void> deleteJob(CultivationType job);
  Stream<List<CultivationType>> jobsStream();

  Future<void> setEntry(CultivationProblem entry);
  Future<void> deleteEntry(CultivationProblem entry);
  Stream<List<CultivationProblem>> cultivationProblemsStream({CultivationType job});
  Stream<CultivationType> cultivationTypeStream({@required String jobId});
}

String documentIdFromCurrentDateAndTime() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(CultivationType job) async => await _service.setData(
        path: APIPath.cultivationType(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(CultivationType job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await cultivationProblemsStream(job: job).first;
    for (CultivationProblem entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.cultivationType(uid, job.id));
  }

  @override
  Stream<CultivationType> cultivationTypeStream({@required String jobId}) => _service.documentStream(
        path: APIPath.cultivationType(uid, jobId),
        builder: (data, documentId) => CultivationType.fromMap(data, documentId),
      );

  @override
  Stream<List<CultivationType>> jobsStream() => _service.collectionStream(
        path: APIPath.cultivationTypes(uid),
        builder: (data, documentId) => CultivationType.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(CultivationProblem entry) async => await _service.setData(
        path: APIPath.cultivationProblem(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(CultivationProblem entry) async =>
      await _service.deleteData(path: APIPath.cultivationProblem(uid, entry.id));

  @override
  Stream<List<CultivationProblem>> cultivationProblemsStream({CultivationType job}) =>
      _service.collectionStream<CultivationProblem>(
        path: APIPath.cultivationProblems(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => CultivationProblem.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}

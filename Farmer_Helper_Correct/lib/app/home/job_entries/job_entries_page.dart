import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:udemy_course/app/home/job_entries/entry_list_item.dart';
import 'package:udemy_course/app/home/job_entries/entry_page.dart';
import 'package:udemy_course/app/home/problems/edit_job_page.dart';
import 'package:udemy_course/app/home/problems/list_item_builder.dart';
import 'package:udemy_course/app/home/models/entry.dart';
import 'package:udemy_course/app/home/models/job.dart';
import 'package:udemy_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:udemy_course/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({@required this.database, @required this.cultivationType});
  final Database database;
  final CultivationType cultivationType;

  static Future<void> show(BuildContext context, CultivationType cultivationType) async {
    final Database database = Provider.of<Database>(context);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, cultivationType: cultivationType),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, CultivationProblem cultivationProblem) async {
    try {
      await database.deleteEntry(cultivationProblem);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CultivationType>(
        stream: database.cultivationTypeStream(jobId: cultivationType.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 2.0,
              title: Text(jobName),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => EditJobPage.show(
                    context,
                    database: database,
                    job: job,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () => EntryPage.show(
                    context: context,
                    database: database,
                    cultivationType: job,
                  ),
                ),
              ],
            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(BuildContext context, CultivationType job) {
    return StreamBuilder<List<CultivationProblem>>(
      stream: database.cultivationProblemsStream(job: job),
      builder: (context, snapshot) {
        return ListItemBuilder<CultivationProblem>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                cultivationType: job,
                cultivationProblem: entry,
              ),
            );
          },
        );
      },
    );
  }
}

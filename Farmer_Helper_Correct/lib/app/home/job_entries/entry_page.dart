import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:udemy_course/app/home/job_entries/date_time_picker.dart';
import 'package:udemy_course/app/home/job_entries/format.dart';
import 'package:udemy_course/app/home/models/entry.dart';
import 'package:udemy_course/app/home/models/job.dart';
import 'package:udemy_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:udemy_course/services/database.dart';

class EntryPage extends StatefulWidget {
  const EntryPage(
      {@required this.database,
      @required this.cultivationType,
      this.cultivationProblem});
  final CultivationType cultivationType;
  final CultivationProblem cultivationProblem;
  final Database database;

  static Future<void> show(
      {BuildContext context,
      Database database,
      CultivationType cultivationType,
      CultivationProblem cultivationProblem}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EntryPage(
            database: database,
            cultivationType: cultivationType,
            cultivationProblem: cultivationProblem),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  String url;
  File _image;
  String _url;
  String _title;
  DateTime _startDate;
  TimeOfDay _startTime;
  DateTime _endDate;
  TimeOfDay _endTime;
  String _description;
  String correctImageUrl;

  /*Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image path $_image');
    });
  }*/
  Future chooseFile() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selectedImage;
      uploadPic(context);
    });
  }

  Future uploadPic(BuildContext context) async {
    /* String fileName = basename(_image.path);*/
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('fileName');
    var timeKey = DateTime.now();

    final StorageUploadTask uploadTask =
        firebaseStorageRef.child(timeKey.toString() + ".jpg").putFile(_image);

    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(imageUrl.toString());
    _url = imageUrl.toString();
    print('$_url');
    print("Image Url=" + _url);
    correctImageUrl = await saveToDatabase(_url);
    print(correctImageUrl);

    /*setState(() async {
      if(correctImageUrl==null){
        await CircularProgressIndicator();
      }
    });*/

    /*StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;*/
    /* setState(() {
      print('Profile picture is uploaded.');
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Profile picture is uploaded.'),
      ));
    });*/
  }

  Future<String> saveToDatabase(url) async {
    return url.toString();
    /*DocumentReference ds=Firestore.instance.collection('profiledata').document(email);
    Map<String,dynamic> tasks={
      "name":name,
      "address":address,
      "city":city,
      "passion":passion,
      "phonenumber":phonenumber,
      "email":email,
      "gendervalue":gendervalue,
      "Image":url,

    };
    ds.setData(tasks).whenComplete((){
      print('New data added.');
    });

    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
      'image':image,
    };
  }


    */
  }

  @override
  void initState() {
    super.initState();
    final start = widget.cultivationProblem?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.cultivationProblem?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _description = widget.cultivationProblem?.comment ?? '';
    url = correctImageUrl;
    print(url);
  }

  CultivationProblem _entryFromState() {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
        _startTime.hour, _startTime.minute);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
        _endTime.hour, _endTime.minute);
    final id =
        widget.cultivationProblem?.id ?? documentIdFromCurrentDateAndTime();
    final imageCorrectUrl = url;

    return CultivationProblem(
      id: id,
      jobId: widget.cultivationType.id,
      start: start,
      end: end,
      comment: _description,
      image: correctImageUrl,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.cultivationType.name),
        actions: <Widget>[
          FlatButton(
            child: Text(
              widget.cultivationProblem != null ? 'Update' : 'Post',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            //  _buildStartDate(),
              //_buildEndDate(),
              _buildImageUrl(),
              SizedBox(height: 8.0),
              _buildDuration(),
              SizedBox(height: 8.0),
              _buildComment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate,
      selectedTime: _startTime,
      onSelectedDate: (date) => setState(() => _startDate = date),
      onSelectedTime: (time) => setState(() => _startTime = time),
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate,
      selectedTime: _endTime,
      onSelectedDate: (date) => setState(() => _endDate = date),
      onSelectedTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = Format.hours(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _description),
      decoration: InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _description = comment,
    );
  }

  Widget _buildImageUrl() {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(),
          flex: 1,
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: Container(
                  color: Color(0xffBA680B),
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        height: 250,
                        width: 250,
                        child: (_image != null)
                            ? Image.file(
                                _image,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                '',
                                fit: BoxFit.fill,
                              ),
                      ),
                      Center(
                        child: Center(
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () {
                                //uploadPic(context);
                                chooseFile();
                              },
                              iconSize: 30.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(),
          flex: 1,
        )
      ],
    );
  }
}

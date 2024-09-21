import 'dart:async';

import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter/material.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class PhotoScreen extends StatefulWidget {
  final String photoUrl;

  const PhotoScreen({super.key, required this.photoUrl});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  int progress = 0;
  dynamic downloadId;
  String? status;
  late StreamSubscription progressStream;

  @override
  void initState() {
    FlDownloader.initialize();
    initPackage();
    super.initState();
  }

  initPackage() async {
    progressStream = FlDownloader.progressStream.listen((event) {
      if (event.status == DownloadStatus.successful) {
        debugPrint('event.progress: ${event.progress}');
        setState(() {
          progress = event.progress;
          downloadId = event.downloadId;
          status = event.status.name;
        });
        // This is a way of auto-opening downloaded file right after a download is completed
        FlDownloader.openFile(filePath: event.filePath);
      } else if (event.status == DownloadStatus.running) {
        debugPrint('event.progress: ${event.progress}');
        setState(() {
          progress = event.progress;
          downloadId = event.downloadId;
          status = event.status.name;
        });
      } else if (event.status == DownloadStatus.failed) {
        debugPrint('event: $event');
        setState(() {
          progress = event.progress;
          downloadId = event.downloadId;
          status = event.status.name;
        });
      } else if (event.status == DownloadStatus.paused) {
        debugPrint('Download paused');
        setState(() {
          progress = event.progress;
          downloadId = event.downloadId;
          status = event.status.name;
        });
        // Here I am attaching the download progress to the download task again
        // after an paused status because the download task can be paused by
        // the system when the connection is lost or is waiting for a wifi
        // connection see https://developer.android.com/reference/android/app/DownloadManager#PAUSED_QUEUED_FOR_WIFI
        // for the possible reasons of a download task to be auto-paused by the
        // system (this applies to Windows too as the plugin sets the same suspension
        // policies for Windows downloads).
        Future.delayed(
          const Duration(milliseconds: 250),
          () => FlDownloader.attachDownloadProgress(event.downloadId),
        );
      } else if (event.status == DownloadStatus.pending) {
        debugPrint('Download pending');
        setState(() {
          progress = event.progress;
          downloadId = event.downloadId;
          status = event.status.name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Photo Screen',
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: [
            InstaImageViewer(
                child: Image(image: Image.network(widget.photoUrl).image)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                  ),
                  onPressed: () async {
                    final permission = await FlDownloader.requestPermission();
                    if (permission == StoragePermissionStatus.granted) {
                      await FlDownloader.download(
                        widget.photoUrl,
                        fileName: "photo$progress.jpg",
                      );
                    } else {
                      debugPrint('Permission denied =(');
                    }
                  },
                  child: const Text(
                    "Download Photo",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.white),
                  )),
            ),
          ],
        ));
  }
}

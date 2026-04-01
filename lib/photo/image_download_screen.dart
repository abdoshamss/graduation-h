import 'dart:async';

import 'package:fl_downloader/fl_downloader.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class ImageDownloadScreen extends StatefulWidget {
  final String imageUrl;

  const ImageDownloadScreen({super.key, required this.imageUrl});

  @override
  State<ImageDownloadScreen> createState() => _ImageDownloadScreenState();
}

class _ImageDownloadScreenState extends State<ImageDownloadScreen> {
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
  void dispose() {
    progressStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Download Image',
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InstaImageViewer(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          if (status == 'running')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: LinearProgressIndicator(value: progress / 100),
            ),
          if (status != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Status: $status ($progress%)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final permission = await FlDownloader.requestPermission();
                if (permission == StoragePermissionStatus.granted) {
                  await FlDownloader.download(
                    widget.imageUrl,
                    fileName: "image_${DateTime.now().millisecondsSinceEpoch}.jpg",
                  );
                } else {
                  debugPrint('Permission denied');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Permission denied')),
                    );
                  }
                }
              },
              child: const Text(
                "Download Photo",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

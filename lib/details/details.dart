import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:garduation_h/details/photos_model.dart';
import 'package:garduation_h/photo/photo.dart';

import 'model.dart';

class DetailsScreen extends StatefulWidget {
  final int id;

  const DetailsScreen({super.key, required this.id});

  @override
  State<DetailsScreen> createState() => _DetailsStateScreen();
}

class _DetailsStateScreen extends State<DetailsScreen> {
  late final Dio _dio;
  PersonDetails? data;
  PersonPhotos? photosData;

  @override
  void initState() {
    _dio = Dio();
    getDetailsData();
    getPhotos();
    super.initState();
  }

  bool isLoading = false;
  bool isLoadingPhotos = false;

  getDetailsData() async {
    isLoading = true;
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/person/${widget.id}?api_key=2dfe23358236069710a379edd4c65a6b');

      if (response.data != null) {
        data = PersonDetails.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  getPhotos() async {
    isLoadingPhotos = true;
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/person/${widget.id}/images?api_key=2dfe23358236069710a379edd4c65a6b');

      if (response.data != null) {
        photosData =
            PersonPhotos.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingPhotos = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details Screen',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Image.network(
                  data!.profilePath!,
                  height: MediaQuery.of(context).size.height / 2.5,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data!.name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(data!.birthday!),
                      const SizedBox(height: 4),
                      Text(data!.placeOfBirth!),
                      const SizedBox(height: 4),
                      Text(
                        data!.biography!,
                        maxLines: 7,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 300,
                        child: GridView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 130,
                                    childAspectRatio: 100 / 100,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                            itemCount: photosData?.profiles?.length ?? 0,
                            itemBuilder: (context, index) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PhotoScreen(
                                                  photoUrl: photosData!
                                                      .profiles![index]
                                                      .filePath!,
                                                )));
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: const Color(0xffD5D5DE),
                                            width: 2.4),
                                        image: DecorationImage(
                                            image: NetworkImage(photosData!
                                                .profiles![index].filePath!),
                                            fit: BoxFit.fill)),
                                  ),
                                )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

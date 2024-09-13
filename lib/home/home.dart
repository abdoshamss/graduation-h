import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Dio _dio;
  PersonsList? data;
  @override
  void initState() {
    _dio = Dio();
    getHomeData();
    super.initState();
  }

  bool isLoading = false;
  getHomeData() async {
    isLoading = true;
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/person/popular?api_key=2dfe23358236069710a379edd4c65a6b');

      if (response.data != null) {
        // Type type = response.data.runtimeType;
        // print(type);
        data = PersonsList.fromJson(response.data as Map<String, dynamic>);


      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          :  ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) =>
        const SizedBox(
          height: 8,
        ),
        itemBuilder: (context, index) =>
            PersonItem(
              person:data?.persons![index],
            ),
        itemCount:data?.persons!.length??0,
      ),
    );
  }
}
class PersonItem extends StatelessWidget {
  final Person? person;
  const PersonItem({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color:  const Color(0xffE0EBFF)),
            borderRadius: BorderRadius.circular( 16)),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}

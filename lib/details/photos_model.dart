class PersonPhotos {
  final int? id;
  final List<Profile>? profiles;

  PersonPhotos({this.id, this.profiles});

  factory PersonPhotos.fromJson(Map<String, dynamic> json) {
    return PersonPhotos(
      id: json['id'],
      profiles: (json['profiles'] as List?)
          ?.map((item) => Profile.fromJson(item))
          .toList(),
    );
  }
}

class Profile {
  final double? aspectRatio;
  final int? height;
  final String? iso6391;
  final String? filePath;
  final double? voteAverage;
  final int? voteCount;
  final int? width;

  Profile({
    this.aspectRatio,
    this.height,
    this.iso6391,
    this.filePath,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      aspectRatio: json['aspect_ratio'],
      height: json['height'],
      iso6391: json['iso_639_1'],
      filePath: "https://image.tmdb.org/t/p/w500${json['file_path']}",
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      width: json['width'],
    );
  }
}

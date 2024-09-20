class PersonDetails {
  final bool? adult;
  final List<String>? alsoKnownAs;
  final String? biography;
  final String? birthday;
  final String? deathday;
  final int? gender;
  final String? homepage;
  final int? id;
  final String? imdbId;
  final String? knownForDepartment;
  final String? name;
  final String? placeOfBirth;
  final double? popularity;
  final String? profilePath;

  PersonDetails({
    this.adult,
    this.alsoKnownAs,
    this.biography,
    this.birthday,
    this.deathday,
    this.gender,
    this.homepage,
    this.id,
    this.imdbId,
    this.knownForDepartment,
    this.name,
    this.placeOfBirth,
    this.popularity,
    this.profilePath,
  });

  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    return PersonDetails(
      adult: json['adult'],
      alsoKnownAs: (json['also_known_as'] as List?)?.cast<String>(),
      biography: json['biography'],
      birthday: json['birthday'],
      deathday: json['deathday'],
      gender: json['gender'],
      homepage: json['homepage'],
      id: json['id'],
      imdbId: json['imdb_id'],
      knownForDepartment: json['known_for_department'],
      name: json['name'],
      placeOfBirth: json['place_of_birth'],
      popularity: json['popularity'],
      profilePath: "https://image.tmdb.org/t/p/w500${json['profile_path']}",
    );
  }
}
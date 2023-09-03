import 'dart:convert';

List<Beer> beerFromJson(String str) => List<Beer>.from(json.decode(str).map((x) => Beer.fromJson(x)));

String beerToJson(List<Beer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Beer {
    int id;
    String name;
    String tagline;
    String firstBrewed;
    String description;
    String imageUrl;

    Beer({
        required this.id,
        required this.name,
        required this.tagline,
        required this.firstBrewed,
        required this.description,
        required this.imageUrl,
    });

    factory Beer.fromJson(Map<String, dynamic> json) => Beer(
        id: json["id"],
        name: json["name"],
        tagline: json["tagline"],
        firstBrewed: json["first_brewed"],
        description: json["description"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tagline": tagline,
        "first_brewed": firstBrewed,
        "description": description,
        "image_url": imageUrl,
    };
}
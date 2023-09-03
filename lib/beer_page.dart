import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BeerDetailsPage extends StatefulWidget {
  final int beerId;

  BeerDetailsPage({required this.beerId});

  @override
  _BeerDetailsPageState createState() => _BeerDetailsPageState();
}

class _BeerDetailsPageState extends State<BeerDetailsPage> {
  late Future<Map<String, dynamic>> _fetchBeerDetails;

  @override
  void initState() {
    super.initState();
    _fetchBeerDetails = _fetchBeerDetailsFromApi();
  }

  Future<Map<String, dynamic>> _fetchBeerDetailsFromApi() async {
    final response =
        await http.get(Uri.parse('https://api.punkapi.com/v2/beers'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final beer = jsonData.firstWhere(
        (beer) => beer['id'] == widget.beerId,
        orElse: () => null,
      );
      if (beer != null) {
        return beer as Map<String, dynamic>;
      } else {
        throw Exception('Beer not found');
      }
    } else {
      throw Exception('Failed to fetch beer details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: _fetchBeerDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error');
            } else if (snapshot.hasData) {
              final beer = snapshot.data!;
              return Text(beer['name'],
              style: TextStyle(color: Colors.white));
            } else {
              return Text('Beer Details');
            }
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchBeerDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to fetch beer details'));
          } else if (snapshot.hasData) {
            final beer = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: Image.network(
                      beer['image_url'],
                      width: 500,
                      height: 400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          beer['name'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          beer['tagline'],
                          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Description:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          beer['description'],
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 16),
                         Text(
                          'ABV',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(
                          '${beer['abv'].toStringAsFixed(2)}%',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        // Text(
                        //   'IBU: ${beer['ibu']}',
                        //   style: TextStyle(fontSize: 16, color: Colors.black),
                        // ),
                        SizedBox(height: 16),
                        Text(
                          'First Brewed',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 2),
                        Text(
                          beer['first_brewed'],
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Food Pairing:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (beer['food_pairing'] as List<dynamic>)
                              .map((food) => Text(
                                    '- ' + ' '+ food,
                                    style: TextStyle(fontSize: 16),
                                  ))
                              .toList(),
                        ),
                       SizedBox(height: 16),
                        Text(
                          'Brewers Tips',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 2),
                        Text(
                          beer['brewers_tips'],
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        
                        // Add additional beer details here
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No beer details available'));
          }
        },
      ),
    );
  }
}
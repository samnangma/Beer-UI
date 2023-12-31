import 'package:api/beer.dart';
import 'package:api/beer_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 0, 0)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Beer List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Beer>> _beersFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _fetchBeers();
  }

  Future<void> _fetchBeers() async {
    try {
      var response = await http.get(Uri.http('api.punkapi.com', '/v2/beers'));
      if (response.statusCode == 200) {
        var beers = beerFromJson(response.body);
        setState(() {
          _beersFuture = Future.value(beers);
        });
      } else {
        throw Exception('Could not load beer data');
      }
    } catch (error) {
      setState(() {
        _beersFuture = Future.error(error);
      });
    }
  }

  Future<void> _refreshPage() async {
    await _fetchBeers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beer List'),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          child: FutureBuilder<List<Beer>>(
            future: _beersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                var data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(9.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BeerDetailsPage(beerId: data[index].id),
                            ),
                          );
                        },
                        title: Text(
                          data[index].name,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          data[index].tagline,
                          style: TextStyle(color: Colors.black),
                        ),
                        leading: Image.network(data[index].imageUrl),
                      ),
                    );
                  },
                );
              } else {
                return const Text('No data available');
              }
            },
          ),
        ),
      ),
    );
  }
}
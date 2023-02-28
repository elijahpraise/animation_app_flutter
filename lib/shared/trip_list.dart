import 'package:flutter/material.dart';
import 'package:animation_app_flutter/models/trip.dart';
import 'package:animation_app_flutter/screens/details.dart';

class TripList extends StatefulWidget {
  const TripList({super.key});

  @override
  State<TripList> createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  late List<Widget> _tripTiles;
  late GlobalKey<AnimatedListState> _listKey;
  late Tween<Offset> _offset;
  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey<AnimatedListState>();
    _tripTiles = [];
    _offset = Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _addTrips();
    });
  }

  void _addTrips() {
    // get data from db
    List<Trip> trips = [
      Trip(
          title: 'Beach Paradise', price: '350', nights: '3', img: 'beach.png'),
      Trip(title: 'City Break', price: '400', nights: '5', img: 'city.png'),
      Trip(title: 'Ski Adventure', price: '750', nights: '2', img: 'ski.png'),
      Trip(title: 'Space Blast', price: '600', nights: '4', img: 'space.png'),
    ];
    Future ft = Future(() {});
    for (Trip trip in trips) {
      ft.then((value) {
        return Future.delayed(
          const Duration(
            milliseconds: 100,
          ),
          () {
            _tripTiles.add(_buildTile(trip));
            _listKey.currentState!.insertItem(_tripTiles.length - 1);
          },
        );
      });
    }
  }

  Widget _buildTile(Trip trip) {
    return ListTile(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Details(trip: trip)));
      },
      contentPadding: const EdgeInsets.all(25),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${trip.nights} nights',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300])),
          Text(trip.title,
              style: TextStyle(fontSize: 20, color: Colors.grey[600])),
        ],
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Hero(
          tag: "location-img-${trip.img}",
          child: Image.asset(
            'images/${trip.img}',
            height: 50.0,
          ),
        ),
      ),
      trailing: Text('\$${trip.price}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        key: _listKey,
        initialItemCount: _tripTiles.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(_offset),
            child: _tripTiles[index],
          );
        });
  }
}

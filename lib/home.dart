import 'package:count_down_date/add_screen.dart';
import 'package:count_down_date/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'custom_countdown_timer.dart';
import 'models/countdown.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đếm ngược'),
      ),
    );
  }
}

class CountDownScreen extends StatefulWidget {
  @override
  _CountDownScreenState createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  CountdownRepository _countdownRepository;
  Future<List<CountDown>> _list;

  @override
  void initState() {
    super.initState();
    _countdownRepository = CountdownRepository();
    _list = _countdownRepository.getAll();
  }

  void deleteCountDown(CountDown entity) async {
    await _countdownRepository.delete(entity);
  }

  @override
  Widget build(BuildContext context) {
    _list = _countdownRepository.getAll();
    return Scaffold(
      backgroundColor: Color(0xFFD0D3DA),
      appBar: AppBar(
        title: Text('Đếm ngược'),
      ),
      body: FutureBuilder(
        future: _list,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<CountDown> list = snapshot.data;
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white70,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          title: Text(
                            '$index - ${list[index].title}',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                          subtitle: Text(
                            '${list[index].endDate.day}/${list[index].endDate.month}/${list[index].endDate.year}',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) {
                              List<PopupMenuItem> listItems =
                                  List<PopupMenuItem>();
                              listItems.add(PopupMenuItem(
                                child: FlatButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    deleteCountDown(list[index]);
                                  },
                                ),
                              ));
                              return listItems;
                            },
                          ),
                        ),
                        CountDownDateWidget.fCountdownDate(
                          list[index].startDate,
                          list[index].endDate,
                          Colors.black,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => AddCountdownScreen(),
          ),
        )
            .then((value) {
          setState(() {});
        }),
      ),
    );
  }
}

class CountDownDateWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Color fillColor;
  final Color textColor;
  final DateTime startDate;
  final DateTime endDate;

  factory CountDownDateWidget.fCountdownDate(
      DateTime startDate, DateTime endDate, Color color) {
    return CountDownDateWidget(
      startDate: startDate,
      endDate: endDate,
      width: 200,
      height: 200,
      color: color,
      fillColor: Colors.white,
      textColor: color,
    );
  }
  const CountDownDateWidget({
    this.width,
    this.height,
    this.color,
    this.fillColor,
    this.textColor,
    @required this.startDate,
    @required this.endDate,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularCountDownDate(
      color: color,
      width: width / 2,
      height: height / 2,
      fillColor: fillColor,
      strokeWidth: width * 0.05,
      isReverse: true,
      textStyle: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: width * 0.15,
      ),
      belowWidget: Text(
        'Ngày',
        style: TextStyle(
          color: textColor,
          fontSize: width * 0.04,
        ),
      ),
      startDate: startDate,
      endDate: endDate,
    );
  }
}

import 'package:count_down_date/models/countdown.dart';
import 'package:count_down_date/repositories/repository.dart';
import 'package:flutter/material.dart';

class AddCountdownScreen extends StatefulWidget {
  @override
  _AddCountdownScreenState createState() => _AddCountdownScreenState();
}

class _AddCountdownScreenState extends State<AddCountdownScreen> {
  DateTime startDate;
  DateTime endDate;
  TextEditingController _titleTextController;
  CountdownRepository _countdownRepository;
  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    _titleTextController = TextEditingController();
    _countdownRepository = CountdownRepository();
  }

  void insert(CountDown entity) async {
    await _countdownRepository.insert(entity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm mới'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_titleTextController.text.isNotEmpty &&
                  startDate != null &&
                  endDate != null) {
                print(_titleTextController.text);
                CountDown entity = CountDown(
                  title: _titleTextController.text,
                  startDate: startDate,
                  endDate: endDate,
                );
                insert(entity);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Sự kiện*:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.deepPurple[100],
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                controller: _titleTextController,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Ngày bắt đầu*:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.deepPurple[100],
              ),
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                    '${startDate.day}/${startDate.month}/${startDate.year}'),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2050),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        startDate = value;
                      });
                    }
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ngày kết thúc*:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.deepPurple[100],
              ),
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(endDate == null
                    ? ''
                    : '${endDate.day}/${endDate.month}/${endDate.year}'),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: endDate == null ? DateTime.now() : endDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2050),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        endDate = value;
                      });
                    }
                  });
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

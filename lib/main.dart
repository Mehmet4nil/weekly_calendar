import 'package:flutter/material.dart';
//import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //CalendarController _controller;
  bool _chcBxValue = false;
  String deneme = "deneme";
  DateTime _time = DateTime.now(); //Güncel zaman veririsin alınması.

  int getVerboseDateTimeRepresentation(DateTime dateTime) {
    String _date = DateFormat('EEEE').format(
        _time); //Zaman verisinin gün formatına çevrilmesi ve haftanın kaçıncı günü olduğunun belirlenmesi.
    int _firstDay = 0;
    switch (_date) {
      case "Monday":
        {
          _firstDay = 1;
        }
        break;
      case "Tuesday":
        {
          _firstDay = 2;
        }
        break;
      case "Wednesday":
        {
          _firstDay = 3;
        }
        break;

      case "Thursday":
        {
          _firstDay = 4;
        }
        break;
      case "Friday":
        {
          _firstDay = 5;
        }
        break;

      case "Saturday":
        {
          _firstDay = 6;
        }
        break;
      default:
        {
          _firstDay = 7;
        }
        break;
    }
    return _firstDay;
  }

  List<TimeRegion> _getTimeRegions() {
    final List<TimeRegion> regions = <TimeRegion>[];
    var _startOfDay = DateTime(
        _time.year,
        _time.month,
        _time
            .day); // _"2020-10-19 00:00:00.000" tarzında bir time elde etmek için
    regions.add(TimeRegion(
      startTime: _startOfDay,
      endTime: _startOfDay.add(Duration(hours: 24)),
      enablePointerInteraction: false,
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SU',
      color: Colors.grey.withOpacity(0.5),
    ));

    return regions;
  }

  @override
  void initState() {
    super.initState();
    //_controller = CalendarController();
  }

  alertDialog(BuildContext context) {
    // This is the ok button
    Widget ok = FlatButton(
      child: Text("Okay"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("I am Here!"),
          content: Text("I appeared because you pressed the button!"),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }

  List<Appointment> appointments = <Appointment>[];
  _AppointmentDataSource _getCalendarDataSource() {
    var _startOfDay = DateTime(_time.year, _time.month, _time.day + 4);
    appointments.clear();
    appointments.add(Appointment(
      startTime: _startOfDay,
      endTime: _startOfDay.add(Duration(minutes: 60)),
      subject: 'Meeting',
      color: Colors.blue,
      startTimeZone: '',
      endTimeZone: '',
    ));

    return _AppointmentDataSource(appointments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Calendar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // TableCalendar(calendarController: _controller),
            Container(
              height: 820.0, // _Takvim yüksekliği
              child: SfCalendar(
                view: CalendarView.week,
                firstDayOfWeek: getVerboseDateTimeRepresentation(
                    _time), // _Hangi günde isek tablo başlangıcına o günün getirilmesi
                // initialSelectedDate: DateTime(2020, 10, 18, 10), // _Açılışta gün seçili olması
                dataSource: _getCalendarDataSource(),
                timeSlotViewSettings: TimeSlotViewSettings(
                  timeIntervalHeight: -1,
                  dateFormat: 'd',
                  dayFormat: 'EEE', // _Gün isimlerinin formatı
                  timeInterval:
                      Duration(minutes: 60), // _Kutular arası zaman aralığı
                  timeFormat: 'h:mm', // _Saat formatı.
                  timeTextStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    color: Colors.black87,
                  ), // _Saat yazı stili
                ),
                specialRegions: _getTimeRegions(),
              ),
            ),
            Center(
                child: RaisedButton(
              onPressed: () {
                //alertDialog(context);
                appointments.add(Appointment(
                  startTime: DateTime.now(),
                  endTime: DateTime.now().add(Duration(minutes: 90)),
                  subject: 'Meeting',
                  color: Colors.blue,
                  startTimeZone: '',
                  endTimeZone: '',
                ));
                _AppointmentDataSource(appointments);
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text('Seçilenleri Listele',
                    style: TextStyle(fontSize: 20)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

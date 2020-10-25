import 'package:flutter/material.dart';
//import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'list_screen.dart';

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
  DateTime _time = DateTime.now(); //Güncel zaman veririsin alınması.
  Appointment _ap1 = Appointment(
    startTime: DateTime.now(),
    endTime: DateTime.now().add(Duration(minutes: 60)),
    subject: 'Meeting',
    color: Colors.blue,
    startTimeZone: '',
    endTimeZone: '',
  );

  int getVerboseDateTimeRepresentation(DateTime dateTime) {
    // _Zaman verisinin gün formatına çevrilmesi ve haftanın kaçıncı günü olduğunun belirlenmesi.
    String _date = DateFormat('EEEE').format(_time);
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

    // _"2020-10-19 00:00:00.000" tarzında bir time elde etmek için
    var _startOfDay = DateTime(_time.year, _time.month, _time.day);
    regions.add(TimeRegion(
      startTime: _startOfDay,
      endTime: _startOfDay.add(Duration(hours: 24)),
      enablePointerInteraction: false,
      recurrenceRule: 'FREQ=WEEKLY;INTERVAL=1;BYDAY=SU',
      color: Colors.grey.withOpacity(0.5),
    ));

    return regions;
  }

  // _Seçilen kutuların tüm özellikleri ile tutulduğu liste.
  List<Appointment> appointments = <Appointment>[];

  _AppointmentDataSource _getCalendarDataSource() {
    return _AppointmentDataSource(appointments);
  }

  void _setAppointments(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.appointments == null) {
      // _Boş kutuya tıklandığında eklenecek toplantının verilerini tutar.
      _ap1 = Appointment(
        startTime: calendarTapDetails.date,
        endTime: calendarTapDetails.date.add(Duration(minutes: 60)),
        subject: 'Meeting',
        color: Colors.cyanAccent[600],
        startTimeZone: '',
        endTimeZone: '',
      );
    } else {
      // _Silinecek veri seçildiğinde dönen veri, ikinci seçmede özellik farklı döndüğü için bu çözüm kullanıldı.
      _ap1 = Appointment(
        startTime: calendarTapDetails.appointments[0].startTime,
        endTime: calendarTapDetails.appointments[0].startTime
            .add(Duration(minutes: 60)),
        subject: '',
        color: Colors.blue,
        startTimeZone: '',
        endTimeZone: '',
      );
    }

    setState(() {
      // _Seçilen kutunun daha önce seçilip seçilmediği kontrol edilir yoksa eklenir, var ise silinir.
      var _meetingControl = appointments.singleWhere(
          (element) => element.startTime == _ap1.startTime,
          orElse: () => null);
      if (_meetingControl == null) {
        appointments.add(_ap1);
      } else {
        appointments.removeWhere((item) => item.startTime == _ap1.startTime);
      }
    });
  }

  SfCalendar _getShiftScheduler(dynamic calendarTapCallback) {
    // _Takvimin tüm özellikleri ve oluşturulması.
    return SfCalendar(
      view: CalendarView.week,
      firstDayOfWeek: getVerboseDateTimeRepresentation(
          _time), // _Hangi günde isek tablo başlangıcına o günün getirilmesi
      // initialSelectedDate: DateTime(2020, 10, 18, 10), // _Açılışta gün seçili olması
      dataSource: _getCalendarDataSource(),
      timeSlotViewSettings: TimeSlotViewSettings(
        timeIntervalHeight: -1,
        dateFormat: 'd',
        dayFormat: 'EEE', // _Gün isimlerinin formatı
        timeInterval: Duration(minutes: 60), // _Kutular arası zaman aralığı
        timeFormat: 'h:mm', // _Saat formatı.
        timeTextStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 15,
          color: Colors.black87,
        ), // _Saat yazı stili
      ),
      specialRegions: _getTimeRegions(),
      onTap: calendarTapCallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Weekly Calendar")),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.calendar_today_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              // _Takvim yüksekliği
              height: 820.0,
              // _Varsa seçilen kutuların takime yollanması ve takvimin ekrana çizilmesi.
              child: _getShiftScheduler(_setAppointments),
            ),
            Center(
                child: RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SecondRoute(_myListView(context))),
                );
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
                child:
                    const Text('List Selected', style: TextStyle(fontSize: 20)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    // _Seçilen kutular liste halinde formatlanarak Widget haline dönüştürülür ve ikinci ekrana yollanır.
    final DateFormat formatter = DateFormat('dd MMM y EEEE');
    if (appointments.length != 0) {
      return ListView.builder(
        itemExtent: 29.0,
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text((index + 1).toString() +
                ". " +
                formatter.format(appointments[index].startTime).toString() +
                " -> " +
                appointments[index].startTime.toString().substring(11, 16) +
                " / " +
                appointments[index].endTime.toString().substring(11, 16)),
          );
        },
      );
    } else {
      // _Hiç öğre seçilmemiş ise uyarı yazısı yazdırılır.
      return Text("The selection list is empty. Please choose a meeting date.",
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            height: 25,
            color: Colors.blue[800],
          ));
    }
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

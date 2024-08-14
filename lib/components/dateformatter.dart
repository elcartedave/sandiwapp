import 'package:intl/intl.dart';

String dateFormatter(DateTime dateTime) {
  String day = dateTime.day.toString();
  String month = DateFormat.MMMM().format(dateTime);
  String year = dateTime.year.toString();
  String time = DateFormat('h:mm a').format(dateTime);
  String dayOfWeek = DateFormat.EEEE().format(dateTime);

  return '${tagalogNg(dayOfWeek)}, Ika-$day ng $month $year, $time';
}

String? tagalogNg(String date) {
  if (date == "Monday") {
    return "Lunes";
  }
  if (date == "Tuesday") {
    return "Martes";
  }
  if (date == "Wednesday") {
    return "Miyerkules";
  }
  if (date == "Thursday") {
    return "Huwebes";
  }
  if (date == "Friday") {
    return "Biyernes";
  }
  if (date == "Saturday") {
    return "Sabado";
  }
  if (date == "Sunday") {
    return "Linggo";
  }
}

String hourFormatter(DateTime date) {
  return DateFormat('h:mm a').format(date);
}

String petsa(DateTime dateTime) {
  String day = dateTime.day.toString();
  String month = DateFormat.MMMM().format(dateTime);
  String year = dateTime.year.toString();
  String dayOfWeek = DateFormat.EEEE().format(dateTime);

  return '${dayOfWeek}, ${month} ${day}';
}

String shortDateFormatter(DateTime dateTime) {
  String month = DateFormat.MMM().format(dateTime);
  String day = dateTime.day.toString();
  String time = DateFormat('h:mm a').format(dateTime);

  return '$month $day, $time';
}

String calculateAge(String birthday) {
  DateFormat dateFormat = DateFormat('MMMM d, yyyy');
  DateTime birthDate = dateFormat.parse(birthday);
  DateTime today = DateTime.now();

  print(birthDate);

  int age = today.year - birthDate.year;

  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--; // Decrement age if birthday hasn't occurred yet this year
  }

  return age.toString();
}

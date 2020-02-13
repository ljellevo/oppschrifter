package components;

class DateConverter {


  static public function convertTimestampToString(timestamp: Float): String {
    var date = Date.fromTime(timestamp);
    var monthString = "";

    switch (date.getMonth()) {
      case 0:
        monthString = "Jan";
      case 1:
        monthString = "Feb";
      case 2:
        monthString = "Mar";
      case 3:
        monthString = "Apr";
      case 4:
        monthString = "Mai";
      case 5:
        monthString = "Jun";
      case 6:
        monthString = "Jul";
      case 7:
        monthString = "Aug";
      case 8:
        monthString = "Sep";
      case 9:
        monthString = "Okt";
      case 10:
        monthString = "Nov";
      case 11:
        monthString = "Des";
    }


    return Std.string(date.getDate()) + " " + monthString + " " + Std.string(date.getFullYear());
  }
}
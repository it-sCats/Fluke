getDaysOfEvent(starterDate, endDate) {
  //takes time stamp of the starter date and end date of an events and returns how many days
  return DateTime.fromMicrosecondsSinceEpoch(starterDate.microsecondsSinceEpoch)
      .difference(
          DateTime.fromMicrosecondsSinceEpoch(endDate.microsecondsSinceEpoch))
      .inDays;
}

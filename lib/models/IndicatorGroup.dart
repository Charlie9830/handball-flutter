class IndicatorGroup {
  int later;
  int soon;
  int today;
  int overdue;
  bool hasUnreadComments;

  IndicatorGroup({
    this.later = 0,
    this.soon = 0,
    this.today = 0,
    this.overdue = 0,
    this.hasUnreadComments = false,
  });
}
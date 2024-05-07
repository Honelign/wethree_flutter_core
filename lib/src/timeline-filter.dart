import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:wethree_flutter_core/wethree_flutter_core.dart';

enum Quarter { this_quarter, last_quarter }

class TimelineFilter extends StatefulWidget {
  const TimelineFilter(
      {required this.timeline,
      this.label,
      this.initialValue,
      this.isSingleDayRequired = false});
  final ValueChanged<Timeline> timeline;
  final String? initialValue;
  final String? label;
  final bool isSingleDayRequired;
  @override
  State<TimelineFilter> createState() => _TimelineFilterState();
}

class _TimelineFilterState extends State<TimelineFilter> {
  DateTime today = DateUtils.dateOnly(DateTime.now());
  List<Timeline> items = [];
  @override
  void initState() {
    super.initState();
    getTimelineItems();
  }

  getTimelineItems() {
    items = [
      if (!widget.isSingleDayRequired) ...[
        Timeline(id: 1, title: 'Custom'),
        Timeline(id: 2, title: 'Today', from: today, to: today),
        Timeline(
            id: 3,
            title: 'Yesterday',
            from: today.subtract(Duration(days: 1)),
            to: today.subtract(Duration(days: 1))),
        Timeline(
            id: 13,
            title: 'Tomorrow',
            from: today.add(Duration(days: 1)),
            to: today.add(Duration(days: 1))),
      ],
      Timeline(
          id: 4,
          title: 'This Week',
          from: today.subtract(Duration(days: today.weekday - 1)),
          to: today.add(Duration(days: DateTime.daysPerWeek - today.weekday))),
      Timeline(
          id: 5,
          title: 'Last Week',
          from: today
              .subtract(Duration(days: (today.weekday - 1)))
              .subtract(Duration(days: 7)),
          to: today
              .add(Duration(days: (DateTime.daysPerWeek - today.weekday)))
              .subtract(Duration(days: 7))),
      Timeline(
          id: 14,
          title: 'Next Week',
          from: today
              .subtract(Duration(days: (today.weekday - 1)))
              .add(Duration(days: 7)),
          to: today
              .add(Duration(days: (DateTime.daysPerWeek - today.weekday)))
              .add(Duration(days: 7))),
      Timeline(
        id: 6,
        title: 'This Month',
        from: DateTime(today.year, today.month, 1),
        to: (today.month < 12)
            ? DateTime(today.year, today.month + 1, 0)
            : DateTime(today.year + 1, 1, 0),
      ),
      Timeline(
        id: 7,
        title: 'Last Month',
        from: DateTime(today.year, today.month - 1, 1),
        to: (today.month < 12)
            ? DateTime(today.year, today.month, 0)
            : DateTime(today.year, 11, 30),
      ),
      Timeline(
        id: 15,
        title: 'Next Month',
        from: (today.month < 12)
            ? DateTime(today.year, today.month + 1, 1)
            : DateTime(today.year + 1, 1, 1),
        to: (today.month < 12)
            ? DateTime(today.year, today.month + 2, 0)
            : DateTime(today.year + 1, 1, 30),
      ),
      Timeline(
        id: 8,
        title: 'This Quarter',
        from: getQuarterDuration(today, Quarter.this_quarter)![0],
        to: getQuarterDuration(today, Quarter.this_quarter)![1],
      ),
      Timeline(
        id: 9,
        title: 'Last Quarter',
        from: getQuarterDuration(today, Quarter.last_quarter)![0],
        to: getQuarterDuration(today, Quarter.last_quarter)![1],
      ),
      Timeline(
        id: 10,
        title: 'This Year',
        from: DateTime(today.year, 1, 1),
        to: DateTime(today.year, 12, 31),
      ),
      Timeline(
        id: 11,
        title: 'Last Year',
        from: DateTime(today.year - 1, 1, 1),
        to: DateTime(today.year - 1, 12, 31),
      ),
      Timeline(
        id: 12,
        title: 'All Dates',
        from: DateTime(1900),
        to: DateTime(2100),
      ),
    ];
    widget.timeline(widget.initialValue != null
        ? items.firstWhere((element) => element.title == widget.initialValue,
            orElse: () => items[4])
        : items[4]);
    setState(() {});
  }

  List<DateTime>? getQuarterDuration(DateTime date, Quarter type) {
    int quarter;
    if (date.month >= 1 && date.month <= 3) {
      quarter = 1;
    }
    if (date.month >= 4 && date.month <= 6) {
      quarter = 2;
    } else if (date.month >= 7 && date.month <= 9) {
      quarter = 3;
    } else {
      quarter = 4;
    }
    if (type == Quarter.last_quarter) quarter = quarter - 1;

    switch (quarter) {
      case 1:
        return [DateTime(date.year, 1, 1), DateTime(date.year, 3, 31)];

      case 2:
        return [DateTime(date.year, 4, 1), DateTime(date.year, 6, 30)];

      case 3:
        return [DateTime(date.year, 7, 1), DateTime(date.year, 9, 30)];

      case 4:
        return [DateTime(date.year, 10, 1), DateTime(date.year, 12, 31)];

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownSearch<Timeline>(
        popupProps: PopupProps.bottomSheet(),
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: inputDecoration(
                widget.label ?? 'Due Date',
                prefixIcon: Icons.calendar_month,
                enableBorder: true)),
        items: items,
        selectedItem: widget.initialValue != null
            ? items.firstWhere(
                (element) => element.title == widget.initialValue,
                orElse: () => items[4])
            : items[4],
        itemAsString: (value) => value.title??'',
        onChanged: (value) async {
          if (value?.id == 1) {
            DateTimeRange? range = await showDateRangePicker(
                initialEntryMode: DatePickerEntryMode.calendar,
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime(2100));

            value?.from = range!.start;
            value?.to = range!.end;
            widget.timeline(value!);
          } else {
            widget.timeline(value!);
          }
        },
      ),
    );
  }
}

class Timeline {
  int? id;
  String? title;
  DateTime? from;
  DateTime? to;

  Timeline({this.id, this.title, this.from, this.to});
}

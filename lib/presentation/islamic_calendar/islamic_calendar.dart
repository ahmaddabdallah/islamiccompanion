import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/hijri_date_header_widget.dart';
import './widgets/calendar_cell_widget.dart';
import './widgets/islamic_event_modal.dart';
import './widgets/day_details_modal.dart';

class IslamicCalendar extends StatefulWidget {
  const IslamicCalendar({super.key});

  @override
  State<IslamicCalendar> createState() => _IslamicCalendarState();
}

class _IslamicCalendarState extends State<IslamicCalendar> {
  late final ValueNotifier<List<DateTime>> _selectedDays;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Prayer times data structure
  final Map<DateTime, Map<String, String>> _prayerTimes = {};

  // Islamic events data
  final Map<DateTime, List<Map<String, dynamic>>> _islamicEvents = {};

  // Hijri calendar months in Arabic
  final List<String> _hijriMonths = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الثاني',
    'جمادى الأولى',
    'جمادى الثانية',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedDays = ValueNotifier([_selectedDay!]);
    _loadIslamicEvents();
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    _selectedDays.dispose();
    super.dispose();
  }

  // Custom Hijri date calculation (simplified version)
  Map<String, int> _getHijriDate(DateTime gregorianDate) {
    // Simplified Hijri calculation - in production, use a proper library
    // This is a basic approximation for demo purposes
    const hijriEpoch = 227015; // Hijri epoch in Julian days
    final julianDay = _getJulianDay(gregorianDate);
    final daysSinceHijriEpoch = julianDay - hijriEpoch;

    // Average Hijri year is about 354.37 days
    final hijriYear = (daysSinceHijriEpoch / 354.37).floor() + 1;
    final dayOfYear = daysSinceHijriEpoch % 354.37;
    final hijriMonth = (dayOfYear / 29.53).floor() + 1;
    final hijriDay = (dayOfYear % 29.53).floor() + 1;

    return {
      'day': hijriDay > 0 ? hijriDay : 1,
      'month': hijriMonth > 0 && hijriMonth <= 12 ? hijriMonth : 1,
      'year':
          hijriYear > 0 ? hijriYear : 1445, // Current approximate Hijri year
    };
  }

  int _getJulianDay(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  void _loadIslamicEvents() {
    // Sample Islamic events data
    final now = DateTime.now();
    final currentYear = now.year;

    // Approximate Islamic events (in production, these would come from a proper Islamic calendar API)
    _islamicEvents.addAll({
      DateTime(currentYear, 1, 10): [
        {
          'title_arabic': 'عاشوراء',
          'title_english': 'Day of Ashura',
          'description': 'يوم عاشوراء - اليوم العاشر من شهر محرم',
          'category': 'religious',
          'significance': 'A day of remembrance and fasting',
        }
      ],
      DateTime(currentYear, 3, 15): [
        {
          'title_arabic': 'المولد النبوي',
          'title_english': 'Mawlid an-Nabi',
          'description': 'ذكرى مولد النبي محمد صلى الله عليه وسلم',
          'category': 'celebration',
          'significance': 'Birth of Prophet Muhammad (PBUH)',
        }
      ],
      DateTime(currentYear, 4, 1): [
        {
          'title_arabic': 'بداية رمضان',
          'title_english': 'Beginning of Ramadan',
          'description': 'بداية شهر رمضان المبارك',
          'category': 'ramadan',
          'significance': 'Start of the holy month of fasting',
        }
      ],
      DateTime(currentYear, 5, 1): [
        {
          'title_arabic': 'عيد الفطر',
          'title_english': 'Eid al-Fitr',
          'description': 'عيد الفطر المبارك',
          'category': 'eid',
          'significance': 'Celebration marking the end of Ramadan',
        }
      ],
      DateTime(currentYear, 7, 8): [
        {
          'title_arabic': 'عيد الأضحى',
          'title_english': 'Eid al-Adha',
          'description': 'عيد الأضحى المبارك',
          'category': 'eid',
          'significance': 'Festival of Sacrifice',
        }
      ],
    });
  }

  void _loadPrayerTimes() {
    // Sample prayer times (in production, these would come from an API)
    final now = DateTime.now();
    for (int i = -15; i <= 15; i++) {
      final date = now.add(Duration(days: i));
      _prayerTimes[DateTime(date.year, date.month, date.day)] = {
        'fajr': '04:45',
        'dhuhr': '12:30',
        'asr': '15:45',
        'maghrib': '18:20',
        'isha': '19:45',
      };
    }
  }

  List<DateTime> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _islamicEvents[normalizedDay]?.map((e) => day).toList() ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedDays.value = [selectedDay];
      });
    }
  }

  void _showDayDetails(DateTime day) {
    final hijriDate = _getHijriDate(day);
    final events = _islamicEvents[DateTime(day.year, day.month, day.day)] ?? [];
    final prayers = _prayerTimes[DateTime(day.year, day.month, day.day)] ?? {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayDetailsModal(
        gregorianDate: day,
        hijriDate: hijriDate,
        hijriMonthName: _hijriMonths[hijriDate['month']! - 1],
        events: events,
        prayerTimes: prayers,
        onEventTap: _showEventDetails,
      ),
    );
  }

  void _showEventDetails(Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => IslamicEventModal(event: event),
    );
  }

  void _goToToday() {
    setState(() {
      _focusedDay = DateTime.now();
      _selectedDay = DateTime.now();
      _selectedDays.value = [DateTime.now()];
    });
  }

  void _showCalendarSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'إعدادات التقويم',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'calendar_view_month',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('عرض الشهر'),
              trailing: Radio<CalendarFormat>(
                value: CalendarFormat.month,
                groupValue: _calendarFormat,
                onChanged: (value) {
                  setState(() => _calendarFormat = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'calendar_view_week',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: const Text('عرض الأسبوع'),
              trailing: Radio<CalendarFormat>(
                value: CalendarFormat.twoWeeks,
                groupValue: _calendarFormat,
                onChanged: (value) {
                  setState(() => _calendarFormat = value!);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hijriToday = _getHijriDate(DateTime.now());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'التقويم الإسلامي',
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'today',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            onPressed: _goToToday,
            tooltip: 'اليوم',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'settings',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            onPressed: _showCalendarSettings,
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: Column(
        children: [
          // Hijri Date Header
          HijriDateHeaderWidget(
            hijriDate: hijriToday,
            hijriMonthName: _hijriMonths[hijriToday['month']! - 1],
          ),

          // Calendar
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.all(4.w),
                    child: TableCalendar<DateTime>(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.saturday,
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                        holidayTextStyle: TextStyle(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        markersMaxCount: 3,
                        markerDecoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                        cellMargin: EdgeInsets.all(1.w),
                        cellPadding: EdgeInsets.zero,
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        formatButtonShowsNext: false,
                        formatButtonDecoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        formatButtonTextStyle: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 12.sp,
                        ),
                        leftChevronIcon: CustomIconWidget(
                          iconName: 'chevron_right',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        rightChevronIcon: CustomIconWidget(
                          iconName: 'chevron_left',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        weekendStyle: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: _onDaySelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() => _calendarFormat = format);
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          return CalendarCellWidget(
                            day: day,
                            hijriDate: _getHijriDate(day),
                            hasEvents: _islamicEvents.containsKey(
                                DateTime(day.year, day.month, day.day)),
                            hasPrayerTimes: _prayerTimes.containsKey(
                                DateTime(day.year, day.month, day.day)),
                            onTap: () => _showDayDetails(day),
                          );
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return CalendarCellWidget(
                            day: day,
                            hijriDate: _getHijriDate(day),
                            hasEvents: _islamicEvents.containsKey(
                                DateTime(day.year, day.month, day.day)),
                            hasPrayerTimes: _prayerTimes.containsKey(
                                DateTime(day.year, day.month, day.day)),
                            isSelected: true,
                            onTap: () => _showDayDetails(day),
                          );
                        },
                        todayBuilder: (context, day, focusedDay) {
                          return CalendarCellWidget(
                            day: day,
                            hijriDate: _getHijriDate(day),
                            hasEvents: _islamicEvents.containsKey(
                                DateTime(day.year, day.month, day.day)),
                            hasPrayerTimes: _prayerTimes.containsKey(
                                DateTime(day.year, day.month, day.day)),
                            isToday: true,
                            onTap: () => _showDayDetails(day),
                          );
                        },
                      ),
                    ),
                  ),

                  // Quick Actions
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/prayer-times'),
                            icon: CustomIconWidget(
                              iconName: 'access_time',
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                            label: const Text('مواقيت الصلاة'),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/qibla-compass'),
                            icon: CustomIconWidget(
                              iconName: 'navigation',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            label: const Text('اتجاه القبلة'),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

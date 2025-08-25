import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:evently/Core/Custom/Custom_tabs_events.dart';
import 'package:evently/Core/Custom/Customtextform.dart';
import 'package:evently/Core/models/categorical_data.dart';
import 'package:evently/Core/models/event_data.dart';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/Core/utils/firebase_firestores_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:evently/gen_l10n/app_localizations.dart';

class Eventedit extends StatefulWidget {
  Eventedit({super.key, required this.data});
  EventData data;

  @override
  State<Eventedit> createState() => _EventeditState();
}

class _EventeditState extends State<Eventedit> {
  List<CategoricalData> categoricals = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selecteddate;
  int selectedIndex = 0;
  TimeOfDay? selectedTime;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize basic properties
    titleController.text = widget.data.enentTitle;
    descriptionController.text = widget.data.eventDescription;
    selecteddate = widget.data.eventDate;

    // Parse the time with error handling
    try {
      DateTime parsedTime = DateFormat('h:mm a').parse(widget.data.eventTime);
      selectedTime = TimeOfDay.fromDateTime(parsedTime);
    } catch (e) {
      // Handle parsing error - set to current time as fallback
      selectedTime = TimeOfDay.now();
      print('Error parsing time: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize categoricals here where context is available
    categoricals = [
      CategoricalData(
          id: 'Sports',
          name: local_sport,
          icon: Icons.sports_soccer_outlined,
          imagePath: ImagesPath.SportsDark),
      CategoricalData(
          id: 'Birthday',
          name: local_birthday,
          icon: Icons.cake_outlined,
          imagePath: ImagesPath.BirthdayDark),
      CategoricalData(
          id: 'Meeting',
          name: local_meeting,
          icon: Icons.meeting_room_outlined,
          imagePath: ImagesPath.MeetingDark),
      CategoricalData(
          id: 'Gaming',
          name: local_gaming,
          icon: Icons.videogame_asset_outlined,
          imagePath: ImagesPath.GamingDark),
      CategoricalData(
          id: 'Eating',
          name: local_eating,
          icon: Icons.fastfood_outlined,
          imagePath: ImagesPath.EatingDark),
      CategoricalData(
          id: 'Holiday',
          name: local_holiday,
          icon: Icons.beach_access_outlined,
          imagePath: ImagesPath.HoildayDark),
      CategoricalData(
          id: 'WorkShop',
          name: local_workshop,
          icon: Icons.work_outline,
          imagePath: ImagesPath.WorkSpaceDark),
      CategoricalData(
          id: 'BookClub',
          name: local_bookclub,
          icon: Icons.book_outlined,
          imagePath: ImagesPath.BooKdark),
    ];

    // Find the selected index after categoricals is initialized
    selectedIndex = categoricals.indexWhere((cat) => cat.id == widget.data.categoricalImgID);
    // If not found, default to 0
    if (selectedIndex == -1) {
      selectedIndex = 0;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var App = AppLocalizations.of(context)!;
    var provider = Provider.of<Settingprovider>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.89,
        child: ElevatedButton(
          onPressed: _isLoading ? null : updateEvent,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            backgroundColor: ColorsApp.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  App.update_event,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.white),
                ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorsApp.blue),
        title: Text(App.event_edit, style: TextStyle(color: ColorsApp.blue)),
        backgroundColor:  provider.isdDarkMode ? ColorsApp.blueDark : ColorsApp.bluelight,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: categoricals.isNotEmpty
                      ? Image(
                          image: AssetImage(categoricals[selectedIndex].imagePath),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                categoricals.isNotEmpty
                    ? DefaultTabController(
                        length: categoricals.length,
                        child: TabBar(
                          onTap: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          dividerColor: Colors.transparent,
                          labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                          indicator: const BoxDecoration(),
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          tabs: categoricals
                              .map((cat) => Tab(
                                  child: CustomTabsEvents(
                                    cat: cat,
                                    isSelected: selectedIndex == categoricals.indexOf(cat),
                                  )))
                              .toList(),
                        ),
                      )
                    : const SizedBox(
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                const SizedBox(height: 16),
                Text(App.title),
                const SizedBox(height: 8),
                Customtextform(
                  prefixIcon: Icons.edit_note,
                  labelText: App.event_title,
                  controller: titleController,
                  valitor: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(App.description),
                const SizedBox(height: 8),
                Customtextform(
                  valitor: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  controller: descriptionController,
                  labelText: App.event_description,
                  maxlines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                     Icon(Icons.calendar_month_outlined , color: provider.isdDarkMode ? Colors.white : Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      App.event_date,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold
                          ,color: provider.isdDarkMode ? Colors.white : Colors.black,
                          ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: getCurrentDate,
                      child: Text(
                        selecteddate == null
                            ? 'Select Date'
                            : selecteddate.toString().split(' ')[0],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ColorsApp.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                     Icon(Icons.watch_later_outlined,color: provider.isdDarkMode ? Colors.white : Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      App.event_time,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold
                          
                          ,color: provider.isdDarkMode ? Colors.white : Colors.black),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: getCurrentTime,
                      child: Text(
                        selectedTime == null
                            ? 'Select Time'
                            : selectedTime!.format(context),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ColorsApp.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement location selection
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    backgroundColor: ColorsApp.bluelight,
                    foregroundColor: ColorsApp.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: ColorsApp.blue, width: 1.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorsApp.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.my_location_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        App.egypt_Cairo,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ColorsApp.blue, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                       Icon(Icons.arrow_forward_ios_outlined,
                          color: Colors.grey, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selecteddate == null || selectedTime == null) {
      _showSnackBar('Please select date and time.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var eventData = EventData(
        id: widget.data.id,
        enentTitle: titleController.text.trim(),
        eventDescription: descriptionController.text.trim(),
        eventDate: selecteddate!,
        eventTime: selectedTime!.format(context),
        categoricalImg: categoricals[selectedIndex].imagePath,
        categoricalImgID: categoricals[selectedIndex].id,
       
      );

      bool result = await FirebaseFirestoreUtils.updateEvent(eventData);

      if (mounted) {
        if (result) {
          _showSnackBar('Event updated successfully!');
          Navigator.pop(context);
        } else {
          _showSnackBar('Failed to update event. Please try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error updating event: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void getCurrentDate() {
    showDatePicker(
      context: context,
      initialDate: selecteddate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((value) {
      if (value != null) {
        setState(() {
          selecteddate = value;
          
        });
      }
    });
  }

  void getCurrentTime() {
    showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          selectedTime = value;
           selecteddate = DateTime(
            selecteddate?.year ?? DateTime.now().year,
            selecteddate?.month ?? DateTime.now().month,
            selecteddate?.day ?? DateTime.now().day,
            value.hour,
            value.minute,
          );
        });
      }
    });
  }

  // Localization getters
  get local_sport => AppLocalizations.of(context)!.sports;
  get local_birthday => AppLocalizations.of(context)!.birthday;
  get local_meeting => AppLocalizations.of(context)!.meeting;
  get local_workshop => AppLocalizations.of(context)!.workshop;
  get local_gaming => AppLocalizations.of(context)!.gaming;
  get local_eating => AppLocalizations.of(context)!.eating;
  get local_holiday => AppLocalizations.of(context)!.hoilday;
  get local_bookclub => AppLocalizations.of(context)!.bookClub;
}
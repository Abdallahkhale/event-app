import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/Assets/Icons/iconsPath.dart';
import 'package:evently/Core/Assets/Images/Imagespath.dart';
import 'package:evently/Core/Custom/Custom_tabs.dart';
import 'package:evently/Core/Custom/Custom_tabs_events.dart';
import 'package:evently/Core/Custom/Customtextform.dart';
import 'package:evently/Core/manager/app_manger.dart';
import 'package:evently/Core/models/categorical_data.dart';
import 'package:evently/Core/models/event_data.dart';
import 'package:evently/Core/settingProvider.dart';
import 'package:evently/Core/utils/firebase_firestores_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Createevent extends StatefulWidget {
  const Createevent({super.key});

  @override
  State<Createevent> createState() => _CreateeventState();
}

class _CreateeventState extends State<Createevent> {
  List<CategoricalData> categoricals = [];

  void didChangeDependencies() {
    super.didChangeDependencies();
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
  }
   
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selecteddate;
  int selectedIndex = 0;
  TimeOfDay? selectedTime;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AppProvider? appProvider;
  
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appProvider!.getlocation();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<Settingprovider>(context);
    var App = AppLocalizations.of(context)!;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.89,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _createEvent,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            backgroundColor: ColorsApp.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )
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
                  App.add_event, 
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)
                ),
        ),
      ),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme:  IconThemeData(color: ColorsApp.blue),
        title:  Text(App.createEvent, style: TextStyle(color: ColorsApp.blue)),
        backgroundColor:provider.isdDarkMode?ColorsApp.blueDark :   ColorsApp.bluelight,
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
                  child: Image(
                    image: AssetImage(categoricals[selectedIndex].imagePath),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                DefaultTabController(
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
                    tabs: categoricals.map((cat) => Tab(
                      child: CustomTabsEvents(
                        cat: cat,
                        isSelected: selectedIndex == categoricals.indexOf(cat),
                      )
                    )).toList(),
                  )
                ),
                const SizedBox(height: 16),
                 Text(App.event_title,
                  style: TextStyle(
                    color: provider.isdDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Customtextform(
                  prefixIcon: Icons.edit_note,
                  labelText: App.event_title,
                  controller: titleController,
                  valitor: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return App.please_entertitle;
                    }
                    return null;
                  }
                ),
                const SizedBox(height: 16),
                 Text(App.event_descrption,
                  style: TextStyle(
                    color: provider.isdDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Customtextform(
                  valitor: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return App.please_enterdescription;
                    }
                    return null;
                  }, 
                  controller: descriptionController,  
                  labelText: App.event_descrption,
                  maxlines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                     Icon(Icons.calendar_month_outlined,color: provider.isdDarkMode ? Colors.white : Colors.black,),
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
                            ? App.select_date
                            : selecteddate.toString().split(' ')[0],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ColorsApp.blue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                     Icon(Icons.watch_later_outlined,
                    color: provider.isdDarkMode ? Colors.white : Colors.black,),
                    const SizedBox(width: 8),
                    Text(
                      App.event_time, 
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: provider.isdDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: getCurrentTime,
                      child: Text(
                        selectedTime == null 
                            ? App.select_time
                            : selectedTime!.format(context),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ColorsApp.blue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, 'chooseEventLocation');
                    
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    backgroundColor: ColorsApp.bluelight,
                    foregroundColor: ColorsApp.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: ColorsApp.blue, width: 1.5)
                    )
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
                       Consumer<AppProvider>(
  builder: (context, provider, child) {
    // If no location is selected
    if (provider.selectedLocation == null) {
      return Text(
        App.select_eventlocation,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: ColorsApp.blue,
          fontWeight: FontWeight.bold
        ),
      );
    }
    
    // If address is loading
    if (provider.isLoadingAddress) {
      return Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: ColorsApp.blue,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Loading address...',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: ColorsApp.blue,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      );
    }
    
    // Display the address or coordinates as fallback
    String displayText = provider.selectedAddress ?? 
        " ";
    
    
    return Expanded(
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: ColorsApp.blue,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  },
),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 16),
                      ],
                    ),
                  )
                
                 ,SizedBox(height: 80),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selecteddate == null || selectedTime == null) {
      _showSnackBar(AppLocalizations.of(context)!.please_selectdatetime);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var eventData = EventData(
        enentTitle: titleController.text.trim(),
        eventDescription: descriptionController.text.trim(),
        eventDate: selecteddate!,
        eventTime: selectedTime!.format(context),
        categoricalImg: categoricals[selectedIndex].imagePath,
        categoricalImgID: categoricals[selectedIndex].id,
        isFavorite: false,
        location: appProvider!.selectedAddress ?? 
                  "",
        latitude: appProvider!.getLatitude ?? 0.0,
        longitude: appProvider!.getLongitude ?? 0.0,
        
      );

      bool result = await FirebaseFirestoreUtils.createEvent(eventData);

      if (mounted) {
        if (result) {
          _showSnackBar(AppLocalizations.of(context)!.event_addedsuccessfully);
          Navigator.pop(context);
        } else {
          _showSnackBar(AppLocalizations.of(context)!.event_failedtryagain);
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error creating event: ${e.toString()}');
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
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
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
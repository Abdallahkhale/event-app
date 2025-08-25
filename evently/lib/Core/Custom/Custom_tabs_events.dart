import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:evently/Core/models/categorical_data.dart';
import 'package:flutter/material.dart';

class CustomTabsEvents extends StatefulWidget {
  const CustomTabsEvents({super.key, required this.cat,required this.isSelected});
  final CategoricalData cat;
  
  final bool isSelected;

  @override
  State<CustomTabsEvents> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabsEvents> {
  

  @override
  Widget build(BuildContext context) {
    return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.isSelected ?ColorsApp.blue: ColorsApp.bluelight,
                      border: Border.all(color: ColorsApp.blue, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(widget.cat.icon , color:  widget.isSelected ?Colors.white: ColorsApp.blue,),
                        const SizedBox(width: 5,),
                        Text(widget.cat.name, 
                        style: Theme.of(context).textTheme.titleMedium?.
                        copyWith(color: widget.isSelected ? Colors.white:ColorsApp.blue) ,)
                      ],
                    ),
                  );
  }
}
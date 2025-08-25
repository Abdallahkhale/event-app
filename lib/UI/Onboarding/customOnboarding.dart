import 'package:evently/Core/Assets/Color/Colors.dart';
import 'package:flutter/material.dart';

class Customonboarding extends StatelessWidget {
  const Customonboarding({super.key, required this.title, required this.subtitle, required this.image});
  final String title ;
  final String subtitle ;
  final String image ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
                    image,
                    width: 330,
                    height: 330,
                  ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(

              color: ColorsApp.blue
            ),
          )
      
          ,const SizedBox(height: 20),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.start,
          ),
         
        ],
      ),

    );
  }
}

import 'package:evently/Core/settingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customtextform extends StatefulWidget {
  const Customtextform({
    super.key,
    this.labelText,
    this.prefixIcon,
    this.ispassword = false,
    this.minline,
    this.maxlines,
    this.controller, 
    this.valitor,
  });
  
  final String? labelText;
  final IconData? prefixIcon;
  final bool ispassword;
  final int? maxlines;
  final int? minline;
  final TextEditingController? controller;
  final String? Function(String?)? valitor; // Fixed return type

  @override
  State<Customtextform> createState() => _CustomtextformState();
}

class _CustomtextformState extends State<Customtextform> {
  bool _ishidden = true; // Made it a state variable instead of widget property
  @override
  Widget build(BuildContext context) {
  var provider = Provider.of<Settingprovider>(context);
    return TextFormField(
      validator: widget.valitor,
      controller: widget.controller,
      textAlign: TextAlign.start,
      obscureText: widget.ispassword ? _ishidden : false,
      maxLines: widget.ispassword ? 1 : widget.maxlines,
      minLines: widget.ispassword ? 1 : widget.minline,
      decoration: InputDecoration(
        hintStyle:  TextStyle(fontSize: 14 ,color: provider.isdDarkMode ? Colors.white : Colors.black), // Increased font size for better readability
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        // Normal border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        ),
        
        // Enabled border (when not focused)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blue, width: 1.0),
        ),
        
        // Focused border
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        
        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        
        // Focused error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        
        prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon , color: 
         provider.isdDarkMode ? Colors.white : Colors.grey,
        ) : null,
        labelText: widget.labelText,
        labelStyle:  TextStyle(fontSize: 16, color:
        
        provider.isdDarkMode ?Colors.white : Colors.grey),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        alignLabelWithHint: true,
       
        suffixIcon: widget.ispassword
            ? IconButton(
                icon: Icon(
                  _ishidden 
                    ? Icons.visibility_off_outlined 
                    : Icons.visibility_outlined
                ),
                onPressed: () {
                  setState(() {
                    _ishidden = !_ishidden;
                  });
                },
              )
            : null,
      ),
    );
  }
}
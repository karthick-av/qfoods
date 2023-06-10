import 'package:flutter/material.dart';


class BottomSheetScreen extends StatefulWidget {
  
  const BottomSheetScreen({super.key});

  @override
  _BottomSheetScreenState createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                  ),
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Phone No.",
                  ),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: 50,
                ),
                // DropdownButtonFormField(
                //   onChanged: (v) {
                  
                //   },
                //   value: "",
                //   decoration: InputDecoration(
                //     labelText: "Contact Group",
                //   ),
                //   items: ContactGroup.values
                //       .map((e) => DropdownMenuItem(
                //             child: Text(e.name),
                //             value: e,
                //           ))
                //       .toList(),
                // ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    child: Text("Add new contact"),
                    onPressed: () {
                     
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
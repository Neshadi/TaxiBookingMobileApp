import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../driver_global/global.dart';
import '../selection_screen.dart';

class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({super.key});
  @override
  _DriverProfilePageState createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController phoneTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController vehicleNumberTextEditingController =
      TextEditingController();

  String? selectedServiceType;
  String? selectedVehicleType;
  String? selectedWeightRange;

  final List<String> serviceTypes = [
    "Transport",
    "General",
    "Car Parts",
    "Food Items",
    "Furniture",
    "Construction"
  ];
  final List<String> vehicleTypes = ["Car", "Motorbike", "Lorry", "Truck"];
  final List<String> weightRanges = [
    "< 1 kg",
    "1-5 kg",
    "5-10 kg",
    "10-20 kg",
    "> 20 kg"
  ];

  String email = "driver@example.com";

  final _formKey = GlobalKey<FormState>();

  Future<void> logout(BuildContext context) async {
    // Sign out from Firebase
    await firebaseAuth.signOut();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => const UserSelection()));
  }

  Future<void> readCurrentDriverInformation() async {
    currentUser = firebaseAuth.currentUser;
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        var driverData = snap.snapshot.value as Map;
        onlineDriverData.id = driverData["id"];
        onlineDriverData.name = driverData["name"];
        onlineDriverData.phone = driverData["phone"];
        onlineDriverData.email = driverData["email"];
        onlineDriverData.vehicle_number =
            driverData["vehicle_details"]["number"];
        onlineDriverData.service_type =
            driverData["vehicle_details"]["service"];
        onlineDriverData.vehicle_type = driverData["vehicle_details"]["type"];
        onlineDriverData.weight_capacity =
            driverData["vehicle_details"]["capacity"];

        // Populate the text editing controllers
        setState(() {
          nameTextEditingController.text = onlineDriverData.name ?? '';
          phoneTextEditingController.text = onlineDriverData.phone ?? '';
          emailTextEditingController.text = onlineDriverData.email ?? '';
          vehicleNumberTextEditingController.text =
              onlineDriverData.vehicle_number ?? '';
          selectedServiceType = onlineDriverData.service_type;
          selectedVehicleType = onlineDriverData.vehicle_type;
          selectedWeightRange = onlineDriverData.weight_capacity;
        });
      }
    });
  }

  Future<void> updateProfile() async {
    Map<String, dynamic> driverData = {
      "name": nameTextEditingController.text.trim(),
      "phone": phoneTextEditingController.text.trim(),
      "vehicle_details": {
        "number": vehicleNumberTextEditingController.text.trim(),
        "service": selectedServiceType,
        "type": selectedVehicleType,
        "capacity": selectedWeightRange,
      },
    };

    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentUser!.uid);

    await driverRef.update(driverData).then((_) {
      // Show a confirmation message or do something after the update
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully.")));
    });
  }

  @override
  void initState() {
    super.initState();
    readCurrentDriverInformation();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: const Text(
          "Driver Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 5,
        centerTitle: true,
        backgroundColor: darkTheme ? Colors.black : Colors.amber.shade400,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Info",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Full Name
                ListTile(
                  leading: Icon(Icons.person,
                      color: darkTheme ? Colors.white : Colors.amber.shade400),
                  title: const Text(
                    "Your Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    nameTextEditingController.text.isNotEmpty
                        ? nameTextEditingController.text
                        : "Enter your name",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    String? updatedName = await _editTextField(
                        context, "Your Name", nameTextEditingController.text);
                    if (updatedName != null) {
                      setState(() {
                        nameTextEditingController.text = updatedName;
                      });
                    }
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                // Email Address
                ListTile(
                  leading: Icon(Icons.email,
                      color: darkTheme ? Colors.white : Colors.amber.shade400),
                  title: const Text(
                    "Email Address",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    emailTextEditingController.text.isNotEmpty
                        ? emailTextEditingController.text
                        : "email not found",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                // Mobile Number
                ListTile(
                  leading: Icon(Icons.phone,
                      color: darkTheme ? Colors.white : Colors.amber.shade400),
                  title: const Text(
                    "Mobile Number",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    phoneTextEditingController.text.isNotEmpty
                        ? phoneTextEditingController.text
                        : "Enter your mobile number",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    String? updatedPhone = await _editTextField(context,
                        "Mobile Number", phoneTextEditingController.text);
                    if (updatedPhone != null) {
                      setState(() {
                        phoneTextEditingController.text = updatedPhone;
                      });
                    }
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Vehicle Info",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Vehicle Number
                ListTile(
                  leading: Icon(Icons.directions_car,
                      color: darkTheme ? Colors.white : Colors.amber.shade400),
                  title: const Text(
                    "Vehicle Number",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  subtitle: Text(
                    vehicleNumberTextEditingController.text.isNotEmpty
                        ? vehicleNumberTextEditingController.text
                        : "Enter your vehicle number",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    String? updatedVehicleNumber = await _editTextField(
                        context,
                        "Vehicle Number",
                        vehicleNumberTextEditingController.text);
                    if (updatedVehicleNumber != null) {
                      setState(() {
                        vehicleNumberTextEditingController.text =
                            updatedVehicleNumber;
                      });
                    }
                  },
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                // Service Type Dropdown
                buildDropdownField(Icons.directions_car, "Service Type",
                    serviceTypes, selectedServiceType, (newValue) {
                  setState(() {
                    selectedServiceType = newValue;
                  });
                }),

                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                // Vehicle Type Dropdown
                buildDropdownField(Icons.directions_car, "Vehicle Type",
                    vehicleTypes, selectedVehicleType, (newValue) {
                  setState(() {
                    selectedVehicleType = newValue;
                  });
                }),

                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                // Weight Range Dropdown
                buildDropdownField(Icons.line_weight, "Weight Range",
                    weightRanges, selectedWeightRange, (newValue) {
                  setState(() {
                    selectedWeightRange = newValue;
                  });
                }),

                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                // Update Profile Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: SizedBox(
                      width: 300, // Set a fixed width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              darkTheme ? Colors.grey : Colors.amber.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateProfile();
                          }
                        },
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),

                // Log out Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: SizedBox(
                      width: 300, // Set a fixed width
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              darkTheme ? Colors.grey : Colors.amber.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          logout(context);
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _editTextField(
      BuildContext context, String title, String initialValue) {
    TextEditingController controller =
        TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: title,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        );
      },
    );
  }
}

Widget buildDropdownField(IconData icon, String label, List<String> items,
    String? selectedItem, Function(String?) onChanged) {
  return ListTile(
    leading: Icon(icon, color: Colors.amber.shade400), // Leading icon color
    title: DropdownButtonFormField<String>(
      value: selectedItem,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(color: Colors.white), // Dropdown item color
          ),
        );
      }).toList(),
      onChanged: onChanged,
      dropdownColor: Colors.black, // Dropdown menu background color
      style: const TextStyle(color: Colors.white), // Selected value text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white, // Label text color
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // Underline border color
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.amber), // Focused border color
        ),
      ),
    ),
  );
}

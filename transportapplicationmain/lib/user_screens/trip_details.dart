import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main_screen.dart';

class TripDetails extends StatefulWidget {
  final String? category;

  const TripDetails({super.key, required this.category});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  final TextEditingController specialInstructionsTextEditingController =
      TextEditingController();

  // Variables for storing selected dropdown values
  late String selectedServiceType = widget.category ?? "General";
  String? capacity;
  String? selectedWeight;
  String? instructions;

  // Sample data for dropdowns
  final List<String> serviceTypes = [
    "General",
    "Passenger Transport",
    "Load Transport",
    "Food Items Transport",
  ];
  final List<String> capacities = [
    "1 person",
    "2 persons",
    "3 persons",
    "4 persons",
    "5 persons",
    "5-10 persons"
  ];
  final List<String> weights = [
    "< 1 kg",
    "1-5 kg",
    "5-10 kg",
    "10-20 kg",
    "> 20 kg"
  ];

  // Function to handle form submission
  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        instructions = specialInstructionsTextEditingController.text;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserMainScreen(
            serviceType: selectedServiceType,
            capacity: capacity,
            weight: selectedWeight,
            instructions: instructions,
          ),
        ),
      );
    }
  }

  // GlobalKey to manage form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Trip Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 5,
        centerTitle: true,
        backgroundColor: darkTheme ? Colors.black : Colors.amber.shade400,
        iconTheme: IconThemeData(
          color: darkTheme ? Colors.amber.shade400 : Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Service Type",
                    prefixIcon: Icon(Icons.build,
                        color: darkTheme ? Colors.amber.shade400 : Colors.grey),
                    filled: true,
                    fillColor:
                        darkTheme ? Colors.black45 : Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  value: selectedServiceType,
                  items: serviceTypes.map((service) {
                    return DropdownMenuItem(
                      value: service,
                      child:
                          Text(service, style: TextStyle(color: Colors.grey)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedServiceType = newValue!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a service type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Required Capacity",
                    prefixIcon: Icon(Icons.directions_car,
                        color: darkTheme ? Colors.amber.shade400 : Colors.grey),
                    filled: true,
                    fillColor:
                        darkTheme ? Colors.black45 : Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  items: capacities.map((capacity) {
                    return DropdownMenuItem(
                      value: capacity,
                      child:
                          Text(capacity, style: TextStyle(color: Colors.grey)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      capacity = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a vehicle type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: "Weight(Load Transport Only)",
                    prefixIcon: Icon(Icons.scale,
                        color: darkTheme ? Colors.amber.shade400 : Colors.grey),
                    filled: true,
                    fillColor:
                        darkTheme ? Colors.black45 : Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  items: weights.map((weight) {
                    return DropdownMenuItem(
                      value: weight,
                      child: Text(weight, style: TextStyle(color: Colors.grey)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedWeight = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a weight';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: specialInstructionsTextEditingController,
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                  decoration: InputDecoration(
                    hintText: "Special Instructions",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor:
                        darkTheme ? Colors.black45 : Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter any special instructions';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        darkTheme ? Colors.grey : Colors.amber.shade400,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: _submit,
                  child: const Text("Confirm",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
                const SizedBox(height: 15),
                Image.asset(
                  "images/Car2.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    specialInstructionsTextEditingController.dispose();
    super.dispose();
  }
}

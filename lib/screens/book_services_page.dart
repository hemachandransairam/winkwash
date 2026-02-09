import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:wink_dupe/screens/select_services_page.dart";
import "package:wink_dupe/screens/select_vehicle_screen.dart";
import '../widgets/custom_widgets.dart';

class BookServicesPage extends StatefulWidget {
  const BookServicesPage({super.key});

  @override
  State<BookServicesPage> createState() => _BookServicesPageState();
}

class _BookServicesPageState extends State<BookServicesPage> {
  int _currentStep = 0;

  // Vehicle selection
  String? _selectedVehicleType;

  // Time selection
  DateTime _selectedDate = DateTime.now();
  DateTime _rowStartDate = DateTime.now();
  String _selectedTime = "";

  // Address selection
  final TextEditingController _addressController = TextEditingController();
  String? _addressLabel;
  final List<Map<String, String>> _savedAddresses = [];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      // Navigate to services page
      if (_selectedVehicleType != null &&
          _selectedTime.isNotEmpty &&
          _addressController.text.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => SelectServicesPage(
                  selectedDate: _selectedDate,
                  selectedTime: _selectedTime,
                  address: _addressController.text,
                  vehicle: {
                    'type': _selectedVehicleType!,
                    'name': _selectedVehicleType!,
                    'brand': '',
                  },
                ),
          ),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  bool _canContinue() {
    switch (_currentStep) {
      case 0:
        return _selectedVehicleType != null;
      case 1:
        return _selectedTime.isNotEmpty;
      case 2:
        return true; // Services step handled in separate page
      case 3:
        return _addressController.text.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF01102B)),
          onPressed: _previousStep,
        ),
        title: const Text(
          "Book Service",
          style: TextStyle(
            color: Color(0xFF01102B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Stepper indicator
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                _buildStepIndicator(0, Icons.directions_car, "Vehicle"),
                _buildStepLine(0),
                _buildStepIndicator(1, Icons.access_time, "Time"),
                _buildStepLine(1),
                _buildStepIndicator(2, Icons.home_repair_service, "Services"),
                _buildStepLine(2),
                _buildStepIndicator(3, Icons.location_on, "Address"),
              ],
            ),
          ),
          // Content
          Expanded(child: _buildStepContent()),
          // Continue button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: buildPrimaryButton(
              text: _currentStep == 3 ? "Continue to Services" : "Continue",
              onTap: _canContinue() ? _nextStep : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, IconData icon, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color:
                isActive || isCompleted
                    ? const Color(0xFF01102B)
                    : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive || isCompleted ? Colors.white : Colors.grey[600],
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? const Color(0xFF01102B) : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    final isCompleted = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        color: isCompleted ? const Color(0xFF01102B) : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildVehicleSelection();
      case 1:
        return _buildTimeSelection();
      case 2:
        return _buildServicesPlaceholder();
      case 3:
        return _buildAddressSelection();
      default:
        return Container();
    }
  }

  Widget _buildVehicleSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Your Vehicle",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF01102B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Choose your vehicle brand and type",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Show selected vehicle or button to select
          if (_selectedVehicleType != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF01102B), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 60,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      _getVehicleImage(_selectedVehicleType!),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.directions_car,
                          color: Color(0xFF01102B),
                          size: 32,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedVehicleType!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF01102B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Starting from ₹${_getVehiclePrice(_selectedVehicleType!)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF01102B),
                    size: 28,
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No vehicle selected",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Button to navigate to vehicle selection
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton.icon(
              onPressed: () async {
                // Navigate to SelectVehicleScreen
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectVehicleScreen(),
                  ),
                );

                // Handle returned vehicle data if any
                if (result != null && result is Map<String, String>) {
                  setState(() {
                    _selectedVehicleType = result['carType'];
                  });
                }
              },
              icon: Icon(
                _selectedVehicleType != null ? Icons.edit : Icons.add,
                size: 20,
              ),
              label: Text(
                _selectedVehicleType != null
                    ? "Change Vehicle"
                    : "Select Vehicle",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF01102B),
                side: const BorderSide(color: Color(0xFF01102B), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getVehicleImage(String type) {
    if (type.toLowerCase().contains('sedan')) {
      return 'assets/Sedan.png';
    } else if (type.toLowerCase().contains('suv') ||
        type.toLowerCase().contains('muv')) {
      return 'assets/SUV.png';
    } else if (type.toLowerCase().contains('hatchback')) {
      return 'assets/hatchback.png';
    }
    return 'assets/Sedan.png';
  }

  int _getVehiclePrice(String type) {
    if (type.toLowerCase().contains('sedan')) {
      return 1169;
    } else if (type.toLowerCase().contains('suv') ||
        type.toLowerCase().contains('muv')) {
      return 1299;
    } else if (type.toLowerCase().contains('hatchback')) {
      return 1079;
    }
    return 1079;
  }

  Widget _buildTimeSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Date & Time",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF01102B),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF01102B),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                  _rowStartDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF01102B),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    DateFormat('d MMMM, EEEE').format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF01102B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Time Slot",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF01102B),
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children:
                [
                  "9:00 AM",
                  "10:00 AM",
                  "11:00 AM",
                  "12:00 PM",
                  "1:00 PM",
                  "2:00 PM",
                  "3:00 PM",
                  "4:00 PM",
                  "5:00 PM",
                  "6:00 PM",
                  "7:00 PM",
                  "8:00 PM",
                ].map((time) {
                  final isSelected = _selectedTime == time;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTime = time),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF01102B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF01102B)
                                  : Colors.grey[300]!,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFF01102B),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesPlaceholder() {
    return const Center(
      child: Text(
        "Services selection will be on next page",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildAddressSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Location",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF01102B),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: "Enter your address",
              prefixIcon: const Icon(
                Icons.location_on,
                color: Color(0xFF01102B),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF01102B),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              setState(() {
                _addressController.text = "Paris corner, Puducherry";
              });
            },
            child: const Row(
              children: [
                Icon(Icons.my_location, size: 18, color: Color(0xFF01102B)),
                SizedBox(width: 8),
                Text(
                  "Use my current location",
                  style: TextStyle(
                    color: Color(0xFF01102B),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children:
                ["Home", "Office"].map((label) {
                  final isSelected = _addressLabel == label;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => _addressLabel = label),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF01102B)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF01102B)
                                    : Colors.grey[300]!,
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFF01102B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  String? _selectedVehicleBrand;
  String? _selectedVehicleName;
  List<Map<String, dynamic>> _savedVehicles = [];
  bool _isLoadingVehicles = true;

  // Time selection
  DateTime _selectedDate = DateTime.now();
  DateTime _rowStartDate = DateTime.now();
  String _selectedTime = "";

  // Address selection
  final TextEditingController _addressController = TextEditingController();
  String? _addressLabel;
  List<Map<String, dynamic>> _savedAddresses = [];
  bool _isLoadingAddresses = true;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
    _fetchAddresses();
  }

  Future<void> _fetchVehicles() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await Supabase.instance.client
            .from('vehicles')
            .select()
            .eq('user_id', user.id);
        setState(() {
          _savedVehicles = List<Map<String, dynamic>>.from(data);
          _isLoadingVehicles = false;
        });
      } catch (e) {
        setState(() => _isLoadingVehicles = false);
      }
    } else {
      setState(() => _isLoadingVehicles = false);
    }
  }

  Future<void> _fetchAddresses() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await Supabase.instance.client
            .from('addresses')
            .select()
            .eq('user_id', user.id);
        setState(() {
          _savedAddresses = List<Map<String, dynamic>>.from(data);
          _isLoadingAddresses = false;
        });
      } catch (e) {
        setState(() => _isLoadingAddresses = false);
      }
    } else {
      setState(() => _isLoadingAddresses = false);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else if (_currentStep == 2) {
      // Navigate to services page after address selection
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
                  addressLabel: _addressLabel ?? "Selected Address",
                  vehicle: {
                    'type': _selectedVehicleType!,
                    'name': _selectedVehicleName ?? '',
                    'brand': _selectedVehicleBrand ?? '',
                  },
                ),
          ),
        );
      }
    } else {
      setState(() => _currentStep++);
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
        return _addressController.text.isNotEmpty;
      case 3:
        return true; // Services step handled in separate page
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
        leading:
            _currentStep > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF01102B)),
                  onPressed: _previousStep,
                )
                : null,
        automaticallyImplyLeading: false,
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
                _buildStepIndicator(2, Icons.location_on, "Address"),
                _buildStepLine(2),
                _buildStepIndicator(3, Icons.home_repair_service, "Services"),
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
              text: _currentStep == 2 ? "Continue to Services" : "Continue",
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
        return _buildAddressSelection();
      case 3:
        return _buildServicesPlaceholder();
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
            "Choose from your saved vehicles or add a new one",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Loading state
          if (_isLoadingVehicles)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          // Show saved vehicles
          else if (_savedVehicles.isNotEmpty)
            ..._savedVehicles.map((vehicle) {
              final isSelected =
                  _selectedVehicleType == vehicle['type'] &&
                  _selectedVehicleBrand == vehicle['brand'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVehicleType = vehicle['type'];
                    _selectedVehicleBrand = vehicle['brand'];
                    _selectedVehicleName = vehicle['name'];
                    // Automatically move to next step
                    _currentStep = 1;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF01102B)
                              : Colors.transparent,
                      width: 2,
                    ),
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
                          _getVehicleImage(vehicle['type']),
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
                              vehicle['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF01102B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${vehicle['brand']} • ${vehicle['type']}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF01102B),
                          size: 28,
                        ),
                    ],
                  ),
                ),
              );
            })
          // Empty state
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
                    "No vehicles saved yet",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add your first vehicle to get started",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          // Button to add new vehicle
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

                // Refresh vehicles list after adding
                if (result != null) {
                  await _fetchVehicles();
                  // Auto-select the newly added vehicle
                  if (result is Map<String, String>) {
                    setState(() {
                      _selectedVehicleType = result['carType'];
                      _selectedVehicleBrand = result['brand'];
                      _selectedVehicleName = result['name'];
                      // Automatically move to next step
                      _currentStep = 1;
                    });
                  }
                }
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                "Add New Vehicle",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

          // Date label
          const Text(
            "Date",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF01102B),
            ),
          ),
          const SizedBox(height: 12),

          // Horizontal scrollable date selector
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected =
                    DateFormat('yyyy-MM-dd').format(_selectedDate) ==
                    DateFormat('yyyy-MM-dd').format(date);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF01102B) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isSelected
                                ? const Color(0xFF01102B)
                                : Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date).toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('d').format(date),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFF01102B),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Time label
          const Text(
            "Time",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF01102B),
            ),
          ),
          const SizedBox(height: 12),

          // Time slots grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                [
                  "9:00 AM",
                  "10:00 AM",
                  "11:00 AM",
                  "12:00 PM",
                  "3:00 PM",
                  "5:00 PM",
                ].map((time) {
                  final isSelected = _selectedTime == time;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTime = time),
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 64) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF01102B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected
                                  ? const Color(0xFF01102B)
                                  : Colors.grey[300]!,
                          width: 1,
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permissions are permanently denied, we cannot request permissions.',
            ),
          ),
        );
      }
      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (mounted) Navigator.pop(context); // Close loading

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
        setState(() {
          _addressLabel = "Current";
          _addressController.text = address;
        });
      }
    } catch (e) {
      if (mounted) Navigator.pop(context); // Close loading
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      }
    }
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

          // Address Display & Edit Area
          if (_addressLabel != null && _addressLabel != "Current")
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Selected Address",
                      hintText: "Enter address...",
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
                  const SizedBox(height: 12),
                  // Save Address Button
                  if (_addressLabel == "New Address")
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_addressController.text.isNotEmpty) {
                            // Show dialog to get label
                            String? label = await showDialog<String>(
                              context: context,
                              builder:
                                  (context) => SimpleDialog(
                                    title: const Text("Select Label"),
                                    children:
                                        ['Home', 'Work', 'Other']
                                            .map(
                                              (l) => SimpleDialogOption(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      l,
                                                    ),
                                                child: Text(l),
                                              ),
                                            )
                                            .toList(),
                                  ),
                            );

                            if (label != null) {
                              final user =
                                  Supabase.instance.client.auth.currentUser;
                              if (user != null) {
                                await Supabase.instance.client
                                    .from('addresses')
                                    .insert({
                                      'user_id': user.id,
                                      'label': label,
                                      'address': _addressController.text,
                                    });
                                await _fetchAddresses();
                                setState(() {
                                  _addressLabel = label;
                                });
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01102B),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Save Address"),
                      ),
                    ),
                ],
              ),
            ),

          // Saved Addresses from DB
          if (_isLoadingAddresses)
            const Center(child: CircularProgressIndicator())
          else
            ..._savedAddresses.map((addr) {
              final isSelected =
                  _addressLabel == addr['label'] &&
                  _addressController.text == addr['address'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _addressLabel = addr['label'];
                    _addressController.text = addr['address'];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isSelected
                              ? const Color(0xFF01102B)
                              : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF01102B)
                                    : Colors.grey[400]!,
                            width: 2,
                          ),
                        ),
                        child:
                            isSelected
                                ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF01102B),
                                    ),
                                  ),
                                )
                                : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addr['label'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF01102B),
                              ),
                            ),
                            Text(
                              addr['address'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          onPressed: () {
                            // Enable editing
                          },
                        ),
                    ],
                  ),
                ),
              );
            }),

          const SizedBox(height: 12),

          // Use current location option
          GestureDetector(
            onTap: _getCurrentLocation,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.my_location, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Text(
                    "Use my current location",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

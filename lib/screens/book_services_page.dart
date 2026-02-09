import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_widgets.dart';
import 'booking_summary_page.dart';

class BookServicesPage extends StatefulWidget {
  const BookServicesPage({super.key});

  @override
  State<BookServicesPage> createState() => _BookServicesPageState();
}

class _BookServicesPageState extends State<BookServicesPage> {
  final Set<String> _selectedServices = {};
  DateTime _selectedDate = DateTime.now();
  DateTime _rowStartDate = DateTime.now();
  String _selectedTime = "9:00 AM";

  final TextEditingController _addressController = TextEditingController();
  String? _addressLabel;
  final List<Map<String, String>> _savedAddresses = [];

  final List<Map<String, String>> _savedVehicles = [];
  int? _selectedVehicleIndex;

  final List<Map<String, dynamic>> _availableServices = [
    {"name": "Exterior Cleaning", "icon": Icons.local_car_wash, "price": 299},
    {"name": "Vacuum Cleaning", "icon": Icons.cleaning_services, "price": 199},
    {
      "name": "Interior Cleaning",
      "icon": Icons.airline_seat_recline_extra,
      "price": 399,
    },
    {"name": "Engine Bay Cleaning", "icon": Icons.engineering, "price": 150},
    {"name": "Car Polish Cleaning", "icon": Icons.auto_fix_high, "price": 499},
    {"name": "Tire Cleaning", "icon": Icons.tire_repair, "price": 99},
  ];

  double get _totalPrice {
    double total = 0;
    for (var s in _availableServices) {
      if (_selectedServices.contains(s['name'])) {
        total += s['price'];
      }
    }
    return total;
  }

  void _resetAddressForm() {
    _addressController.clear();
    setState(() {
      _addressLabel = null;
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: buildGlobalAppBar(context: context, title: "Book Services"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: const Text(
              "Select Vehicle",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF01102B),
              ),
            ),
          ),
          Expanded(
            child:
                _savedVehicles.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_car_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No vehicles added yet",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 200,
                            child: buildPrimaryButton(
                              text: "Add Vehicle",
                              onTap: () => _addVehicle((fn) => fn()),
                            ),
                          ),
                        ],
                      ),
                    )
                    : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: _savedVehicles.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _savedVehicles.length) {
                          return GestureDetector(
                            onTap: () => _addVehicle((fn) => fn()),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                          );
                        }
                        final v = _savedVehicles[index];
                        final isSelected = _selectedVehicleIndex == index;
                        return GestureDetector(
                          onTap:
                              () => setState(() {
                                _selectedVehicleIndex = index;
                              }),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF01102B)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.directions_car,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : const Color(0xFF01102B),
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  v['name']!,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : const Color(0xFF01102B),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            child: buildPrimaryButton(
              text: "Continue",
              onTap:
                  _selectedVehicleIndex != null
                      ? () => _showBookingSheet(context)
                      : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              final size = MediaQuery.of(context).size;
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              return Container(
                height: size.height * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                padding: EdgeInsets.fromLTRB(24, 20, 24, 20 + keyboardHeight),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                buildCustomIconButton(
                                  icon: Icons.arrow_back,
                                  onTap: () => Navigator.pop(context),
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "Select Date & Time",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF01102B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF01102B),
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate,
                                  firstDate: DateTime.now().subtract(
                                    const Duration(days: 365),
                                  ),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365),
                                  ),
                                );
                                if (picked != null) {
                                  setModalState(() {
                                    _selectedDate = picked;
                                    _rowStartDate = picked;
                                  });
                                }
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFF01102B),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    DateFormat(
                                      'd MMMM, EEEE',
                                    ).format(_selectedDate),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              height: 90,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F6F6),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 7,
                                itemBuilder: (context, i) {
                                  DateTime date = _rowStartDate.add(
                                    Duration(days: i),
                                  );
                                  return buildDateCircle(
                                    date: date,
                                    isSelected: DateUtils.isSameDay(
                                      date,
                                      _selectedDate,
                                    ),
                                    onTap:
                                        () => setModalState(
                                          () => _selectedDate = date,
                                        ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "Time",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF01102B),
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildTimeGrid(setModalState, size),
                            const SizedBox(height: 25),
                            const Text(
                              "Select Services",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF01102B),
                              ),
                            ),
                            const SizedBox(height: 15),
                            ..._availableServices.map((s) {
                              return buildServiceTile(
                                title: s['name'],
                                icon: s['icon'],
                                isSelected: _selectedServices.contains(
                                  s['name'],
                                ),
                                onTap:
                                    () => setModalState(() {
                                      _selectedServices.contains(s['name'])
                                          ? _selectedServices.remove(s['name'])
                                          : _selectedServices.add(s['name']);
                                    }),
                              );
                            }),
                            const SizedBox(height: 25),
                            const Text(
                              "Select Location",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF01102B),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Autocomplete for location suggestions
                            Autocomplete<String>(
                              optionsBuilder: (
                                TextEditingValue textEditingValue,
                              ) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return [
                                  "Paris corner, Puducherry",
                                  "Anna Salai, Chennai",
                                  "Park Avenue, New York",
                                  "Baker Street, London",
                                ].where((String option) {
                                  return option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  );
                                });
                              },
                              onSelected: (String selection) {
                                setModalState(() {
                                  _addressController.text = selection;
                                });
                              },
                              fieldViewBuilder: (
                                context,
                                controller,
                                focusNode,
                                onFieldSubmitted,
                              ) {
                                if (_addressController.text.isNotEmpty &&
                                    controller.text.isEmpty) {
                                  controller.text = _addressController.text;
                                }
                                return buildLocationInputField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  hint: "Enter your address",
                                );
                              },
                              optionsViewBuilder: (
                                context,
                                onSelected,
                                options,
                              ) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: size.width - 48,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (
                                          BuildContext context,
                                          int index,
                                        ) {
                                          final String option = options
                                              .elementAt(index);
                                          return ListTile(
                                            title: Text(
                                              option,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            onTap: () => onSelected(option),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap:
                                  () => setModalState(
                                    () =>
                                        _addressController.text =
                                            "Paris corner, Puducherry",
                                  ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.near_me,
                                    size: 16,
                                    color: Color(0xFF01102B),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Use my current location",
                                    style: TextStyle(
                                      color: Color(0xFF01102B),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children:
                                  ["Home", "Office"]
                                      .map(
                                        (label) => Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: buildLabelChip(
                                            label: label,
                                            isSelected: _addressLabel == label,
                                            onTap:
                                                () => setModalState(() {
                                                  _addressLabel = label;
                                                }),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            if (_savedAddresses.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              const Text(
                                "Saved Addresses",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF01102B),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ..._savedAddresses.asMap().entries.map((entry) {
                                int index = entry.key;
                                var addr = entry.value;
                                return buildSavedAddressTile(
                                  label: addr['label']!,
                                  address: addr['address']!,
                                  isSelected:
                                      _addressController.text ==
                                      addr['address'],
                                  onTap: () {
                                    setModalState(() {
                                      _addressController.text =
                                          addr['address']!;
                                      _addressLabel = addr['label'];
                                    });
                                  },
                                  onDelete: () {
                                    setModalState(
                                      () => _savedAddresses.removeAt(index),
                                    );
                                    setState(() {});
                                  },
                                );
                              }).toList(),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildPrimaryButton(
                      text: "Confirm Booking",
                      onTap: () {
                        List<String> missingFields = [];
                        if (_selectedTime.isEmpty) missingFields.add("Time");
                        if (_selectedVehicleIndex == null)
                          missingFields.add("Vehicle Details");
                        if (_addressController.text.isEmpty)
                          missingFields.add("Address");

                        if (missingFields.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please fill the following fields: ${missingFields.join(', ')}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        if (_addressController.text.isNotEmpty) {
                          if (_addressLabel != null) {
                            bool exists = _savedAddresses.any(
                              (e) => e['address'] == _addressController.text,
                            );
                            if (!exists) {
                              setState(() {
                                if (_savedAddresses.length >= 2)
                                  _savedAddresses.removeAt(0);
                                _savedAddresses.add({
                                  'label': _addressLabel!,
                                  'address': _addressController.text,
                                });
                              });
                            }
                          }
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BookingSummaryPage(
                                    selectedServices:
                                        _availableServices
                                            .where(
                                              (s) => _selectedServices.contains(
                                                s['name'],
                                              ),
                                            )
                                            .toList(),
                                    totalPrice: _totalPrice,
                                    date: DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(_selectedDate),
                                    time: _selectedTime,
                                    vehicle:
                                        _savedVehicles[_selectedVehicleIndex!],
                                    address: _addressController.text,
                                  ),
                            ),
                          );
                          _resetAddressForm();
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
    );
  }

  void _addVehicle(StateSetter setModalState) {
    String? selectedBrand;

    final brands = [
      {'name': 'BMW', 'logo': 'assets/bmw.png'},
      {'name': 'Ford', 'logo': 'assets/ford.png'},
      {'name': 'MG', 'logo': 'assets/mg.png'},
      {'name': 'Kia', 'logo': 'assets/kia.png'},
      {'name': 'Toyota', 'logo': 'assets/toyota.png'},
      {'name': 'Volkswagen', 'logo': 'assets/vw.png'},
    ];

    // First dialog: Select brand
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Your Car Brand',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF01102B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 400,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.2,
                            ),
                        itemCount: brands.length,
                        itemBuilder: (context, index) {
                          final brand = brands[index];
                          final isSelected = selectedBrand == brand['name'];
                          return GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                selectedBrand = brand['name'];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(
                                          0xFF01102B,
                                        ).withOpacity(0.05)
                                        : Colors.transparent,
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? const Color(0xFF01102B)
                                          : Colors.grey.withOpacity(0.1),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset(
                                brand['logo']!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      brand['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF01102B),
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            selectedBrand == null
                                ? null
                                : () {
                                  Navigator.pop(context);
                                  // Second dialog: Select car type
                                  _showCarTypeDialog(
                                    setModalState,
                                    selectedBrand!,
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01102B),
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color:
                                selectedBrand == null
                                    ? Colors.grey[600]
                                    : Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCarTypeDialog(StateSetter setModalState, String brand) {
    String? selectedCarType;

    final carTypes = [
      {'name': 'Sedan', 'image': 'assets/Sedan.png'},
      {'name': 'SUV or MUV', 'image': 'assets/SUV.png'},
      {'name': 'Hatchback', 'image': 'assets/hatchback.png'},
    ];

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select Your Car Type',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF01102B),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Brand: $brand',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children:
                            carTypes.map((type) {
                              final isTypeSelected =
                                  selectedCarType == type['name'];
                              return GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    selectedCarType = type['name'];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color:
                                          isTypeSelected
                                              ? const Color(0xFF3498DB)
                                              : const Color(0xFFEEEEEE),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.01),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border:
                                              isTypeSelected
                                                  ? Border.all(
                                                    color: const Color(
                                                      0xFF3498DB,
                                                    ),
                                                    width: 1,
                                                  )
                                                  : null,
                                        ),
                                        child: Image.asset(
                                          type['image']!,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Text(
                                          type['name']!,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF333333),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed:
                              selectedCarType == null
                                  ? null
                                  : () {
                                    Navigator.pop(context);
                                    // Auto-generate vehicle name
                                    final vehicleNumber =
                                        _savedVehicles.length + 1;
                                    final vehicleName = _getVehicleName(
                                      vehicleNumber,
                                    );

                                    setModalState(() {
                                      _savedVehicles.add({
                                        'brand': brand,
                                        'type': selectedCarType!,
                                        'name': vehicleName,
                                      });
                                      _selectedVehicleIndex =
                                          _savedVehicles.length - 1;
                                    });
                                    setState(() {});
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF01102B),
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Add Vehicle',
                            style: TextStyle(
                              color:
                                  selectedCarType == null
                                      ? Colors.grey[600]
                                      : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getVehicleName(int number) {
    const names = [
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
    ];
    if (number <= names.length) {
      return 'Car ${names[number - 1]}';
    }
    return 'Car $number';
  }

  Widget _buildTimeGrid(StateSetter setModalState, Size size) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: size.width > 400 ? 3 : 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.8,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ...[
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
        ].map(
          (t) => buildTimeChip(
            time: t,
            isSelected: _selectedTime == t,
            onTap:
                () => setModalState(() {
                  _selectedTime = t;
                }),
          ),
        ),
      ],
    );
  }
}

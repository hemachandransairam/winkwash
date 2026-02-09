import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelectVehicleScreen extends StatefulWidget {
  const SelectVehicleScreen({super.key});

  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  String? selectedBrand;
  String? selectedCarType;

  final List<Map<String, String>> brands = [
    {'name': 'BMW', 'logo': 'assets/bmw.png'},
    {'name': 'Ford', 'logo': 'assets/ford.png'},
    {'name': 'MG', 'logo': 'assets/mg.png'},
    {'name': 'Kia', 'logo': 'assets/kia.png'},
    {'name': 'Toyota', 'logo': 'assets/toyota.png'},
    {'name': 'Volkswagen', 'logo': 'assets/vw.png'},
  ];

  final List<Map<String, String>> carTypes = [
    {'name': 'Sedan', 'image': 'assets/Sedan.png'},
    {'name': 'SUV or MUV', 'image': 'assets/SUV.png'},
    {'name': 'Hatchback', 'image': 'assets/hatchback.png'},
  ];

  void _showCarTypePopup() {
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
                        'Select Your Car Type?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF01102B),
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
                                  setState(() {});
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
                                  : () async {
                                    try {
                                      // Show loading
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:
                                            (context) => const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                      );

                                      // Get current user
                                      final user =
                                          Supabase
                                              .instance
                                              .client
                                              .auth
                                              .currentUser;

                                      if (user != null) {
                                        // Save vehicle to Supabase
                                        await Supabase.instance.client
                                            .from('vehicles')
                                            .insert({
                                              'user_id': user.id,
                                              'name':
                                                  '$selectedBrand $selectedCarType',
                                              'brand': selectedBrand,
                                              'type': selectedCarType,
                                            });
                                      }

                                      // Close loading dialog
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }

                                      // Close car type dialog
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }

                                      // Return to booking page with data
                                      if (context.mounted) {
                                        Navigator.pop(context, {
                                          'brand': selectedBrand,
                                          'carType': selectedCarType,
                                          'name':
                                              '$selectedBrand $selectedCarType',
                                        });
                                      }
                                    } catch (e) {
                                      // Close loading dialog if error
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }

                                      // Show error message
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error saving vehicle: $e',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF01102B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.06;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xFF01102B),
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text(
          'Select Vehicle',
          style: TextStyle(
            color: Color(0xFF01102B),
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFF01102B), size: 20),
                onPressed: () {
                  // Add new vehicle functionality
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Brands',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF01102B),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: size.width > 400 ? 1.3 : 1.1,
                  ),
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    final isSelected = selectedBrand == brand['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedBrand = brand['name'];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF01102B).withOpacity(0.05)
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
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed:
                    selectedBrand == null ? null : () => _showCarTypePopup(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01102B),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

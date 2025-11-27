import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_guard/core/constants/app_colors.dart';
import 'package:ride_guard/core/constants/app_strings.dart';
import 'package:ride_guard/data/models/bike_profile.dart';
import 'package:ride_guard/data/services/storage_service.dart';

class EditBikeProfileScreen extends StatefulWidget {
  final BikeProfile bikeProfile;

  const EditBikeProfileScreen({
    super.key,
    required this.bikeProfile,
  });

  @override
  State<EditBikeProfileScreen> createState() => _EditBikeProfileScreenState();
}

class _EditBikeProfileScreenState extends State<EditBikeProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bikeModelController;
  late TextEditingController _odometerController;
  
  late int _selectedYear;
  DateTime? _lastServiceDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing data
    _bikeModelController = TextEditingController(text: widget.bikeProfile.model);
    _odometerController = TextEditingController(
      text: widget.bikeProfile.currentOdometer.toStringAsFixed(0),
    );
    _selectedYear = widget.bikeProfile.yearOfPurchase;
    _lastServiceDate = widget.bikeProfile.lastServiceDate;
  }

  @override
  void dispose() {
    _bikeModelController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastServiceDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _lastServiceDate = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      // Create updated bike profile
      final updatedProfile = widget.bikeProfile.copyWith(
        model: _bikeModelController.text.trim(),
        yearOfPurchase: _selectedYear,
        lastServiceDate: _lastServiceDate,
        currentOdometer: double.parse(_odometerController.text),
      );

      // Save to storage
      final saved = await StorageService.updateBikeProfile(updatedProfile);

      setState(() {
        _isSaving = false;
      });

      if (saved && mounted) {
        // Return true to indicate success
        Navigator.of(context).pop(true);
      } else if (mounted) {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update bike profile. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Bike Profile'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveChanges,
              tooltip: 'Save Changes',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.info.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Update your bike information to keep track of maintenance and alerts',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Bike Model
              Text(
                AppStrings.bikeModel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bikeModelController,
                decoration: const InputDecoration(
                  hintText: AppStrings.bikeModelHint,
                  prefixIcon: Icon(Icons.motorcycle),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Year of Purchase
              Text(
                AppStrings.yearOfPurchase,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedYear,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                items: List.generate(
                  25,
                  (index) {
                    final year = DateTime.now().year - index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  },
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              
              // Last Service Date
              Text(
                AppStrings.lastServiceDate,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.textLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event, color: AppColors.textSecondary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _lastServiceDate != null
                              ? DateFormat('MMM dd, yyyy').format(_lastServiceDate!)
                              : 'Select date',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: _lastServiceDate != null
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (_lastServiceDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _lastServiceDate = null;
                            });
                          },
                          tooltip: 'Clear date',
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Current Odometer
              Text(
                AppStrings.currentOdometer,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _odometerController,
                decoration: const InputDecoration(
                  hintText: 'e.g., 5000',
                  prefixIcon: Icon(Icons.speed),
                  suffixText: 'km',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.fieldRequired;
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Save Changes'),
                ),
              ),
              const SizedBox(height: 16),
              
              // Cancel Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ride_guard/core/constants/app_colors.dart';
import 'package:ride_guard/core/constants/app_strings.dart';

class BikeSetupScreen extends StatefulWidget {
  const BikeSetupScreen({super.key});

  @override
  State<BikeSetupScreen> createState() => _BikeSetupScreenState();
}

class _BikeSetupScreenState extends State<BikeSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bikeModelController = TextEditingController();
  final _odometerController = TextEditingController();
  
  int _selectedYear = DateTime.now().year;
  DateTime? _lastServiceDate;

  @override
  void dispose() {
    _bikeModelController.dispose();
    _odometerController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _lastServiceDate = picked;
      });
    }
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      // In real app, save to local storage or database
      // For demo, just navigate to dashboard
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bikeSetupTitle),
        automaticallyImplyLeading: false,
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
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryLight.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Enter your bike details to personalize alerts and maintenance tracking',
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
                decoration: InputDecoration(
                  hintText: AppStrings.bikeModelHint,
                  prefixIcon: const Icon(Icons.motorcycle),
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
                      Text(
                        _lastServiceDate != null
                            ? DateFormat('MMM dd, yyyy').format(_lastServiceDate!)
                            : 'Select date',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _lastServiceDate != null
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
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
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(AppStrings.saveAndContinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
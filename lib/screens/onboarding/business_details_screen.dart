import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/inventory_details_screen.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  static const _bgColor = Colors.white;
  static const _fieldFill = Color(0xFFE8D5E3);
  static const _accent = Color(0xFFD84315);
  static const _primary = Color(0xFFFF5722);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  String _selectedBusinessType = 'Cafe';

  final List<String> _businessTypes = [
    'Cafe',
    'Restaurant',
    'Bakery',
    'Fast Food',
    'Hotel',
    'Catering',
    'Grocery Store',
    'Other',
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _saveBusinessDetails() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('business_name', _businessNameController.text);
        await prefs.setString('business_address', _addressController.text);
        await prefs.setString('business_type', _selectedBusinessType);
        await prefs.setString('contact_number', _contactController.text);
        await prefs.setString('website', _websiteController.text);

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Business details saved')));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving details: $e')));
      }
    }
  }

  Future<void> _saveAndContinue() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _saveBusinessDetails();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const InventoryDetailsScreen()),
      );
    }
  }

  Widget _buildProgressIndicator(bool isActive) {
    return Container(
      width: 60,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? _accent : _fieldFill,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      errorStyle: const TextStyle(height: 0, fontSize: 0),
    );
  }

  Widget _fieldContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: _fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return _fieldContainer(
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(hint).copyWith(
          errorMaxLines: 0,
        ),
        validator: validator,
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required VoidCallback onPressed,
    required Color background,
    required Color foreground,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Prepal',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const InventoryDetailsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProgressIndicator(true),
                    const SizedBox(width: 8),
                    _buildProgressIndicator(false),
                    const SizedBox(width: 8),
                    _buildProgressIndicator(false),
                    const SizedBox(width: 8),
                    _buildProgressIndicator(false),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Business details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _label('Business name'),
                const SizedBox(height: 8),
                _textField(
                  controller: _businessNameController,
                  hint: 'Enter business name',
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter business name'
                      : null,
                ),
                const SizedBox(height: 24),
                _label('Contact address (Optional)'),
                const SizedBox(height: 8),
                _textField(
                  controller: _addressController,
                  hint: 'Enter contact address',
                  validator: (value) => null,
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Business type'),
                          const SizedBox(height: 8),
                          _fieldContainer(
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedBusinessType,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                dropdownColor: _fieldFill,
                                items: _businessTypes
                                    .map(
                                      (type) => DropdownMenuItem<String>(
                                        value: type,
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(type, overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedBusinessType = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Contact number'),
                          const SizedBox(height: 8),
                          _textField(
                            controller: _contactController,
                            hint: '+123 456 7890',
                            keyboardType: TextInputType.phone,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _label('Website (Optional)'),
                const SizedBox(height: 8),
                _textField(
                  controller: _websiteController,
                  hint: 'www.yourbusiness.com',
                  keyboardType: TextInputType.url,
                  validator: (value) => null,
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    _actionButton(
                      label: 'Save',
                      onPressed: _saveBusinessDetails,
                      background: _fieldFill,
                      foreground: Colors.black87,
                    ),
                    const SizedBox(width: 16),
                    _actionButton(
                      label: 'Next',
                      onPressed: _saveAndContinue,
                      background: _primary,
                      foreground: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

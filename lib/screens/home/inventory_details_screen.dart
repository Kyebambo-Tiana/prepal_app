import 'package:flutter/material.dart';
import 'home_screen.dart';

class InventoryDetailsScreen extends StatefulWidget {
  const InventoryDetailsScreen({super.key});

  @override
  State<InventoryDetailsScreen> createState() => _InventoryDetailsScreenState();
}

class _InventoryDetailsScreenState extends State<InventoryDetailsScreen> {
  static const _fieldFill = Color(0xFFE8D5E3);
  static const _accent = Color(0xFFD84315);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _selectedProductType = 'Pastries';
  String _selectedUnit = 'PCS';

  final List<String> _productTypes = [
    'Pastries', 'Beverages', 'Dairy', 'Dish', 'Drink',
    'Sauce', 'Soup', 'Water', 'Other',
  ];

  final List<String> _units = ['PCS', 'KG', 'G', 'L', 'ML', 'PACK'];

  final List<Map<String, dynamic>> _addedProducts = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = '14-02-2026';
    _productNameController.text = 'Mega meat pie';
    _quantityController.text = '24';
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _addProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _addedProducts.add({
          'productType': _selectedProductType,
          'productName': _productNameController.text,
          'quantity': _quantityController.text,
          'unit': _selectedUnit,
          'date': _dateController.text,
        });
      });

      _productNameController.clear();
      _quantityController.clear();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product added')));
    }
  }

  void _saveProducts() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Products saved')));
    }
  }

  void _submitProducts() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Products submitted successfully!')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        _dateController.text =
            '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
      });
    }
  }

  Widget _buildProgressIndicator(bool isActive) => Container(width: 60, height: 4,
   decoration: BoxDecoration(color: isActive ? _accent : _fieldFill, borderRadius:
    BorderRadius.circular(2)));

  InputDecoration _inputDecoration(String? hint) {
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
    String? hint,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return _fieldContainer(
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(hint).copyWith(
          errorMaxLines: 0,
        ),
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return _fieldContainer(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
          dropdownColor: _fieldFill,
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(item, overflow: TextOverflow.ellipsis),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
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

  Widget _labeledFieldRow({
    required String label,
    required Widget field,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: _label(label)),
          const SizedBox(width: 12),
          Flexible(flex: 3, child: field),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
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
                      _buildProgressIndicator(true),
                      const SizedBox(width: 8),
                      _buildProgressIndicator(false),
                      const SizedBox(width: 8),
                      _buildProgressIndicator(false),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Inventory details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _labeledFieldRow(
                    label: 'Product name',
                    field: _textField(
                      controller: _productNameController,
                      hint: 'Enter product name',
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Please enter product name'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _labeledFieldRow(
                          label: 'Type',
                          field: _dropdownField(
                            value: _selectedProductType,
                            items: _productTypes,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedProductType = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _labeledFieldRow(
                          label: 'Date',
                          field: _textField(
                            controller: _dateController,
                            readOnly: true,
                            onTap: _pickDate,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _labeledFieldRow(
                          label: 'Qty',
                          field: _textField(
                            controller: _quantityController,
                            hint: '0',
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Required'
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _labeledFieldRow(
                          label: 'Unit',
                          field: _dropdownField(
                            value: _selectedUnit,
                            items: _units,
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedUnit = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _addProduct,
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Add another product'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      _actionButton(
                        label: 'Save',
                        onPressed: _saveProducts,
                        background: _fieldFill,
                        foreground: Colors.black87,
                      ),
                      const SizedBox(width: 16),
                      _actionButton(
                        label: 'Submit',
                        onPressed: _submitProducts,
                        background: _accent,
                        foreground: Colors.white,
                      ),
                    ],
                  ),
                  if (_addedProducts.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Added Products:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _addedProducts.map((product) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product['productName']} - ${product['quantity']} ${product['unit']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

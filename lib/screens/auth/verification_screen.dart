import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../onboarding/business_details_screen.dart';

class VerificationScreen extends StatefulWidget {
	const VerificationScreen({super.key});

	@override
	State<VerificationScreen> createState() => _VerificationScreenState();
}


class _VerificationScreenState extends State<VerificationScreen> {
	final _formKey = GlobalKey<FormState>();
	final List<TextEditingController> _codeControllers =
			List.generate(4, (_) => TextEditingController());
	static const String _demoCode = "1234";


	@override
	void dispose() {
		for (final controller in _codeControllers) {
			controller.dispose();
		}
		super.dispose();
	}

	Widget _buildProgressIndicator(bool isActive) {
		return Expanded(
			child: Container(
				height: 4,
				margin: const EdgeInsets.symmetric(horizontal: 4),
				decoration: BoxDecoration(
					color: isActive
							? const Color(0xFFD84315)
							: const Color(0xFFE8D5E3),
					borderRadius: BorderRadius.circular(2),
				),
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			body: SafeArea(
				child: SingleChildScrollView(
					padding: const EdgeInsets.all(24),
					child: Form(
						key: _formKey,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								/// Progress
								Row(
									children: [
										_buildProgressIndicator(true),
										_buildProgressIndicator(true),
										_buildProgressIndicator(false),
										_buildProgressIndicator(false),
									],
								),

								const SizedBox(height: 32),

								const Text(
									"Verification",
									style: TextStyle(
										fontSize: 22,
										fontWeight: FontWeight.bold,
									),
								),

								const SizedBox(height: 24),

								/// ID Number
								const Text(
									"Please input the code sent to your email address",
									style: TextStyle(fontSize: 14),
								),
								const SizedBox(height: 8),


								Row(
									mainAxisAlignment: MainAxisAlignment.spaceEvenly,
									children: List.generate(4, (index) {
										return SizedBox(
											width: 56,
											child: TextFormField(
												controller: _codeControllers[index],
												keyboardType: TextInputType.number,
												textAlign: TextAlign.center,
												maxLength: 1,
												style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
												inputFormatters: [FilteringTextInputFormatter.digitsOnly],
												decoration: InputDecoration(
													counterText: '',
													filled: true,
													fillColor: Color(0xFFE8D5E3),
													border: OutlineInputBorder(
														borderRadius: BorderRadius.circular(12),
														borderSide: BorderSide.none,
													),
													contentPadding: EdgeInsets.symmetric(vertical: 18),
												),
												validator: (value) {
													if (value == null || value.isEmpty) {
														return '';
													}
													return null;
												},
												onChanged: (value) {
													if (value.length == 1 && index < 3) {
														FocusScope.of(context).nextFocus();
													} else if (value.isEmpty && index > 0) {
														FocusScope.of(context).previousFocus();
													}
												},
											),
										);
									}),
								),

								const SizedBox(height: 40),

								SizedBox(
									width: double.infinity,
									child: ElevatedButton(
										onPressed: () {
											if (_formKey.currentState!.validate()) {
												String enteredCode = _codeControllers.map((c) => c.text).join();
												if (enteredCode != _demoCode) {
													ScaffoldMessenger.of(context).showSnackBar(
														SnackBar(content: Text('Invalid code'), backgroundColor: Colors.red),
													);
													return;
												}
												Navigator.of(context).pushReplacement(
													MaterialPageRoute(
														builder: (context) => const BusinessDetailsScreen(),
													),
												);
											}
										},
										style: ElevatedButton.styleFrom(
											backgroundColor: const Color(0xFFD84315),
											padding: const EdgeInsets.symmetric(vertical: 16),
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12),
											),
										),
										child: const Text(
											"Continue",
											style: TextStyle(fontSize: 16, color: Colors.white),
										),
									),
								),
							],
						),
					),
				),
			),
		);
	}
}

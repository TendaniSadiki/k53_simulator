import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserProfile _editableProfile;
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final profile = await FirestoreService().getUserProfile(user.uid).first;
    setState(() {
      _editableProfile = profile.copyWith(); // Create editable copy
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      await FirestoreService().updateUserProfile(_editableProfile);
      setState(() {
        _isEditing = false;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    }
  }

  Widget _buildDrivingDataSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Driving Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: !_isEditing,
              initialValue: _editableProfile.learnersLicenseNumber,
              decoration: const InputDecoration(labelText: 'Learner\'s License Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter license number';
                }
                return null;
              },
              onSaved: (value) => _editableProfile = _editableProfile.copyWith(
                learnersLicenseNumber: value!,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _editableProfile.preferredLanguage,
              decoration: const InputDecoration(labelText: 'Preferred Language'),
              items: ['en', 'af', 'zu'].map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text({
                    'en': 'English',
                    'af': 'Afrikaans',
                    'zu': 'Zulu'
                  }[lang]!),
                );
              }).toList(),
              onChanged: _isEditing
                  ? (value) => setState(() => _editableProfile = _editableProfile.copyWith(
                        preferredLanguage: value!,
                      ))
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _editableProfile.vehicleType,
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
              items: ['motorcycle', 'light', 'heavy'].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text({
                    'motorcycle': 'Motorcycle',
                    'light': 'Light Motor Vehicle',
                    'heavy': 'Heavy Vehicle'
                  }[type]!),
                );
              }).toList(),
              onChanged: _isEditing
                  ? (value) => setState(() => _editableProfile = _editableProfile.copyWith(
                        vehicleType: value!,
                      ))
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              enabled: _isEditing,
              readOnly: !_isEditing,
              initialValue: _editableProfile.testDate?.toIso8601String().split('T')[0],
              decoration: const InputDecoration(labelText: 'Test Date (YYYY-MM-DD)'),
              onSaved: (value) {
                if (value != null && value.isNotEmpty) {
                  _editableProfile = _editableProfile.copyWith(
                    testDate: DateTime.parse(value),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Progress & Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Test History', style: TextStyle(fontWeight: FontWeight.w500)),
            ..._editableProfile.testHistory.map((test) => ListTile(
              title: Text('${test.testType} - ${test.score}%'),
              subtitle: Text('${test.date.toLocal()}'),
            )),
            const SizedBox(height: 16),
            const Text('Weak Areas', style: TextStyle(fontWeight: FontWeight.w500)),
            Wrap(
              children: _editableProfile.weakAreas.map((area) => Chip(
                label: Text(area),
                backgroundColor: Colors.orange[100],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings & Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _editableProfile.notificationsEnabled,
              onChanged: _isEditing
                  ? (value) => setState(() => _editableProfile = _editableProfile.copyWith(
                        notificationsEnabled: value,
                      ))
                  : null,
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _editableProfile.darkModeEnabled,
              onChanged: _isEditing
                  ? (value) => setState(() => _editableProfile = _editableProfile.copyWith(
                        darkModeEnabled: value,
                      ))
                  : null,
            ),
            SwitchListTile(
              title: const Text('Cloud Sync'),
              value: _editableProfile.cloudSyncEnabled,
              onChanged: _isEditing
                  ? (value) => setState(() => _editableProfile = _editableProfile.copyWith(
                        cloudSyncEnabled: value,
                      ))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Legal & Compliance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('I accept the Terms & Conditions'),
              value: _editableProfile.termsAccepted,
              onChanged: _isEditing
                  ? (value) => setState(() => _editableProfile = _editableProfile.copyWith(
                        termsAccepted: value,
                      ))
                  : null,
            ),
            SwitchListTile(
              title: const Text('I am 16 years or older'),
              value: _editableProfile.ageVerified,
              onChanged: _isEditing
                  ? (value) => setState(() => _editableProfile = _editableProfile.copyWith(
                        ageVerified: value,
                      ))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveProfile,
            )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildDrivingDataSection(),
              const SizedBox(height: 16),
              _buildProgressSection(),
              const SizedBox(height: 16),
              _buildSettingsSection(),
              const SizedBox(height: 16),
              _buildLegalSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
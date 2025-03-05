import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() => runApp(BloodDonorApp());

class BloodDonorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One-Tap Blood',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    RequestsScreen(),
    // DonateScreen(),
    DonorRegistrationForm(),
    MapScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0
          ? null
          : AppBar(title: Text(_getAppBarTitle())),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.emergency), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Donate'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 1: return 'Requests';
      case 2: return 'Donate';
      case 3: return 'Map';
      case 4: return 'Profile';
      default: return 'One-Tap Blood';
    }
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 100,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome Back , Sai', style: TextStyle(fontSize: 14)),
                Text('City Hospital, 2.5km away', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () => _showNotifications(context),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EmergencyButton(),
                SizedBox(height: 20),
                Text('Nearby Donors', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                DonorTile(name: 'John Doe', distance: '1.2km', bloodType: 'A+'),
                DonorTile(name: 'Jane Smith', distance: '1.8km', bloodType: 'O-'),
                DonorTile(name: 'Mike Johnson', distance: '2.1km', bloodType: 'O+'),
                TextButton(onPressed: () {}, child: Text('View All Donors')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notifications'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.bloodtype),
              title: Text('New blood request nearby'),
              subtitle: Text('O+ needed at City Hospital'),
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: Text('Donation reminder'),
              subtitle: Text('You can donate again after 2 weeks'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          )
        ],
      ),
    );
  }
}

class EmergencyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('One-Tap Blood Emergency Request',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Urgent\nCity Hospital, 2.5km away\nNeeded within 2 hours',
              textAlign: TextAlign.center),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {},
            child: Text('Respond Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class DonorTile extends StatelessWidget {
  final String name;
  final String distance;
  final String bloodType;

  const DonorTile({
    required this.name,
    required this.distance,
    required this.bloodType,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(bloodType)),
      title: Text(name),
      subtitle: Text(distance),
      trailing: Icon(Icons.phone),
    );
  }
}

class MapScreen extends StatelessWidget {
  final String mapUrl =
      "https://www.google.com/maps/embed?origin=mfe&pb=!1m3!2m1!1s%25C4%25B0zmir!6i14!3m1!1sen!5m1!1sen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: '''
              <html>
                <body>
                  <iframe src="https://www.google.com/maps/embed?origin=mfe&pb=!1m3!2m1!1s%25C4%25B0zmir!6i14!3m1!1sen!5m1!1sen"; width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
                </body>
              </html>
            ''',
        ),
      ),
    );
  }
}



class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(radius: 40, child: Text('S')),

          Text('Sai', style: TextStyle(fontSize: 20)),
          Text('Active Donor', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn('12', 'Donations'),
              _buildStatColumn('24', 'Lives Saved'),
              _buildStatColumn('#5', 'Rank'),
            ],
          ),
          SizedBox(height: 20),
          Text('Achievement Badges', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 10,
            children: [
              _buildBadge('First Blood'),
              _buildBadge('Quick'),
              _buildBadge('Regular Donor'),
              _buildBadge('Life Saver'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Chip(
      backgroundColor: Colors.red.shade50,
      label: Text(text),
    );
  }
}

// class RequestsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildRequestStep('Patient Information', Icons.person),
//           _buildRequestStep('Hospital Details', Icons.local_hospital),
//           _buildRequestStep('Urgency & Requirements', Icons.emergency),
//           _buildRequestStep('Contact Information', Icons.contact_page),
//           ElevatedButton(
//             onPressed: () {},
//             child: Text('Submit Blood Request'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRequestStep(String title, IconData icon) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.red),
//       title: Text(title),
//       trailing: Icon(Icons.chevron_right),
//     );
//   }
// }

// class DonateScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           TextField(decoration: InputDecoration(labelText: 'Enter your full name')),
//           SizedBox(height: 20),
//           TextField(decoration: InputDecoration(labelText: 'Age')),
//           SizedBox(height: 20),
//           TextField(decoration: InputDecoration(labelText: 'Enter your blood group')),
//           SizedBox(height: 20),
//           TextField(decoration: InputDecoration(labelText: 'Phone Number')),
//           SizedBox(height: 20),
//           TextField(decoration: InputDecoration(labelText: 'Enter your Email')),
//           SizedBox(height: 20),
//           TextField(decoration: InputDecoration(labelText: 'Enter your location')),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {},
//             child: Text('Register as Donor'),
//           ),
//         ],
//       ),
//     );
//   }
// }


class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedBloodType;
  final TextEditingController _hospitalNameController = TextEditingController();
  String? _selectedLocation;
  String? _selectedUrgency;
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();

  final List<String> _bloodTypes = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  final List<String> _locations = ['City Hospital', 'General Hospital', 'Central Clinic', 'North Medical'];
  final List<String> _urgencyLevels = ['Low', 'Medium', 'High', 'Critical'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Patient Information', Icons.person),
              _buildPatientNameField(),
              SizedBox(height: 10),
              _buildAgeField(),
              SizedBox(height: 10),
              _buildBloodTypeDropdown(),
              Divider(height: 40),

              _buildSectionHeader('Hospital Details', Icons.local_hospital),
              _buildHospitalNameField(),
              SizedBox(height: 10),
              _buildLocationDropdown(),
              Divider(height: 40),

              _buildSectionHeader('Urgency & Requirements', Icons.emergency),
              _buildUrgencyDropdown(),
              SizedBox(height: 10),
              _buildUnitsRequiredField(),
              SizedBox(height: 10),
              _buildAdditionalNotesField(),
              Divider(height: 40),

              _buildSectionHeader('Contact Information', Icons.contact_page),
              _buildContactPersonField(),
              SizedBox(height: 10),
              _buildContactPhoneField(),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitRequest,
                child: Text('Submit Blood Request'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(title, style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.red[800],
      )),
    );
  }

  Widget _buildPatientNameField() {
    return TextFormField(
      controller: _patientNameController,
      decoration: InputDecoration(
        labelText: 'Patient Name',
        hintText: 'Enter patient name',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter patient name' : null,
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      controller: _ageController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Age',
        hintText: 'Enter age',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter age' : null,
    );
  }

  Widget _buildBloodTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBloodType,
      decoration: InputDecoration(
        labelText: 'Blood Type Required',
        border: OutlineInputBorder(),
      ),
      items: _bloodTypes.map((type) =>
          DropdownMenuItem(value: type, child: Text(type))).toList(),
      onChanged: (value) => setState(() => _selectedBloodType = value),
      validator: (value) => value == null ? 'Please select blood type' : null,
    );
  }

  Widget _buildHospitalNameField() {
    return TextFormField(
      controller: _hospitalNameController,
      decoration: InputDecoration(
        labelText: 'Hospital Name',
        hintText: 'Enter hospital name',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter hospital name' : null,
    );
  }

  Widget _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedLocation,
      decoration: InputDecoration(
        labelText: 'Location',
        border: OutlineInputBorder(),
      ),
      items: _locations.map((location) =>
          DropdownMenuItem(value: location, child: Text(location))).toList(),
      onChanged: (value) => setState(() => _selectedLocation = value),
      validator: (value) => value == null ? 'Please select location' : null,
    );
  }

  Widget _buildUrgencyDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedUrgency,
      decoration: InputDecoration(
        labelText: 'Urgency Level',
        border: OutlineInputBorder(),
      ),
      items: _urgencyLevels.map((level) =>
          DropdownMenuItem(value: level, child: Text(level))).toList(),
      onChanged: (value) => setState(() => _selectedUrgency = value),
      validator: (value) => value == null ? 'Please select urgency level' : null,
    );
  }

  Widget _buildUnitsRequiredField() {
    return TextFormField(
      controller: _unitsController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Units Required',
        hintText: 'Enter number of units',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter units required' : null,
    );
  }

  Widget _buildAdditionalNotesField() {
    return TextFormField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Additional Notes',
        hintText: 'Enter any additional information',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildContactPersonField() {
    return TextFormField(
      controller: _contactPersonController,
      decoration: InputDecoration(
        labelText: 'Contact Person',
        hintText: 'Enter contact person name',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter contact person' : null,
    );
  }

  Widget _buildContactPhoneField() {
    return TextFormField(
      controller: _contactPhoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',

        hintText: 'Enter phone number',
        border: OutlineInputBorder(),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
    );
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      print('Blood request submitted');
      print({
        'patientName': _patientNameController.text,
        'age': _ageController.text,
        'bloodType': _selectedBloodType,
        'hospitalName': _hospitalNameController.text,
        'location': _selectedLocation,
        'urgency': _selectedUrgency,
        'units': _unitsController.text,
        'notes': _notesController.text,
        'contactPerson': _contactPersonController.text,
        'contactPhone': _contactPhoneController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blood request submitted successfully!'))
      );
    }
  }
}


class DonorRegistrationForm extends StatefulWidget {
  @override
  _DonorRegistrationFormState createState() => _DonorRegistrationFormState();
}

class _DonorRegistrationFormState extends State<DonorRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;
  String? _selectedBloodType;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedLocation;
  bool _healthStatus = false;
  bool _medicalConditions = false;
  bool _contactAgreement = false;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodTypes = ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'];
  final List<String> _locations = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Miami'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              _buildSectionHeader('Personal Information'),
          _buildFullNameField(),
          _buildAgeGenderRow(),
          _buildBloodTypeDropdown(),
          Divider(),

          _buildSectionHeader('Contact Information'),
          _buildPhoneField(),
          _buildEmailField(),
          _buildLocationDropdown(),
          Divider(),

          _buildSectionHeader('Health Declaration'),
          _buildHealthCheckboxes(),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Submit Registration'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          )],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
      ),
      validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
    );
  }

  Widget _buildAgeGenderRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age',
              hintText: 'Your age',
            ),
            validator: (value) => value!.isEmpty ? 'Please enter your age' : null,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(labelText: 'Gender'),
            items: _genders.map((gender) =>
                DropdownMenuItem(value: gender, child: Text(gender))).toList(),
            onChanged: (value) => setState(() => _selectedGender = value),
            validator: (value) => value == null ? 'Please select gender' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBloodTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBloodType,
      decoration: InputDecoration(labelText: 'Blood Type'),
      items: _bloodTypes.map((type) =>
          DropdownMenuItem(value: type, child: Text(type))).toList(),
      onChanged: (value) => setState(() => _selectedBloodType = value),
      validator: (value) => value == null ? 'Please select blood type' : null,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: 'Enter phone number',
      ),
      validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email (Optional)',
        hintText: 'Enter email address',
      ),
      validator: (value) => value!.isNotEmpty && !value.contains('@')
          ? 'Enter a valid email'
          : null,
    );
  }

  Widget _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedLocation,
      decoration: InputDecoration(labelText: 'Location'),
      items: _locations.map((location) =>
          DropdownMenuItem(value: location, child: Text(location))).toList(),
      onChanged: (value) => setState(() => _selectedLocation = value),
      validator: (value) => value == null ? 'Please select location' : null,
    );
  }

  Widget _buildHealthCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          title: Text('I confirm I am in good health'),
          value: _healthStatus,
          onChanged: (value) => setState(() => _healthStatus = value!),
        ),
        CheckboxListTile(
          title: Text('I have no chronic medical conditions'),
          value: _medicalConditions,
          onChanged: (value) => setState(() => _medicalConditions = value!),
        ),
        CheckboxListTile(
          title: Text('I agree to be contacted for blood donation'),
          value: _contactAgreement,
          onChanged: (value) => setState(() => _contactAgreement = value!),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_healthStatus || !_medicalConditions || !_contactAgreement) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please agree to all health declarations')));
        return;
      }

      print('Form submitted successfully');
      print({
        'name': _fullNameController.text,
        'age': _ageController.text,
        'gender': _selectedGender,
        'bloodType': _selectedBloodType,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'location': _selectedLocation,
      });
    }
  }
}


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'One Tab Blood Donation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('A blood donor is a lifesaver'),
            SizedBox(height: 24),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone no',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: 'Password',
            //     border: OutlineInputBorder(),
            //   ),
            //   obscureText: true,
            // ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 16),
            Text('Or continue with'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.g_mobiledata),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.apple),
                  color: Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
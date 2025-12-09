import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

// --- 0. Bilingual Strings Helper ---
class AppLabels {
  static const String headTitle = "Head of Household / ಕುಟುಂಬದ ಮುಖ್ಯಸ್ಥ";
  static const String memberTitle = "Family Members / ಕುಟುಂಬದ ಸದಸ್ಯರು";
  static const String addMember = "Add Member / ಸದಸ್ಯರನ್ನು ಸೇರಿಸಿ";
  static const String submit = "SUBMIT & GENERATE CARDS / ಸಲ್ಲಿಸಿ & ಕಾರ್ಡ್‌ಗಳನ್ನು ರಚಿಸಿ";

  // Form Fields
  static const String photoText = "Tap to add photo / ಫೋಟೋ ಸೇರಿಸಿ";
  static const String personalInfo = "Personal Information / ವೈಯಕ್ತಿಕ ಮಾಹಿತಿ";
  static const String name = "Full Name / ಪೂರ್ಣ ಹೆಸರು";
  static const String relationship = "Relationship / ಸಂಬಂಧ";
  static const String maritalStatus = "Marital Status / ವೈವಾಹಿಕ ಸ್ಥಿತಿ";
  static const String dob = "DOB / ಜನ್ಮ ದಿನಾಂಕ";
  static const String age = "Age / ವಯಸ್ಸು";
  static const String aadhar = "Aadhar No / ಆಧಾರ್ ಸಂಖ್ಯೆ";
  static const String mobile = "Mobile / ಮೊಬೈಲ್ ಸಂಖ್ಯೆ";
  static const String education = "Education / ವಿದ್ಯಾಭ್ಯಾಸ";
  static const String sector = "Sector / ವಲಯ";
  static const String occupation = "Occupation / ಉದ್ಯೋಗ";
  static const String tradOccupation = "Traditional Occ. / ಕುಲ ಕಸುಬು";

  // Address
  static const String addressHeader = "Address Details / ವಿಳಾಸದ ವಿವರಗಳು";
  static const String country = "Country / ದೇಶ";
  static const String state = "State / ರಾಜ್ಯ";
  static const String district = "District / ಜಿಲ್ಲೆ";
  static const String pincode = "Pincode / ಪಿನ್ ಕೋಡ್";
  static const String fullAddress = "Full Address / ಪೂರ್ಣ ವಿಳಾಸ";
}

// --- 1. Data Model ---
class PersonData {
  File? profileImage;
  String name = '';
  String relationship = 'Head / ಮುಖ್ಯಸ್ಥ';
  DateTime? dob;
  String age = '';
  String aadhar = '';
  String mobile = '';
  String maritalStatus = 'Single / ಅವಿವಾಹಿತ';
  String education = '';
  String empType = 'Private / ಖಾಸಗಿ';
  String occupation = '';
  String traditionalOccupation = '';
  String country = 'India';
  String? state;
  String? district;
  String pincode = '';
  String fullAddress = '';
  bool isExpanded = true;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormReadOnly = false;
  bool _showResults = false;

  PersonData headOfHousehold = PersonData();
  List<PersonData> familyMembers = [];

  void _addFamilyMember() {
    if (_isFormReadOnly) return;
    setState(() {
      PersonData newMember = PersonData();
      newMember.relationship = 'Spouse / ಪತ್ನಿ/ಪತಿ';
      familyMembers.add(newMember);
    });
  }

  void _removeFamilyMember(int index) {
    if (_isFormReadOnly) return;
    setState(() {
      familyMembers.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isFormReadOnly = true;
        _showResults = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Survey Submitted! / ಸಮೀಕ್ಷೆ ಸಲ್ಲಿಸಲಾಗಿದೆ!'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  void _enableEditing() {
    setState(() {
      _isFormReadOnly = false;
      _showResults = false;
      headOfHousehold.isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showResults ? "Cards / ಕಾರ್ಡ್‌ಗಳು" : "Survey / ಸಮೀಕ್ಷೆ"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          if (_isFormReadOnly)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _enableEditing,
            )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: _showResults ? _buildResultView() : _buildFormView(),
    );
  }

  // --- View 1: Input Form with Watermark ---
  Widget _buildFormView() {
    return Stack(
      children: [
        // 1. WATERMARK BACKGROUND
        // ... inside the Stack in _buildFormView ...

        // 1. WATERMARK BACKGROUND
        Positioned.fill(
          child: Opacity(
            opacity: 0.35, // Low opacity for watermark effect
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.saturation
              ),
              // CHANGE THIS WIDGET:
              child: Image.asset(
                'assets/app_icon.jpg', // Use your local asset path here
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

// ... rest of the code

        // 2. SCROLLABLE FORM CONTENT
        SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSectionHeader(AppLabels.headTitle),
                PersonDetailForm(
                  key: ObjectKey(headOfHousehold),
                  data: headOfHousehold,
                  isHead: true,
                  index: 0,
                  isReadOnly: _isFormReadOnly,
                  onRemove: () {},
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildSectionHeader(AppLabels.memberTitle)),
                    if (!_isFormReadOnly)
                      ElevatedButton.icon(
                        onPressed: _addFamilyMember,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Add / ಸೇರಿಸಿ", style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      )
                  ],
                ),
                if (familyMembers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                        child: Text("No members added / ಯಾವುದೇ ಸದಸ್ಯರನ್ನು ಸೇರಿಸಲಾಗಿಲ್ಲ",
                            style: TextStyle(color: Colors.grey))
                    ),
                  ),
                ...List.generate(familyMembers.length, (index) {
                  return PersonDetailForm(
                    key: ObjectKey(familyMembers[index]),
                    data: familyMembers[index],
                    isHead: false,
                    index: index,
                    isReadOnly: _isFormReadOnly,
                    onRemove: () => _removeFamilyMember(index),
                  );
                }),
                const SizedBox(height: 30),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                        AppLabels.submit,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    List<PersonData> allMembers = [headOfHousehold, ...familyMembers];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allMembers.length,
      itemBuilder: (context, index) {
        return GeneratedIdCard(data: allMembers[index]);
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
            letterSpacing: 0.5
        ),
      ),
    );
  }
}

// --- 3. Result Card ---
class GeneratedIdCard extends StatelessWidget {
  final PersonData data;
  const GeneratedIdCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.teal.shade700,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    image: data.profileImage != null
                        ? DecorationImage(image: FileImage(data.profileImage!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: data.profileImage == null
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    data.relationship.split('/').first.toUpperCase(), // Only showing English in small badge for space
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    data.age.isNotEmpty ? "${data.age} Yrs" : "N/A",
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.name.toUpperCase(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(),
                  _cardRow(Icons.work, data.occupation),
                  _cardRow(Icons.phone, data.mobile),
                  _cardRow(Icons.fingerprint, data.aadhar),
                  _cardRow(Icons.location_on, data.district ?? "Unknown"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cardRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.isEmpty ? "Not Provided" : text,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 4. Form Widget (Updated with Bilingual Labels) ---
class PersonDetailForm extends StatefulWidget {
  final PersonData data;
  final bool isHead;
  final int index;
  final bool isReadOnly;
  final VoidCallback onRemove;

  const PersonDetailForm({
    super.key,
    required this.data,
    required this.isHead,
    required this.index,
    required this.isReadOnly,
    required this.onRemove,
  });

  @override
  State<PersonDetailForm> createState() => _PersonDetailFormState();
}

class _PersonDetailFormState extends State<PersonDetailForm> {
  final TextEditingController _dobController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final Map<String, List<String>> _stateDistrictMap = {
    'Karnataka': ['Bangalore / ಬೆಂಗಳೂರು', 'Mysore / ಮೈಸೂರು', 'Davangere / ದಾವಣಗೆರೆ', 'Hubli / ಹುಬ್ಬಳ್ಳಿ'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur'],
  };

  @override
  void initState() {
    super.initState();
    if (widget.data.dob != null) {
      _dobController.text = DateFormat('dd/MM/yyyy').format(widget.data.dob!);
    }
  }

  Future<void> _pickImage() async {
    if (widget.isReadOnly) return;
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          widget.data.profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (widget.isReadOnly) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        widget.data.dob = picked;
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
        widget.data.age = (DateTime.now().year - picked.year).toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color? fieldColor = widget.isReadOnly ? Colors.grey[200] : Colors.white.withOpacity(0.9);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: widget.data.isExpanded,
        onExpansionChanged: (val) => setState(() => widget.data.isExpanded = val),
        leading: CircleAvatar(
          backgroundColor: widget.isHead ? Colors.teal : Colors.blueGrey,
          backgroundImage: widget.data.profileImage != null ? FileImage(widget.data.profileImage!) : null,
          child: widget.data.profileImage == null
              ? Icon(widget.isHead ? Icons.home : Icons.person, color: Colors.white)
              : null,
        ),
        title: Text(
          widget.data.name.isEmpty
              ? (widget.isHead ? "Head / ಮುಖ್ಯಸ್ಥ" : "Member ${widget.index + 1}")
              : widget.data.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.data.relationship.split('/').first),
        trailing: widget.isHead || widget.isReadOnly
            ? null
            : IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: widget.onRemove,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: widget.data.profileImage != null
                              ? FileImage(widget.data.profileImage!)
                              : null,
                          child: widget.data.profileImage == null
                              ? const Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                              : null,
                        ),
                      ),
                      if (!widget.isReadOnly)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(AppLabels.photoText, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _subHeader(AppLabels.personalInfo),

                // Name
                TextFormField(
                  initialValue: widget.data.name,
                  decoration: _inputDecoration(AppLabels.name, fieldColor),
                  enabled: !widget.isReadOnly,
                  onChanged: (val) => widget.data.name = val,
                  validator: (val) => val!.isEmpty ? 'Name required / ಹೆಸರು ಅಗತ್ಯವಿದೆ' : null,
                ),
                const SizedBox(height: 12),

                // Relationship & Marital
                Row(
                  children: [
                    Expanded(
                      child: widget.isHead
                          ? TextFormField(
                        initialValue: "Head / ಮುಖ್ಯಸ್ಥ",
                        readOnly: true,
                        enabled: !widget.isReadOnly,
                        decoration: _inputDecoration(AppLabels.relationship, fieldColor),
                      )
                          : DropdownButtonFormField<String>(
                        value: widget.data.relationship == 'Head / ಮುಖ್ಯಸ್ಥ' ? null : widget.data.relationship,
                        decoration: _inputDecoration(AppLabels.relationship, fieldColor),
                        onChanged: widget.isReadOnly ? null : (val) => setState(() => widget.data.relationship = val!),
                        isExpanded: true,
                        items: ['Spouse / ಪತ್ನಿ/ಪತಿ', 'Son / ಮಗ', 'Daughter / ಮಗಳು', 'Father / ತಂದೆ', 'Mother / ತಾಯಿ']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.maritalStatus,
                        decoration: _inputDecoration(AppLabels.maritalStatus, fieldColor),
                        onChanged: widget.isReadOnly ? null : (val) => setState(() => widget.data.maritalStatus = val!),
                        isExpanded: true,
                        items: ['Single / ಅವಿವಾಹಿತ', 'Married / ವಿವಾಹಿತ', 'Divorced / ವಿಚ್ಛೇದಿತ', 'Widowed / ವಿಧವೆ/ವಿಧುರ']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // DOB & Age
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        enabled: !widget.isReadOnly,
                        decoration: _inputDecoration(AppLabels.dob, fieldColor).copyWith(suffixIcon: const Icon(Icons.calendar_month, size: 20)),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        key: ValueKey(widget.data.age),
                        initialValue: widget.data.age,
                        readOnly: true,
                        enabled: !widget.isReadOnly,
                        decoration: _inputDecoration(AppLabels.age, fieldColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  initialValue: widget.data.aadhar,
                  decoration: _inputDecoration(AppLabels.aadhar, fieldColor).copyWith(hintText: "0000 0000 0000"),
                  enabled: !widget.isReadOnly,
                  keyboardType: TextInputType.number,
                  maxLength: 14,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    AadharNumberFormatter(),
                  ],
                  onChanged: (val) => widget.data.aadhar = val,
                ),

                TextFormField(
                  initialValue: widget.data.mobile,
                  decoration: _inputDecoration(AppLabels.mobile, fieldColor),
                  enabled: !widget.isReadOnly,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (val) => widget.data.mobile = val,
                ),

                TextFormField(
                  initialValue: widget.data.education,
                  decoration: _inputDecoration(AppLabels.education, fieldColor),
                  enabled: !widget.isReadOnly,
                  onChanged: (val) => widget.data.education = val,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.empType,
                        decoration: _inputDecoration(AppLabels.sector, fieldColor),
                        onChanged: widget.isReadOnly ? null : (val) => setState(() => widget.data.empType = val!),
                        isExpanded: true,
                        items: ['Government / ಸರ್ಕಾರಿ', 'Private / ಖಾಸಗಿ', 'Self / ಸ್ವಯಂ', 'Student / ವಿದ್ಯಾರ್ಥಿ', 'None / ಇಲ್ಲ']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.data.occupation,
                        decoration: _inputDecoration(AppLabels.occupation, fieldColor),
                        enabled: !widget.isReadOnly,
                        onChanged: (val) => widget.data.occupation = val,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: widget.data.traditionalOccupation,
                  decoration: _inputDecoration(AppLabels.tradOccupation, fieldColor),
                  enabled: !widget.isReadOnly,
                  onChanged: (val) => widget.data.traditionalOccupation = val,
                ),

                const SizedBox(height: 20),
                const Divider(thickness: 1.5),

                // --- LOCATION SECTION ---
                _subHeader(AppLabels.addressHeader),

                DropdownButtonFormField<String>(
                  value: widget.data.country,
                  decoration: _inputDecoration(AppLabels.country, fieldColor),
                  onChanged: widget.isReadOnly ? null : (val) => setState(() => widget.data.country = val!),
                  items: ['India', 'USA', 'UK'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.state,
                        hint: Text(AppLabels.state, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        decoration: _inputDecoration(AppLabels.state, fieldColor),
                        isExpanded: true,
                        items: _stateDistrictMap.keys.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: widget.isReadOnly ? null : (val) {
                          setState(() {
                            widget.data.state = val;
                            widget.data.district = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.district,
                        hint: Text(AppLabels.district, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        decoration: _inputDecoration(AppLabels.district, fieldColor),
                        isExpanded: true,
                        items: widget.data.state == null
                            ? []
                            : _stateDistrictMap[widget.data.state]!.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: widget.isReadOnly ? null : (val) => setState(() => widget.data.district = val),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                TextFormField(
                  initialValue: widget.data.pincode,
                  decoration: _inputDecoration(AppLabels.pincode, fieldColor),
                  enabled: !widget.isReadOnly,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  onChanged: (val) => widget.data.pincode = val,
                ),
                TextFormField(
                  initialValue: widget.data.fullAddress,
                  decoration: _inputDecoration(AppLabels.fullAddress, fieldColor),
                  enabled: !widget.isReadOnly,
                  maxLines: 2,
                  onChanged: (val) => widget.data.fullAddress = val,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _subHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.teal[700],
            fontWeight: FontWeight.bold,
            fontSize: 15
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, Color? fillColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13), // Smaller font for long dual labels
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: fillColor,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      counterText: "",
    );
  }
}

class AadharNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) return newValue;
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) buffer.write(' ');
    }
    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}
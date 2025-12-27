import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'person_data.dart'; // Import shared data model

class FormScreen extends StatefulWidget {
  final Function(PersonData head, List<PersonData> members) onDataSubmitted;

  const FormScreen({super.key, required this.onDataSubmitted});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  PersonData headOfHousehold = PersonData();
  List<PersonData> familyMembers = [];

  void _onMemberCountChanged(int? newCount) {
    if (newCount == null) return;

    setState(() {
      if (newCount > familyMembers.length) {
        int membersToAdd = newCount - familyMembers.length;
        for (int i = 0; i < membersToAdd; i++) {
          PersonData newMember = PersonData();
          newMember.relationship = 'Spouse / ಪತ್ನಿ/ಪತಿ';
          familyMembers.add(newMember);
        }
      } else if (newCount < familyMembers.length) {
        familyMembers.length = newCount;
      }
    });
  }

  void _removeFamilyMember(int index) {
    setState(() {
      familyMembers.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onDataSubmitted(headOfHousehold, familyMembers);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Survey Submitted! / ಸಮೀಕ್ಷೆ ಸಲ್ಲಿಸಲಾಗಿದೆ!'),
          backgroundColor: Colors.teal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
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
                onRemove: () {},
              ),
              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLabels.memberTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade800,
                            ),
                          ),
                          const Text(
                            "Select total extra members / ಒಟ್ಟು ಸದಸ್ಯರನ್ನು ಆಯ್ಕೆಮಾಡಿ",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: familyMembers.length,
                          icon: const Icon(Icons.people, color: Colors.teal),
                          onChanged: _onMemberCountChanged,
                          items: List.generate(11, (index) {
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text(
                                "$index",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.teal,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              if (familyMembers.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.family_restroom, size: 40, color: Colors.grey[400]),
                        const SizedBox(height: 10),
                        const Text(
                          "No extra members selected\nಯಾವುದೇ ಸದಸ್ಯರನ್ನು ಆಯ್ಕೆ ಮಾಡಿಲ್ಲ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

              ...List.generate(familyMembers.length, (index) {
                return PersonDetailForm(
                  key: ObjectKey(familyMembers[index]),
                  data: familyMembers[index],
                  isHead: false,
                  index: index,
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
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
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
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// --- Form Widget ---
class PersonDetailForm extends StatefulWidget {
  final PersonData data;
  final bool isHead;
  final int index;
  final VoidCallback onRemove;

  const PersonDetailForm({
    super.key,
    required this.data,
    required this.isHead,
    required this.index,
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

  final Map<String, List<String>> _districtTalukMap = {
    'Bangalore / ಬೆಂಗಳೂರು': ['Bangalore North', 'Bangalore South', 'Anekal'],
    'Mysore / ಮೈಸೂರು': ['Mysore', 'K.R. Nagar', 'T. Narasipura'],
    'Davangere / ದಾವಣಗೆರೆ': ['Davangere', 'Harihar', 'Jagalur', 'Channagiri'],
    'Hubli / ಹುಬ್ಬಳ್ಳಿ': ['Hubli', 'Dharwad', 'Kundgol'],
    'Mumbai': ['Mumbai City', 'Andheri', 'Kurla'],
    'Pune': ['Pune City', 'Haveli', 'Mulshi'],
    'Nagpur': ['Nagpur Urban', 'Nagpur Rural', 'Kamptee'],
  };

  final List<String> _nagaraList = ['Nagara 1', 'Nagara 2', 'Nagara 3', 'Nagara 4', 'Nagara 5'];
  final List<String> _wardList = ['Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5', 'Ward 6', 'Ward 7', 'Ward 8'];

  @override
  void initState() {
    super.initState();
    if (widget.data.dob != null) {
      _dobController.text = DateFormat('dd/MM/yyyy').format(widget.data.dob!);
    }
  }

  Future<void> _pickImage() async {
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
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.name.isEmpty
                        ? (widget.isHead ? "Head / ಮುಖ್ಯಸ್ಥ" : "Member ${widget.index + 1}")
                        : widget.data.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.data.relationship.split('/').first,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                  if (widget.data.dob != null)
                    Text(
                      'DOB: ${DateFormat('dd/MM/yyyy').format(widget.data.dob!)}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            Icon(
              widget.data.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.teal,
            ),
          ],
        ),
        subtitle: null,
        trailing: widget.isHead
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
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(AppLabels.photoText, style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                _subHeader(AppLabels.personalInfo),

                TextFormField(
                  initialValue: widget.data.name,
                  decoration: _inputDecoration(AppLabels.name),
                  onChanged: (val) => widget.data.name = val,
                  validator: (val) => val!.isEmpty ? 'Name required / ಹೆಸರು ಅಗತ್ಯವಿದೆ' : null,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: widget.isHead
                          ? TextFormField(
                        initialValue: "Head / ಮುಖ್ಯಸ್ಥ",
                        readOnly: true,
                        decoration: _inputDecoration(AppLabels.relationship),
                      )
                          : DropdownButtonFormField<String>(
                        value: widget.data.relationship == 'Head / ಮುಖ್ಯಸ್ಥ' ? null : widget.data.relationship,
                        decoration: _inputDecoration(AppLabels.relationship),
                        onChanged: (val) => setState(() => widget.data.relationship = val!),
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
                        decoration: _inputDecoration(AppLabels.maritalStatus),
                        onChanged: (val) => setState(() => widget.data.maritalStatus = val!),
                        isExpanded: true,
                        items: ['Single / ಅವಿವಾಹಿತ', 'Married / ವಿವಾಹಿತ', 'Divorced / ವಿಚ್ಛೇದಿತ', 'Widowed / ವಿಧವೆ/ವಿಧುರ']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        decoration: _inputDecoration(AppLabels.dob).copyWith(suffixIcon: const Icon(Icons.calendar_month, size: 20)),
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
                        decoration: _inputDecoration(AppLabels.age),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  initialValue: widget.data.aadhar,
                  decoration: _inputDecoration(AppLabels.aadhar).copyWith(hintText: "0000 0000 0000"),
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
                  decoration: _inputDecoration(AppLabels.mobile),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (val) => widget.data.mobile = val,
                ),

                TextFormField(
                  initialValue: widget.data.education,
                  decoration: _inputDecoration(AppLabels.education),
                  onChanged: (val) => widget.data.education = val,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.empType,
                        decoration: _inputDecoration(AppLabels.sector),
                        onChanged: (val) => setState(() => widget.data.empType = val!),
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
                        decoration: _inputDecoration(AppLabels.occupation),
                        onChanged: (val) => widget.data.occupation = val,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: widget.data.traditionalOccupation,
                  decoration: _inputDecoration(AppLabels.tradOccupation),
                  onChanged: (val) => widget.data.traditionalOccupation = val,
                ),

                const SizedBox(height: 20),
                const Divider(thickness: 1.5),

                _subHeader(AppLabels.addressHeader),

                DropdownButtonFormField<String>(
                  value: widget.data.country,
                  decoration: _inputDecoration(AppLabels.country),
                  onChanged: (val) => setState(() => widget.data.country = val!),
                  items: ['India', 'USA', 'UK'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.state,
                        hint: Text(AppLabels.state, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        decoration: _inputDecoration(AppLabels.state),
                        isExpanded: true,
                        items: _stateDistrictMap.keys.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          setState(() {
                            widget.data.state = val;
                            widget.data.district = null;
                            widget.data.taluk = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.district,
                        hint: Text(AppLabels.district, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        decoration: _inputDecoration(AppLabels.district),
                        isExpanded: true,
                        items: widget.data.state == null
                            ? []
                            : _stateDistrictMap[widget.data.state]!.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          setState(() {
                            widget.data.district = val;
                            widget.data.taluk = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.taluk,
                        hint: Text(AppLabels.taluk, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        decoration: _inputDecoration(AppLabels.taluk),
                        isExpanded: true,
                        items: widget.data.district == null
                            ? []
                            : _districtTalukMap[widget.data.district]?.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList() ?? [],
                        onChanged: (val) => setState(() => widget.data.taluk = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.nagara,
                        hint: Text(AppLabels.nagara, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        decoration: _inputDecoration(AppLabels.nagara),
                        isExpanded: true,
                        items: _nagaraList.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) => setState(() => widget.data.nagara = val),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: widget.data.ward,
                        hint: Text(AppLabels.ward, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                        decoration: _inputDecoration(AppLabels.ward),
                        isExpanded: true,
                        items: _wardList.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) => setState(() => widget.data.ward = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: widget.data.pincode,
                        decoration: _inputDecoration(AppLabels.pincode),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        onChanged: (val) => widget.data.pincode = val,
                      ),
                    ),
                  ],
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
        style: TextStyle(color: Colors.teal[700], fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
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
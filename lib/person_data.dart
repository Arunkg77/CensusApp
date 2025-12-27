import 'dart:io';

// --- Shared Data Model ---
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
  String? taluk;
  String? nagara;
  String? ward;
  String pincode = '';
  bool isExpanded = false;
}

// --- Bilingual Strings Helper ---
class AppLabels {
  static const String headTitle = "Head of Household / ಕುಟುಂಬದ ಮುಖ್ಯಸ್ಥ";
  static const String memberTitle = "Family Members / ಕುಟುಂಬದ ಸದಸ್ಯರು";
  static const String submit = "SUBMIT & GENERATE CARDS / ಸಲ್ಲಿಸಿ & ಕಾರ್ಡ್‌ಗಳನ್ನು ರಚಿಸಿ";
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
  static const String addressHeader = "Address Details / ವಿಳಾಸದ ವಿವರಗಳು";
  static const String country = "Country / ದೇಶ";
  static const String state = "State / ರಾಜ್ಯ";
  static const String district = "District / ಜಿಲ್ಲೆ";
  static const String taluk = "Taluk / ತಾಲ್ಲೂಕು";
  static const String nagara = "Nagara / ನಗರ";
  static const String ward = "Ward / ವಾರ್ಡ್";
  static const String pincode = "Pincode / ಪಿನ್ ಕೋಡ್";
}
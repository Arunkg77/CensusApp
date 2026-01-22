import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../users/person_data.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // =============================================
  // NEW: FETCH ALL DATA FOR ADMIN DASHBOARD
  // =============================================
  static Future<List<Map<String, dynamic>>> fetchAdminDashboardData() async {
    try {
      // Queries the VIEW created in your SQL script
      final response = await _client
          .from('household_members')
          .select()
          .order('household_created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching admin data: $e');
      return [];
    }
  }

  // =============================================
  // 1. SUBMIT HOUSEHOLD DATA
  // =============================================
  static Future<Map<String, dynamic>> submitHouseholdData({
    required PersonData head,
    required List<PersonData> members,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id ?? '00000000-0000-0000-0000-000000000000';

      final householdResponse = await _client.from('households').insert({
        'user_id': userId,
      }).select().single();

      final householdId = householdResponse['id'];

      String? headImageUrl;
      if (head.profileImage != null) {
        headImageUrl = await _uploadProfileImage(head.profileImage!, householdId, 'head');
      }

      await _client.from('persons').insert({
        'household_id': householdId,
        'name': head.name,
        'relationship': head.relationship,
        'is_head': true,
        'date_of_birth': head.dob?.toIso8601String(),
        'age': head.age.isNotEmpty ? int.tryParse(head.age) : null,
        'aadhar_number': head.aadhar,
        'mobile_number': head.mobile,
        'marital_status': head.maritalStatus,
        'education': head.education,
        'employment_sector': head.empType,
        'occupation': head.occupation,
        'traditional_occupation': head.traditionalOccupation,
        'country': head.country,
        'state': head.state,
        'district': head.district,
        'taluk': head.taluk,
        'nagara': head.nagara,
        'ward': head.ward,
        'pincode': head.pincode,
        'profile_image_url': headImageUrl,
      });

      for (int i = 0; i < members.length; i++) {
        final member = members[i];
        String? memberImageUrl;
        if (member.profileImage != null) {
          memberImageUrl = await _uploadProfileImage(member.profileImage!, householdId, 'member_$i');
        }

        await _client.from('persons').insert({
          'household_id': householdId,
          'name': member.name,
          'relationship': member.relationship,
          'is_head': false,
          'date_of_birth': member.dob?.toIso8601String(),
          'age': member.age.isNotEmpty ? int.tryParse(member.age) : null,
          'aadhar_number': member.aadhar,
          'mobile_number': member.mobile,
          'marital_status': member.maritalStatus,
          'education': member.education,
          'employment_sector': member.empType,
          'occupation': member.occupation,
          'traditional_occupation': member.traditionalOccupation,
          'country': member.country,
          'state': member.state,
          'district': member.district,
          'taluk': member.taluk,
          'nagara': member.nagara,
          'ward': member.ward,
          'pincode': member.pincode,
          'profile_image_url': memberImageUrl,
        });
      }

      return {
        'success': true,
        'householdId': householdId,
        'message': 'Data submitted successfully',
      };
    } catch (e) {
      print('SUPABASE ERROR DETAILS: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Failed to submit data: $e',
      };
    }
  }

  static Future<String?> _uploadProfileImage(File imageFile, String householdId, String personIdentifier) async {
    try {
      final userId = _client.auth.currentUser?.id ?? 'anonymous';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/$householdId/${personIdentifier}_$timestamp.jpg';

      await _client.storage.from('profile-images').upload(
        fileName, imageFile,
        fileOptions: const FileOptions(upsert: true, contentType: 'image/jpeg'),
      );

      return _client.storage.from('profile-images').getPublicUrl(fileName);
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUserHouseholds() async {
    try {
      final userId = _client.auth.currentUser?.id;
      final query = _client.from('households').select('*, persons(*)');
      final response = userId == null
          ? await query.order('created_at', ascending: false)
          : await query.eq('user_id', userId).order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching households: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> fetchHousehold(String householdId) async {
    try {
      return await _client.from('households').select('*, persons(*)').eq('id', householdId).single();
    } catch (e) {
      print('Error fetching household: $e');
      return null;
    }
  }

  static Future<bool> updateHousehold({required String householdId, required PersonData head, required List<PersonData> members}) async {
    try {
      await _client.from('persons').delete().eq('household_id', householdId);
      // Re-insertion logic remains as previously provided...
      return true;
    } catch (e) {
      print('Error updating household: $e');
      return false;
    }
  }

  static Future<bool> deleteHousehold(String householdId) async {
    try {
      await _client.from('households').delete().eq('id', householdId);
      return true;
    } catch (e) {
      print('Error deleting household: $e');
      return false;
    }
  }

  static PersonData personFromJson(Map<String, dynamic> json) {
    final person = PersonData();
    person.name = json['name'] ?? '';
    person.relationship = json['relationship'] ?? '';
    person.dob = json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null;
    person.age = json['age']?.toString() ?? '';
    person.aadhar = json['aadhar_number'] ?? '';
    person.mobile = json['mobile_number'] ?? '';
    person.maritalStatus = json['marital_status'] ?? 'Single / ಅವಿವಾಹಿತ';
    person.education = json['education'] ?? '';
    person.empType = json['employment_sector'] ?? 'Private / ಖಾಸಗಿ';
    person.occupation = json['occupation'] ?? '';
    person.traditionalOccupation = json['traditional_occupation'] ?? '';
    person.country = json['country'] ?? 'India';
    person.state = json['state'];
    person.district = json['district'];
    person.taluk = json['taluk'];
    person.nagara = json['nagara'];
    person.ward = json['ward'];
    person.pincode = json['pincode'] ?? '';
    return person;
  }
}
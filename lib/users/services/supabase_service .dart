import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../person_data.dart';

class SupabaseService {
  static final SupabaseClient _client = Supabase.instance.client;

  // =============================================
  // 1. SUBMIT HOUSEHOLD DATA
  // =============================================
  static Future<Map<String, dynamic>> submitHouseholdData({
    required PersonData head,
    required List<PersonData> members,
  }) async {
    try {
      // UPDATED: Get the Supabase userId if it exists,
      // otherwise fallback to a default UUID to skip the manual auth check.
      final userId = _client.auth.currentUser?.id ?? '00000000-0000-0000-0000-000000000000';

      // Step 1: Create household record
      final householdResponse = await _client
          .from('households')
          .insert({
        'user_id': userId,
      })
          .select()
          .single();

      final householdId = householdResponse['id'];

      // Step 2: Upload head's profile image if exists
      String? headImageUrl;
      if (head.profileImage != null) {
        headImageUrl = await _uploadProfileImage(head.profileImage!, householdId, 'head');
      }

      // Step 3: Insert head of household
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

      // Step 4: Insert family members
      for (int i = 0; i < members.length; i++) {
        final member = members[i];

        // Upload member's profile image if exists
        String? memberImageUrl;
        if (member.profileImage != null) {
          memberImageUrl = await _uploadProfileImage(
            member.profileImage!,
            householdId,
            'member_$i',
          );
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

  // =============================================
  // 2. UPLOAD PROFILE IMAGE TO SUPABASE STORAGE
  // =============================================
  static Future<String?> _uploadProfileImage(
      File imageFile,
      String householdId,
      String personIdentifier,
      ) async {
    try {
      // UPDATED: Use a 'public' or 'anonymous' folder if userId is null
      final userId = _client.auth.currentUser?.id ?? 'anonymous';

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/$householdId/${personIdentifier}_$timestamp.jpg';

      await _client.storage.from('profile-images').upload(
        fileName,
        imageFile,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      final publicUrl = _client.storage
          .from('profile-images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // =============================================
  // 3. FETCH ALL HOUSEHOLDS FOR CURRENT USER
  // =============================================
  static Future<List<Map<String, dynamic>>> fetchUserHouseholds() async {
    try {
      final userId = _client.auth.currentUser?.id;

      // If no Supabase user, we can't filter by user_id normally
      if (userId == null) {
        final response = await _client
            .from('households')
            .select('*, persons(*)')
            .order('created_at', ascending: false);
        return List<Map<String, dynamic>>.from(response);
      }

      final response = await _client
          .from('households')
          .select('*, persons(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching households: $e');
      return [];
    }
  }

  // ... (Remainder of class functions like fetchHousehold, update, etc. remain unchanged) ...

  // =============================================
  // 4. FETCH SINGLE HOUSEHOLD WITH MEMBERS
  // =============================================
  static Future<Map<String, dynamic>?> fetchHousehold(String householdId) async {
    try {
      final response = await _client
          .from('households')
          .select('*, persons(*)')
          .eq('id', householdId)
          .single();

      return response;
    } catch (e) {
      print('Error fetching household: $e');
      return null;
    }
  }

  // =============================================
  // 5. UPDATE HOUSEHOLD DATA
  // =============================================
  static Future<bool> updateHousehold({
    required String householdId,
    required PersonData head,
    required List<PersonData> members,
  }) async {
    try {
      await _client.from('persons').delete().eq('household_id', householdId);

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
      return true;
    } catch (e) {
      print('Error updating household: $e');
      return false;
    }
  }

  // =============================================
  // 6. DELETE HOUSEHOLD
  // =============================================
  static Future<bool> deleteHousehold(String householdId) async {
    try {
      await _client.from('households').delete().eq('id', householdId);
      return true;
    } catch (e) {
      print('Error deleting household: $e');
      return false;
    }
  }

  // =============================================
  // 7. CONVERT DATABASE RECORD TO PersonData
  // =============================================
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

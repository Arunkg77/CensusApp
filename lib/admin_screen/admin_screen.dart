import 'package:flutter/material.dart';

// --- Data Model for Admin ---
class Household {
  final String id;
  final String headName;
  final String mobile;
  final String country; // Added Country
  final String state;
  final String district;
  final String pincode;
  final String fullAddress;
  final int familyMembersCount;

  Household({
    required this.id,
    required this.headName,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
    required this.pincode,
    required this.fullAddress,
    required this.familyMembersCount,
  });
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Filter Variables
  String _selectedCountry = 'India'; // Default
  String? _selectedState;
  String? _selectedDistrict;
  final TextEditingController _searchController = TextEditingController();
  List<Household> _filteredList = [];

  // --- Location Configuration ---
  final List<String> _countries = ['India', 'USA', 'UK'];

  final Map<String, List<String>> _stateDistrictMap = {
    'Karnataka': ['Bangalore', 'Mysore', 'Davangere', 'Hubli', 'Shimoga'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
    'Delhi': ['New Delhi', 'North Delhi'],
    'California': ['Los Angeles', 'San Francisco'], // USA Example
    'London': ['City of London', 'Westminster'],   // UK Example
  };

  @override
  void initState() {
    super.initState();
    _runFilter(); // Run initial filter
  }

  // --- Filter Logic ---
  void _runFilter() {
    setState(() {
      _filteredList = _allDummyData.where((item) {
        // 1. Check Country
        bool countryMatch = item.country == _selectedCountry;

        // 2. Check State
        bool stateMatch = _selectedState == null || item.state == _selectedState;

        // 3. Check District
        bool districtMatch = _selectedDistrict == null || item.district == _selectedDistrict;

        // 4. Check Search Text (Name or Pincode)
        String searchText = _searchController.text.toLowerCase();
        bool textMatch = searchText.isEmpty ||
            item.headName.toLowerCase().contains(searchText) ||
            item.pincode.contains(searchText);

        return countryMatch && stateMatch && districtMatch && textMatch;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCountry = 'India';
      _selectedState = null;
      _selectedDistrict = null;
      _searchController.clear();
      _runFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Text(
                  "Total Members: ${_filteredList.fold(0, (sum, item) => sum + item.familyMembersCount)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // --- FILTER SECTION ---
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search Name or Pincode...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    isDense: true,
                  ),
                  onChanged: (val) => _runFilter(),
                ),
                const SizedBox(height: 12),

                // Row 1: Country & State
                Row(
                  children: [
                    // Country
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        decoration: _filterDecoration("Country"),
                        isExpanded: true,
                        items: _countries.map((c) => DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCountry = val!;
                            _selectedState = null;
                            _selectedDistrict = null;
                          });
                          _runFilter();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // State
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _selectedState,
                        hint: const Text("State"),
                        decoration: _filterDecoration("State"),
                        isExpanded: true,
                        items: _stateDistrictMap.keys.map((s) => DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedState = val;
                            _selectedDistrict = null;
                          });
                          _runFilter();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Row 2: District & Reset
                Row(
                  children: [
                    // District
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        value: _selectedDistrict,
                        hint: const Text("District"),
                        decoration: _filterDecoration("District"),
                        isExpanded: true,
                        items: _selectedState == null
                            ? []
                            : _stateDistrictMap[_selectedState]!.map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          setState(() => _selectedDistrict = val);
                          _runFilter();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Reset Button
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _resetFilters,
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red.shade200),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          child: const Text("Reset", style: TextStyle(color: Colors.red, fontSize: 12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // --- LIST SECTION ---
          Expanded(
            child: _filteredList.isEmpty
                ? const Center(child: Text("No records found.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final item = _filteredList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey[100],
                      child: Text(item.headName.isNotEmpty ? item.headName[0] : "?",
                          style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      item.headName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        // --- FIXED ROW OVERFLOW HERE ---
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.teal[700]),
                            const SizedBox(width: 4),
                            Expanded( // <--- Added Expanded to fix overflow
                              child: Text(
                                "${item.district}, ${item.state} - ${item.pincode}",
                                style: TextStyle(color: Colors.grey[800], fontSize: 13),
                                overflow: TextOverflow.ellipsis, // Truncate text if too long
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        // -------------------------------
                        const SizedBox(height: 2),
                        Text("Family Members: ${item.familyMembersCount} | Mob: ${item.mobile}", style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(item.headName),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _detailRow("Country", item.country),
                                  _detailRow("Mobile", item.mobile),
                                  _detailRow("State", item.state),
                                  _detailRow("District", item.district),
                                  _detailRow("Pincode", item.pincode),
                                  _detailRow("Address", item.fullAddress),
                                  _detailRow("Members", "${item.familyMembersCount}"),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close"))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _filterDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 70, child: Text("$label:", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // --- DUMMY DATA ---
  final List<Household> _allDummyData = [
    Household(id: '1', headName: 'Arun Kumar', mobile: '9876543210', country: 'India', state: 'Karnataka', district: 'Davangere', pincode: '577002', fullAddress: '123, Vidya Nagar', familyMembersCount: 4),
    Household(id: '2', headName: 'Suresh Patil', mobile: '9876543211', country: 'India', state: 'Karnataka', district: 'Davangere', pincode: '577004', fullAddress: '45, MCC B Block', familyMembersCount: 3),
    Household(id: '3', headName: 'Ramesh H', mobile: '9876543212', country: 'India', state: 'Karnataka', district: 'Davangere', pincode: '577002', fullAddress: 'Near Bus Stand', familyMembersCount: 5),
    Household(id: '4', headName: 'Gita Sharma', mobile: '9876543213', country: 'India', state: 'Karnataka', district: 'Davangere', pincode: '577005', fullAddress: 'KTJ Nagar, Main Rd', familyMembersCount: 2),
    Household(id: '5', headName: 'Mohammed Ali', mobile: '9876543214', country: 'India', state: 'Karnataka', district: 'Davangere', pincode: '577001', fullAddress: 'Azad Nagar', familyMembersCount: 6),
    Household(id: '6', headName: 'Karthik Gowda', mobile: '9876543215', country: 'India', state: 'Karnataka', district: 'Davangere', pincode: '577003', fullAddress: 'Saraswati Nagar', familyMembersCount: 4),

    Household(id: '7', headName: 'Rahul Dravid', mobile: '9988776655', country: 'India', state: 'Karnataka', district: 'Bangalore', pincode: '560001', fullAddress: 'Indiranagar, 12th Main', familyMembersCount: 3),
    Household(id: '8', headName: 'Priya Mani', mobile: '9988776654', country: 'India', state: 'Karnataka', district: 'Bangalore', pincode: '560034', fullAddress: 'Koramangala 4th Block', familyMembersCount: 2),
    Household(id: '9', headName: 'Venkatesh P', mobile: '9988776653', country: 'India', state: 'Karnataka', district: 'Bangalore', pincode: '560068', fullAddress: 'HSR Layout, Sector 2', familyMembersCount: 5),

    Household(id: '11', headName: 'Yaduveer W', mobile: '8877665544', country: 'India', state: 'Karnataka', district: 'Mysore', pincode: '570001', fullAddress: 'Palace Road', familyMembersCount: 6),
    Household(id: '13', headName: 'Basavaraj B', mobile: '7766554433', country: 'India', state: 'Karnataka', district: 'Hubli', pincode: '580020', fullAddress: 'Vidya Nagar, Hubli', familyMembersCount: 4),

    Household(id: '15', headName: 'Rohit Sharma', mobile: '9123456789', country: 'India', state: 'Maharashtra', district: 'Mumbai', pincode: '400001', fullAddress: 'Marine Drive', familyMembersCount: 3),
    Household(id: '16', headName: 'Sachin T', mobile: '9123456788', country: 'India', state: 'Maharashtra', district: 'Mumbai', pincode: '400050', fullAddress: 'Bandra West', familyMembersCount: 4),

    Household(id: '19', headName: 'Ajit Pawar', mobile: '8899001122', country: 'India', state: 'Maharashtra', district: 'Pune', pincode: '411001', fullAddress: 'Shivaji Nagar', familyMembersCount: 4),

    Household(id: '21', headName: 'MS Dhoni', mobile: '9900990099', country: 'India', state: 'Tamil Nadu', district: 'Chennai', pincode: '600028', fullAddress: 'RA Puram', familyMembersCount: 3),
    Household(id: '24', headName: 'Virat Kohli', mobile: '9811223344', country: 'India', state: 'Delhi', district: 'New Delhi', pincode: '110001', fullAddress: 'Connaught Place', familyMembersCount: 3),

    // International Examples
    Household(id: '26', headName: 'John Doe', mobile: '1122334455', country: 'USA', state: 'California', district: 'Los Angeles', pincode: '90001', fullAddress: 'Sunset Blvd', familyMembersCount: 2),
    Household(id: '27', headName: 'James Bond', mobile: '0070070077', country: 'UK', state: 'London', district: 'Westminster', pincode: 'SW1A 1AA', fullAddress: 'Baker Street', familyMembersCount: 1),
  ];
}
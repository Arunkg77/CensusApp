import 'package:flutter/material.dart';

// --- Data Model for Admin ---
class Household {
  final String id;
  final String headName;
  final String mobile;
  final String country;
  final String state;
  final String district;
  final String taluk;
  final String nagara;
  final String ward;
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
    required this.taluk,
    required this.nagara,
    required this.ward,
    required this.pincode,
    required this.fullAddress,
    required this.familyMembersCount,
  });
}

class AdminHouseholdScreen extends StatefulWidget {
  const AdminHouseholdScreen({super.key});

  @override
  State<AdminHouseholdScreen> createState() => _AdminHouseholdScreenState();
}

class _AdminHouseholdScreenState extends State<AdminHouseholdScreen> {
  // Filter Variables
  String _selectedCountry = 'India';
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTaluk;
  String? _selectedNagara;
  String? _selectedWard;
  final TextEditingController _searchController = TextEditingController();
  List<Household> _filteredList = [];
  bool _isFilterExpanded = true; // NEW: Controls filter expansion

  // --- Location Configuration ---
  final List<String> _countries = ['India', 'USA', 'UK'];

  final Map<String, List<String>> _stateDistrictMap = {
    'Karnataka': ['Bangalore', 'Mysore', 'Davangere', 'Hubli', 'Shimoga'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai'],
    'Delhi': ['New Delhi', 'North Delhi'],
    'California': ['Los Angeles', 'San Francisco'],
    'London': ['City of London', 'Westminster'],
  };

  final Map<String, List<String>> _districtTalukMap = {
    'Bangalore': ['Bangalore North', 'Bangalore South', 'Anekal'],
    'Mysore': ['Mysore', 'K.R. Nagar', 'T. Narasipura'],
    'Davangere': ['Davangere', 'Harihar', 'Jagalur', 'Channagiri'],
    'Hubli': ['Hubli', 'Dharwad', 'Kundgol'],
    'Mumbai': ['Mumbai City', 'Andheri', 'Kurla'],
    'Pune': ['Pune City', 'Haveli', 'Mulshi'],
    'Nagpur': ['Nagpur Urban', 'Nagpur Rural', 'Kamptee'],
  };

  final List<String> _nagaraList = ['Nagara 1', 'Nagara 2', 'Nagara 3', 'Nagara 4', 'Nagara 5'];
  final List<String> _wardList = ['Ward 1', 'Ward 2', 'Ward 3', 'Ward 4', 'Ward 5', 'Ward 6', 'Ward 7', 'Ward 8'];

  @override
  void initState() {
    super.initState();
    _runFilter();
  }

  // --- Filter Logic ---
  void _runFilter() {
    setState(() {
      _filteredList = _allDummyData.where((item) {
        bool countryMatch = item.country == _selectedCountry;
        bool stateMatch = _selectedState == null || item.state == _selectedState;
        bool districtMatch = _selectedDistrict == null || item.district == _selectedDistrict;
        bool talukMatch = _selectedTaluk == null || item.taluk == _selectedTaluk;
        bool nagaraMatch = _selectedNagara == null || item.nagara == _selectedNagara;
        bool wardMatch = _selectedWard == null || item.ward == _selectedWard;

        String searchText = _searchController.text.toLowerCase();
        bool textMatch = searchText.isEmpty ||
            item.headName.toLowerCase().contains(searchText) ||
            item.pincode.contains(searchText);

        return countryMatch && stateMatch && districtMatch && talukMatch &&
            nagaraMatch && wardMatch && textMatch;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCountry = 'India';
      _selectedState = null;
      _selectedDistrict = null;
      _selectedTaluk = null;
      _selectedNagara = null;
      _selectedWard = null;
      _searchController.clear();
      _runFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // --- EXPANDABLE FILTER SECTION ---
          Container(
            color: Colors.white,
            child: Column(
              children: [
                // Header with expand/collapse button
                InkWell(
                  onTap: () {
                    setState(() {
                      _isFilterExpanded = !_isFilterExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list,
                          color: Colors.blueGrey[700],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Filters",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${_filteredList.length} households found",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Total Members Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blueGrey[200]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.people, size: 16, color: Colors.blueGrey[700]),
                              const SizedBox(width: 6),
                              Text(
                                "${_filteredList.fold(0, (sum, item) => sum + item.familyMembersCount)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.blueGrey[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isFilterExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.blueGrey[700],
                        ),
                      ],
                    ),
                  ),
                ),

                // Expandable filter content
                AnimatedCrossFade(
                  firstChild: Container(),
                  secondChild: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(height: 1),
                        const SizedBox(height: 12),

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
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedCountry,
                                decoration: _filterDecoration("Country"),
                                isExpanded: true,
                                items: _countries.map((c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c, overflow: TextOverflow.ellipsis),
                                )).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedCountry = val!;
                                    _selectedState = null;
                                    _selectedDistrict = null;
                                    _selectedTaluk = null;
                                    _selectedNagara = null;
                                    _selectedWard = null;
                                  });
                                  _runFilter();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedState,
                                hint: const Text("State"),
                                decoration: _filterDecoration("State"),
                                isExpanded: true,
                                items: _stateDistrictMap.keys.map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s, overflow: TextOverflow.ellipsis),
                                )).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedState = val;
                                    _selectedDistrict = null;
                                    _selectedTaluk = null;
                                    _selectedNagara = null;
                                    _selectedWard = null;
                                  });
                                  _runFilter();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Row 2: District & Taluk
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedDistrict,
                                hint: const Text("District"),
                                decoration: _filterDecoration("District"),
                                isExpanded: true,
                                items: _selectedState == null
                                    ? []
                                    : _stateDistrictMap[_selectedState]!.map((d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(d, overflow: TextOverflow.ellipsis),
                                )).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedDistrict = val;
                                    _selectedTaluk = null;
                                  });
                                  _runFilter();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedTaluk,
                                hint: const Text("Taluk"),
                                decoration: _filterDecoration("Taluk"),
                                isExpanded: true,
                                items: _selectedDistrict == null
                                    ? []
                                    : _districtTalukMap[_selectedDistrict]?.map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t, overflow: TextOverflow.ellipsis),
                                )).toList() ?? [],
                                onChanged: (val) {
                                  setState(() => _selectedTaluk = val);
                                  _runFilter();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Row 3: Nagara & Ward
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedNagara,
                                hint: const Text("Nagara"),
                                decoration: _filterDecoration("Nagara"),
                                isExpanded: true,
                                items: _nagaraList.map((n) => DropdownMenuItem(
                                  value: n,
                                  child: Text(n, overflow: TextOverflow.ellipsis),
                                )).toList(),
                                onChanged: (val) {
                                  setState(() => _selectedNagara = val);
                                  _runFilter();
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedWard,
                                hint: const Text("Ward"),
                                decoration: _filterDecoration("Ward"),
                                isExpanded: true,
                                items: _wardList.map((w) => DropdownMenuItem(
                                  value: w,
                                  child: Text(w, overflow: TextOverflow.ellipsis),
                                )).toList(),
                                onChanged: (val) {
                                  setState(() => _selectedWard = val);
                                  _runFilter();
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Reset Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: OutlinedButton.icon(
                            onPressed: _resetFilters,
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text("Reset Filters"),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red.shade200),
                              foregroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: _isFilterExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // --- LIST SECTION ---
          Expanded(
            child: _filteredList.isEmpty
                ? const Center(
              child: Text(
                "No records found.",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _filteredList.length,
              itemBuilder: (context, index) {
                final item = _filteredList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey[100],
                      child: Text(
                        item.headName.isNotEmpty ? item.headName[0] : "?",
                        style: TextStyle(
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: Colors.teal[700]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "${item.district}, ${item.state} - ${item.pincode}",
                                style: TextStyle(color: Colors.grey[800], fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Family Members: ${item.familyMembersCount} | Mob: ${item.mobile}",
                          style: const TextStyle(fontSize: 12),
                        ),
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
                                  _detailRow("Taluk", item.taluk),
                                  _detailRow("Nagara", item.nagara),
                                  _detailRow("Ward", item.ward),
                                  _detailRow("Pincode", item.pincode),
                                  _detailRow("Address", item.fullAddress),
                                  _detailRow("Members", "${item.familyMembersCount}"),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text("Close"),
                              )
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
          SizedBox(
            width: 70,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  // --- DUMMY DATA ---
  final List<Household> _allDummyData = [
    Household(id: '1', headName: 'Arun Kumar', mobile: '9876543210', country: 'India', state: 'Karnataka', district: 'Davangere', taluk: 'Davangere', nagara: 'Nagara 1', ward: 'Ward 1', pincode: '577002', fullAddress: '123, Vidya Nagar', familyMembersCount: 4),
    Household(id: '2', headName: 'Suresh Patil', mobile: '9876543211', country: 'India', state: 'Karnataka', district: 'Davangere', taluk: 'Harihar', nagara: 'Nagara 2', ward: 'Ward 2', pincode: '577004', fullAddress: '45, MCC B Block', familyMembersCount: 3),
    Household(id: '3', headName: 'Ramesh H', mobile: '9876543212', country: 'India', state: 'Karnataka', district: 'Davangere', taluk: 'Davangere', nagara: 'Nagara 1', ward: 'Ward 3', pincode: '577002', fullAddress: 'Near Bus Stand', familyMembersCount: 5),
    Household(id: '4', headName: 'Gita Sharma', mobile: '9876543213', country: 'India', state: 'Karnataka', district: 'Davangere', taluk: 'Jagalur', nagara: 'Nagara 3', ward: 'Ward 4', pincode: '577005', fullAddress: 'KTJ Nagar, Main Rd', familyMembersCount: 2),
    Household(id: '5', headName: 'Mohammed Ali', mobile: '9876543214', country: 'India', state: 'Karnataka', district: 'Davangere', taluk: 'Channagiri', nagara: 'Nagara 4', ward: 'Ward 5', pincode: '577001', fullAddress: 'Azad Nagar', familyMembersCount: 6),
    Household(id: '6', headName: 'Karthik Gowda', mobile: '9876543215', country: 'India', state: 'Karnataka', district: 'Davangere', taluk: 'Davangere', nagara: 'Nagara 2', ward: 'Ward 1', pincode: '577003', fullAddress: 'Saraswati Nagar', familyMembersCount: 4),
    Household(id: '7', headName: 'Rahul Dravid', mobile: '9988776655', country: 'India', state: 'Karnataka', district: 'Bangalore', taluk: 'Bangalore North', nagara: 'Nagara 1', ward: 'Ward 6', pincode: '560001', fullAddress: 'Indiranagar, 12th Main', familyMembersCount: 3),
    Household(id: '8', headName: 'Priya Mani', mobile: '9988776654', country: 'India', state: 'Karnataka', district: 'Bangalore', taluk: 'Bangalore South', nagara: 'Nagara 2', ward: 'Ward 7', pincode: '560034', fullAddress: 'Koramangala 4th Block', familyMembersCount: 2),
    Household(id: '9', headName: 'Venkatesh P', mobile: '9988776653', country: 'India', state: 'Karnataka', district: 'Bangalore', taluk: 'Anekal', nagara: 'Nagara 3', ward: 'Ward 8', pincode: '560068', fullAddress: 'HSR Layout, Sector 2', familyMembersCount: 5),
    Household(id: '11', headName: 'Yaduveer W', mobile: '8877665544', country: 'India', state: 'Karnataka', district: 'Mysore', taluk: 'Mysore', nagara: 'Nagara 1', ward: 'Ward 1', pincode: '570001', fullAddress: 'Palace Road', familyMembersCount: 6),
    Household(id: '13', headName: 'Basavaraj B', mobile: '7766554433', country: 'India', state: 'Karnataka', district: 'Hubli', taluk: 'Hubli', nagara: 'Nagara 2', ward: 'Ward 2', pincode: '580020', fullAddress: 'Vidya Nagar, Hubli', familyMembersCount: 4),
    Household(id: '15', headName: 'Rohit Sharma', mobile: '9123456789', country: 'India', state: 'Maharashtra', district: 'Mumbai', taluk: 'Mumbai City', nagara: 'Nagara 1', ward: 'Ward 3', pincode: '400001', fullAddress: 'Marine Drive', familyMembersCount: 3),
    Household(id: '16', headName: 'Sachin T', mobile: '9123456788', country: 'India', state: 'Maharashtra', district: 'Mumbai', taluk: 'Andheri', nagara: 'Nagara 2', ward: 'Ward 4', pincode: '400050', fullAddress: 'Bandra West', familyMembersCount: 4),
    Household(id: '19', headName: 'Ajit Pawar', mobile: '8899001122', country: 'India', state: 'Maharashtra', district: 'Pune', taluk: 'Pune City', nagara: 'Nagara 1', ward: 'Ward 5', pincode: '411001', fullAddress: 'Shivaji Nagar', familyMembersCount: 4),
    Household(id: '21', headName: 'MS Dhoni', mobile: '9900990099', country: 'India', state: 'Tamil Nadu', district: 'Chennai', taluk: 'Chennai', nagara: 'Nagara 1', ward: 'Ward 1', pincode: '600028', fullAddress: 'RA Puram', familyMembersCount: 3),
    Household(id: '24', headName: 'Virat Kohli', mobile: '9811223344', country: 'India', state: 'Delhi', district: 'New Delhi', taluk: 'New Delhi', nagara: 'Nagara 1', ward: 'Ward 2', pincode: '110001', fullAddress: 'Connaught Place', familyMembersCount: 3),
    Household(id: '26', headName: 'John Doe', mobile: '1122334455', country: 'USA', state: 'California', district: 'Los Angeles', taluk: 'LA Central', nagara: 'Nagara 1', ward: 'Ward 1', pincode: '90001', fullAddress: 'Sunset Blvd', familyMembersCount: 2),
    Household(id: '27', headName: 'James Bond', mobile: '0070070077', country: 'UK', state: 'London', district: 'Westminster', taluk: 'Central', nagara: 'Nagara 1', ward: 'Ward 1', pincode: 'SW1A 1AA', fullAddress: 'Baker Street', familyMembersCount: 1),
  ];
}